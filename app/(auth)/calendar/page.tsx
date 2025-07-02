'use client'

import React, { useEffect, useState } from 'react'
import FullCalendar from '@fullcalendar/react'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import dayjs from 'dayjs'
import { Skeleton } from '@/components/ui/skeleton'
import { Booking } from '@/types/booking'
import { Tooltip as ReactTooltip } from 'react-tooltip'
import 'react-tooltip/dist/react-tooltip.css'
import timeGridPlugin from '@fullcalendar/timegrid'
import BookingFlowDialog from '@/components/custom/booking-flow-dialog'
import { Course } from '@/types/course'
import { Trainer } from '@/types'
import { Room } from '@/types/room'
import { Language } from '@/types/language'
import { Category } from '@/types/category'
import { Location } from '@/types/location'
import axios from 'axios'
import toast from 'react-hot-toast'
import { Dialog } from '@/components/ui/dialog'
import { Textarea } from '@/components/ui/textarea'
import { Button } from '@/components/ui/button'
import { Plus, ClipboardList, Trash2 } from 'lucide-react'
import { useForm } from 'react-hook-form'
import * as yup from 'yup'
import { yupResolver } from '@hookform/resolvers/yup'
import { FloatingLabelInput } from '@/components/ui/FloatingLabelInput'
import {
    TooltipProvider,
    Tooltip,
    TooltipTrigger,
    TooltipContent,
} from '@/components/ui/tooltip'

interface DailyNote {
    id?: string
    date: string // ISO string
    note: string
    createdAt?: string
    updatedAt?: string
}

const dailyNoteSchema = yup.object({
    note: yup.string().required('Note cannot be empty'),
})

