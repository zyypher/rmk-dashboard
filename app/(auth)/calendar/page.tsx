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
    }, [])

    const fetchDropdowns = async () => {
        try {
            const [c, t, r, l, cat, loc] = await Promise.all([
                axios.get('/api/courses'),
                axios.get('/api/trainers'),
                axios.get('/api/rooms'),
                axios.get('/api/languages'),
                axios.get('/api/categories'),
                axios.get('/api/locations'),
            ])
            setCourses(Array.isArray(c.data.courses) ? c.data.courses : [])
            setTrainers(Array.isArray(t.data.trainers) ? t.data.trainers : [])
            setRooms(Array.isArray(r.data.rooms) ? r.data.rooms : [])
            setLanguages(l.data)
            setCategories(cat.data)
            setLocations(
                Array.isArray(loc.data.locations) ? loc.data.locations : [],
            )
        } catch (error) {
            toast.error('Failed to fetch dropdowns')
            console.error('Error fetching dropdowns:', error)
        }
    }

    const formatTime = (start: string, end: string) => {
        if (!start || !end) return 'N/A'
        const formattedStart = dayjs(start).format('hh:mm A')
        const formattedEnd = dayjs(end).format('hh:mm A')
        return `${formattedStart} - ${formattedEnd}`
    }

    if (!Array.isArray(bookings)) return null

    const events = bookings.map((b) => {
        const confirmed =
            b.delegates?.filter((d) => d.status === 'CONFIRMED')?.length || 0
        const notConfirmed =
            b.delegates?.filter((d) => d.status === 'NOT_CONFIRMED')?.length ||
            0
        const capacity = (b.room as any)?.capacity || 0
        const free = capacity - (confirmed + notConfirmed)

        const backgroundColor = b.location?.backgroundColor || '#dbeafe'
        const textColor = b.location?.textColor || '#1f3a8a'

        const tooltipId = `tooltip-${b.id}`
        const tooltipHTML = `
      <div style='font-weight: bold;'>${b.course?.shortname || b.course?.title} - ${(b.room as any)?.name || ''}</div>
      <div><span style='color:#4B5563;'>Language:</span> ${b.language}</div>
      <div><span style='color:#4B5563;'>Trainer:</span> ${b.trainer?.name}</div>
      <div><span style='color:#4B5563;'>Location:</span> ${b.location?.name}</div>
      <div><span style='color:#4B5563;'>Room:</span> ${(b.room as any)?.name}</div>
      <div><span style='color:#4B5563;'>Category:</span> ${b.course?.category?.name}</div>
      <div><span style='color:#4B5563;'>Time:</span> ${formatTime(b.startTime, b.endTime)}</div>
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
                tooltipId: 'global-tooltip',
                tooltipHTML,
                backgroundColor,
                textColor,
            },
        }
    })

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
                height="auto"
                dayMaxEvents={4} // 👈 show up to 4 items per day
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
                eventContent={(arg) => (
                    <div
                        style={{
                            position: 'relative',
                            zIndex: 1,
                            isolation: 'isolate',
                        }}
                        data-tooltip-id={arg.event.extendedProps.tooltipId}
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
            <ReactTooltip
                id="global-tooltip"
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
        </div>
    )
}