export default function CalendarPage() {
    const [bookings, setBookings] = useState<Booking[]>([])
    const [loading, setLoading] = useState(true)
    const [isBookingFlowDialogOpen, setIsBookingFlowDialogOpen] =
        useState(false)
    const [selectedBookingForDialog, setSelectedBookingForDialog] =
        useState<Booking | null>(null)
    const [courses, setCourses] = useState<Course[]>([])
    const [trainers, setTrainers] = useState<Trainer[]>([])
    const [rooms, setRooms] = useState<Room[]>([])
    const [languages, setLanguages] = useState<Language[]>([])
    const [categories, setCategories] = useState<Category[]>([])
    const [locations, setLocations] = useState<Location[]>([])
    const [dailyNotes, setDailyNotes] = useState<Record<string, DailyNote>>({}) // Explicitly type useState
    const [noteDialogOpen, setNoteDialogOpen] = useState(false)
    const [selectedNoteDate, setSelectedNoteDate] = useState<Date | null>(null)
    const [currentDailyNote, setCurrentDailyNote] = useState<DailyNote | null>(
        null,
    )
    const [noteFormLoading, setNoteFormLoading] = useState(false)

    const {
        register,
        handleSubmit,
        reset,
        setValue,
        watch,
        formState: { errors },
    } = useForm({
        resolver: yupResolver(dailyNoteSchema),
        defaultValues: {
            note: '',
        },
    })

    useEffect(() => {
        const fetchBookings = async () => {
            try {
                const res = await fetch('/api/bookings?page=1&pageSize=9999')
                const data = await res.json()
                setBookings(Array.isArray(data.bookings) ? data.bookings : [])
            } catch (error) {
                console.error('Error fetching bookings:', error)
            } finally {
                setLoading(false)
            }
        }

        fetchBookings()
        fetchDropdowns()
        fetchDailyNotes()
    }, [])

    const fetchDropdowns = async () => {
        try {
            const res = await axios.get('/api/bookings/dropdowns')
            const data = res.data
            setCourses(Array.isArray(data.courses) ? data.courses : [])
            setTrainers(Array.isArray(data.trainers) ? data.trainers : [])
            setRooms(Array.isArray(data.rooms) ? data.rooms : [])
            setLanguages(data.languages || [])
            setCategories(data.categories || [])
            setLocations(Array.isArray(data.locations) ? data.locations : [])
        } catch (error) {
            toast.error('Failed to fetch dropdowns')
            console.error('Error fetching dropdowns:', error)
        }
    }

    const fetchDailyNotes = async () => {
        try {
            const res = await axios.get('/api/daily-notes')
            const notesArray: DailyNote[] = res.data
            const notesMap: Record<string, DailyNote> = notesArray.reduce<
                Record<string, DailyNote>
            >((acc, note) => {
                acc[dayjs(note.date).format('YYYY-MM-DD')] = note
                return acc
            }, {}) // Initial value is an empty object of the correct type
            setDailyNotes(notesMap)
        } catch (error) {
            toast.error('Failed to fetch daily notes')
            console.error('Error fetching daily notes:', error)
        }
    }

    const handleAddOrEditNote = async (data: { note: string }) => {
        if (!selectedNoteDate) return
        setNoteFormLoading(true)

        // Ensure we're using the same date handling as openNoteDialog
        const localDate = dayjs(selectedNoteDate).startOf('day').toDate()
        const dateString = dayjs(localDate).format('YYYY-MM-DD')

        console.log('Saving note for date:', dateString)
        console.log('Selected note date:', selectedNoteDate)
        console.log('Local date:', localDate)

        try {
            if (currentDailyNote) {
                // Update existing note
                await axios.put('/api/daily-notes', {
                    date: dateString,
                    note: data.note,
                })
                toast.success('Note updated successfully!')
            } else {
                // Create new note
                await axios.post('/api/daily-notes', {
                    date: dateString,
                    note: data.note,
                })
                toast.success('Note added successfully!')
            }
            setNoteDialogOpen(false)
            fetchDailyNotes() // Re-fetch notes to update calendar
        } catch (error) {
            toast.error('Failed to save note')
            console.error('Error saving note:', error)
        } finally {
            setNoteFormLoading(false)
        }
    }

    const handleDeleteNote = async () => {
        if (!selectedNoteDate) return
        setNoteFormLoading(true)

        // Ensure we're using the same date handling as openNoteDialog
        const localDate = dayjs(selectedNoteDate).startOf('day').toDate()
        const dateString = dayjs(localDate).format('YYYY-MM-DD')

        try {
            await axios.delete(`/api/daily-notes?date=${dateString}`)
            toast.success('Note deleted successfully!')
            setNoteDialogOpen(false)
            fetchDailyNotes() // Re-fetch notes to update calendar
        } catch (error) {
            toast.error('Failed to delete note')
            console.error('Error deleting note:', error)
        } finally {
            setNoteFormLoading(false)
        }
    }

    const openNoteDialog = (date: Date) => {
        console.log('Original date from FullCalendar:', date)
        console.log('Date as ISO string:', date.toISOString())

        // Ensure we're working with the local date, not UTC
        const localDate = dayjs(date).startOf('day').toDate()
        console.log('Local date after dayjs processing:', localDate)

        setSelectedNoteDate(localDate)
        const dateKey = dayjs(localDate).format('YYYY-MM-DD')
        console.log('Date key for lookup:', dateKey)

        const existingNote = dailyNotes[dateKey]

        if (existingNote) {
            setCurrentDailyNote(existingNote)
            setValue('note', existingNote.note)
        } else {
            setCurrentDailyNote(null)
            reset({ note: '' })
        }
        setNoteDialogOpen(true)
    }

    const formatTime = (start: string, end: string) => {
        if (!start || !end) return 'N/A'
        const formattedStart = dayjs(start).format('hh:mm A')
        const formattedEnd = dayjs(end).format('hh:mm A')
        return `${formattedStart} - ${formattedEnd}`
    }

    if (!Array.isArray(bookings)) return null

    const bookingsByDate: Record<string, Booking[]> = {}

    for (const b of bookings) {
        const dateKey = dayjs(b.date).format('YYYY-MM-DD')
        if (!bookingsByDate[dateKey]) bookingsByDate[dateKey] = []
        bookingsByDate[dateKey].push(b)
    }

    const events = Object.entries(bookingsByDate).flatMap(
        ([_, bookingsForDate]) =>
            bookingsForDate
                .sort((a, b) => {
                    const colorA = a.location?.backgroundColor || ''
                    const colorB = b.location?.backgroundColor || ''
                    return colorA.localeCompare(colorB)
                })
                .map((b) => {
                    const confirmed =
                        b.delegates?.filter((d) => d.status === 'CONFIRMED')
                            ?.length || 0
                    const notConfirmed =
                        b.delegates?.filter((d) => d.status === 'NOT_CONFIRMED')
                            ?.length || 0
                    const capacity = (b.room as any)?.capacity || 0
                    const free = capacity - (confirmed + notConfirmed)

                    const backgroundColor =
                        b.location?.backgroundColor || '#dbeafe'
                    const textColor = b.location?.textColor || '#1f3a8a'
                    const tooltipId = `tooltip-${b.id}`
                    const tooltipHTML = `
                    <div style='font-weight: bold;'>${b.course?.shortname || b.course?.title} - ${(b.room as any)?.name || ''} - ${b.language || ''}</div>
                    <div><span style='color:#4B5563;'>Language:</span> ${b.language}</div>
                    <div><span style='color:#4B5563;'>Trainer:</span> ${b.trainer?.name}</div>
                    <div><span style='color:#4B5563;'>Location:</span> ${b.location?.name}</div>
                    <div><span style='color:#4B5563;'>Room:</span> ${(b.room as any)?.name}</div>
                    <div><span style='color:#4B5563;'>Category:</span> ${b.course?.category?.name}</div>
                    <div><span style='color:#4B5563;'>Time:</span> ${formatTime(b.startTime, b.endTime)}</div>
                    ${b.notes ? `<div><span style='color:#4B5563;'>Notes:</span> ${b.notes}</div>` : ''}
                    <div style='margin-top:5px;'>
                        <span style='background:#D1FAE5;color:#065F46;padding:2px 5px;border-radius:4px;'>Confirmed: ${confirmed}</span>
                        <span style='background:#FEE2E2;color:#991B1B;padding:2px 5px;border-radius:4px;margin-left:4px;'>Not Confirmed: ${notConfirmed}</span>
                        <span style='background:#DBEAFE;color:#1E40AF;padding:2px 5px;border-radius:4px;margin-left:4px;'>Free: ${free}</span>
                    </div>
                `

                    return {
                        id: b.id,
                        title: `${b.course?.shortname || b.course?.title} - ${(b.room as any)?.name || ''}`,
                        start: dayjs(b.date)
                            .hour(dayjs(b.startTime).hour())
                            .minute(dayjs(b.startTime).minute())
                            .toISOString(),
                        end: dayjs(b.date)
                            .hour(dayjs(b.endTime).hour())
                            .minute(dayjs(b.endTime).minute())
                            .toISOString(),
                        extendedProps: {
                            ...b,
                            tooltipId,
                            tooltipHTML,
                            backgroundColor,
                            textColor,
                            sortOrder: b.location?.backgroundColor || '', // this is the key!
                        },
                    }
                }),
    )

    if (loading) {
        return (
            <div className="animate-pulse p-6">
                <h1 className="mb-4 text-2xl font-bold">
                    Training Calendar Overview
                </h1>
                <div className="grid grid-cols-7 gap-2">
                    {[...Array(35)].map((_, i) => (
                        <Skeleton key={i} className="h-28 w-full rounded-md" />
                    ))}
                </div>
            </div>
        )
    }

    return (
        <div className="relative p-6">
            <h1 className="mb-4 text-2xl font-bold">
                Training Calendar Overview
            </h1>

            <FullCalendar
                plugins={[dayGridPlugin, timeGridPlugin, interactionPlugin]}
                initialView="dayGridMonth"
                headerToolbar={{
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay',
                }}
                events={events}
                eventOrder="extendedProps.sortOrder"
                height="auto"
                eventClick={(arg) => {
                    const clickedBooking = arg.event.extendedProps as Booking
                    // Explicitly reconstruct the booking object to ensure reactivity and full data
                    setSelectedBookingForDialog({
                        ...clickedBooking,
                        room: clickedBooking.room
                            ? { ...clickedBooking.room }
                            : { id: '', name: '', capacity: 0, locationId: '' }, // Ensure room is always a complete object
                        location: clickedBooking.location
                            ? { ...clickedBooking.location }
                            : { name: '' }, // Ensure location is always an object
                    })
                    setIsBookingFlowDialogOpen(true)
                }}
                dayCellContent={(arg) => {
                    const dateKey = dayjs(arg.date).format('YYYY-MM-DD')
                    const noteForDay = dailyNotes[dateKey]
                    return (
                        <>
                            <div className="fc-daygrid-day-top flex justify-between p-1">
                                <a className="fc-daygrid-day-number">
                                    {arg.dayNumberText}
                                </a>
                                <div className="flex gap-1">
                                    {noteForDay ? (
                                        <TooltipProvider delayDuration={0}>
                                            <Tooltip>
                                                <TooltipTrigger asChild>
                                                    <button
                                                        onClick={() =>
                                                            openNoteDialog(
                                                                arg.date,
                                                            )
                                                        }
                                                        className="z-10 rounded-full bg-yellow-100 p-1 text-yellow-800 hover:bg-yellow-200"
                                                    >
                                                        <ClipboardList className="h-4 w-4" />
                                                    </button>
                                                </TooltipTrigger>
                                                <TooltipContent
                                                    side="top"
                                                    sideOffset={5}
                                                    align="center"
                                                    avoidCollisions={true}
                                                >
                                                    {noteForDay.note}
                                                </TooltipContent>
                                            </Tooltip>
                                        </TooltipProvider>
                                    ) : (
                                        <button
                                            onClick={() =>
                                                openNoteDialog(arg.date)
                                            }
                                            className="z-10 rounded-full bg-blue-100 p-1 text-blue-800 hover:bg-blue-200"
                                        >
                                            <Plus className="h-4 w-4" />
                                        </button>
                                    )}
                                </div>
                            </div>
                        </>
                    )
                }}
                eventContent={(arg) => (
                    <div
                        style={{
                            position: 'relative',
                            zIndex: 1,
                            isolation: 'isolate',
                        }}
                        data-tooltip-id={`tooltip-${arg.event.id}`}
                        data-tooltip-html={arg.event.extendedProps.tooltipHTML}
                    >
                        <div
                            className="rounded p-1 text-xs shadow-sm"
                            style={{
                                backgroundColor:
                                    arg.event.extendedProps.backgroundColor,
                                color: arg.event.extendedProps.textColor,
                            }}
                        >
                            <div className="font-semibold">
                                {arg.event.title}
                                {arg.event.extendedProps.language ? (
                                    <span>
                                        {' - ' +
                                            arg.event.extendedProps.language}
                                    </span>
                                ) : null}
                            </div>
                        </div>
                    </div>
                )}
            />

            {/* Booking Management Dialog */}
            <BookingFlowDialog
                isOpen={isBookingFlowDialogOpen}
                onClose={() => {
                    setIsBookingFlowDialogOpen(false)
                    setSelectedBookingForDialog(null)
                    // Re-fetch bookings to ensure calendar is updated after add/edit
                    const fetchBookings = async () => {
                        try {
                            const res = await fetch(
                                '/api/bookings?page=1&pageSize=9999',
                            )
                            const data = await res.json()
                            setBookings(
                                Array.isArray(data.bookings)
                                    ? data.bookings
                                    : [],
                            )
                        } catch (error) {
                            console.error('Error fetching bookings:', error)
                        }
                    }
                    fetchBookings()
                }}
                initialBooking={selectedBookingForDialog}
                courses={courses}
                trainers={trainers}
                rooms={rooms}
                languages={languages}
                categories={categories}
                locations={locations}
            />

            {/* Note Dialog */}
            <Dialog
                isOpen={noteDialogOpen}
                onClose={() => setNoteDialogOpen(false)}
                title={currentDailyNote ? 'Edit Daily Note' : 'Add Daily Note'}
                onSubmit={handleSubmit(handleAddOrEditNote)}
                buttonLoading={noteFormLoading}
                submitLabel={currentDailyNote ? 'Save Changes' : 'Add Note'}
            >
                <div className="grid gap-4 py-4">
                    <Textarea
                        value={watch('note')}
                        onChange={e => setValue('note', e.target.value, { shouldValidate: true })}
                        name="note"
                        placeholder="Enter your note here..."
                        rows={5}
                        className="min-h-[120px] resize-vertical"
                    />
                    {errors.note?.message && (
                        <span className="text-sm text-red-500">{errors.note.message}</span>
                    )}
                </div>
                {currentDailyNote && (
                    <div className="flex justify-start">
                        <Button
                            type="button"
                            variant="outline-general"
                            onClick={handleDeleteNote}
                            disabled={noteFormLoading}
                        >
                            <Trash2 className="mr-2 h-4 w-4" /> Delete Note
                        </Button>
                    </div>
                )}
            </Dialog>

            {/* Tooltip instances for each event */}
            {events.map((e) => (
                <ReactTooltip
                    key={e.id}
                    id={`tooltip-${e.id}`}
                    place="top"
                    float={true}
                    className="tooltip-solid !z-[9999] !border !border-gray-200 !text-gray-900 !shadow-lg"
                    style={{
                        padding: '10px',
                        maxWidth: '280px',
                        fontSize: '12px',
                        lineHeight: '1.5',
                        zIndex: 9999,
                    }}
                />
            ))}
        </div>
    )
}
