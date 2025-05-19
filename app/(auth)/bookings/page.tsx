'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import { Plus } from 'lucide-react'
import toast from 'react-hot-toast'
import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/bookings/columns'
import { Booking } from '@/types/booking'
import BookingModal from '@/components/BookingModal'
import SeatSelectionModal from '@/components/SeatSelectionModal'
import { Course } from '@/types/course'
import { Trainer } from '@/types'
import { Room } from '@/types/room'
import { Language } from '@/types/language'
import { Category } from '@/types/category'
import { Location } from '@/types/location'
import { Delegate } from '@/types/delegate'
import { useUserRole } from '@/hooks/useUserRole'
import { Input } from '@/components/ui/input'
import debounce from 'lodash/debounce'

export default function BookingsPage() {
    const [bookings, setBookings] = useState<Booking[]>([])
    const [loading, setLoading] = useState(true)
    const [step, setStep] = useState<'form' | 'seats' | 'error' | null>(null)
    const [courses, setCourses] = useState<Course[]>([])
    const [trainers, setTrainers] = useState<Trainer[]>([])
    const [rooms, setRooms] = useState<Room[]>([])
    const [languages, setLanguages] = useState<Language[]>([])
    const [categories, setCategories] = useState<Category[]>([])
    const [locations, setLocations] = useState<Location[]>([])
    const [selectedBooking, setSelectedBooking] = useState<Booking | null>(null)
    const [bookingToDelete, setBookingToDelete] = useState<Booking | null>(null)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [bookingData, setBookingData] = useState<any>(null)
    const [selectedSeats, setSelectedSeats] = useState<string[]>([])
    const [conflictErrors, setConflictErrors] = useState<string[]>([])
    const [delegates, setDelegates] = useState<Record<string, Delegate>>({})
    const [search, setSearch] = useState('')

    const role = useUserRole()

    useEffect(() => {
        fetchBookings()
        fetchDropdowns()
    }, [])

    const fetchBookings = async () => {
        setLoading(true)
        try {
            const res = await axios.get('/api/bookings')
            setBookings(res.data)
        } catch {
            toast.error('Failed to fetch bookings')
        } finally {
            setLoading(false)
        }
    }

    const debouncedSearch = debounce(async (query: string) => {
        try {
            setLoading(true)
            const res = await axios.get('/api/bookings/search', {
                params: { q: query },
            })
            setBookings(res.data)
        } catch {
            toast.error('Failed to search bookings')
        } finally {
            setLoading(false)
        }
    }, 500)

    const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const val = e.target.value
        setSearch(val)
        debouncedSearch(val)
    }

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
            setCourses(c.data)
            setTrainers(t.data)
            setRooms(r.data)
            setLanguages(l.data)
            setCategories(cat.data)
            setLocations(loc.data)
        } catch {
            toast.error('Failed to fetch dropdowns')
        }
    }

    const openEditDialog = async (booking: Booking) => {
        setSelectedBooking(booking)
        setBookingData(booking)
        setSelectedSeats(booking.selectedSeats || [])
        setDelegates({}) // optional reset for safety
        // Open modal immediately
        setStep('form')
        try {
            const res = await axios.get(`/api/bookings/${booking.id}/delegates`)
            const delegateMap: Record<string, Delegate> = {}
            res.data.forEach((d: Delegate) => {
                delegateMap[d.seatId] = d
            })
            setDelegates(delegateMap)
        } catch {
            toast.error('Failed to fetch delegates')
        }
    }

    const confirmDelete = (booking: Booking) => {
        setBookingToDelete(booking)
        setDeleteDialogOpen(true)
    }

    const resetBookingFlow = () => {
        setStep(null)
        setBookingData(null)
        setSelectedSeats([])
        setDelegates({})
        setSelectedBooking(null)
    }

    const handleNextStep = (data: any) => {
        const selectedRoom = rooms.find((r) => r.id === data.roomId)

        if (!data.trainerId) {
            toast.error('Trainer is required')
            return
        }

        setBookingData({ ...data, room: selectedRoom })
        setStep('seats')
    }

    const handleFinalSubmit = async (seats: string[]) => {
        try {
            const delegateArray = Object.entries(delegates).map(
                ([seatId, delegate]) => ({
                    ...delegate,
                    seatId,
                }),
            )

            const payload = {
                ...bookingData,
                selectedSeats: seats,
                participants: seats.length,
                date: new Date(bookingData.date),
                startTime: new Date(bookingData.startTime),
                endTime: new Date(bookingData.endTime),
                delegates: delegateArray.map(({ photo, ...rest }) => rest),
            }

            // ✅ Only for new bookings with photos
            if (!bookingData?.id) {
                const formData = new FormData()
                formData.append('data', JSON.stringify(payload))

                delegateArray.forEach((d) => {
                    if (d.photo && typeof d.photo !== 'string') {
                        formData.append(d.seatId, d.photo)
                    }
                })

                const res = await fetch('/api/bookings', {
                    method: 'POST',
                    body: formData,
                })

                if (!res.ok) {
                    const err = await res.json()
                    if (res.status === 409 && err?.reasons) {
                        setConflictErrors(err.reasons)
                        setStep('error')
                        return
                    }
                    throw new Error(err?.error || 'Failed to create booking')
                }

                toast.success('Booking created')
            } else {
                // ✅ For updates, just use PUT
                await axios.put(`/api/bookings/${bookingData.id}`, payload)
                toast.success('Booking updated')
            }

            fetchBookings()
            resetBookingFlow()
        } catch (err: any) {
            if (err?.response?.status === 409 && err?.response?.data?.reasons) {
                setConflictErrors(err.response.data.reasons)
                setStep('error')
            } else {
                toast.error('Failed to save booking')
                console.error('Save error:', err)
                resetBookingFlow()
            }
        }
    }

    const handleDelete = async () => {
        if (!bookingToDelete) return

        try {
            await axios.delete(`/api/bookings/${bookingToDelete.id}`)
            toast.success('Booking deleted')
            fetchBookings()
        } catch {
            toast.error('Failed to delete booking')
        } finally {
            setDeleteDialogOpen(false)
            setBookingToDelete(null)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Bookings" />

            <div className="flex flex-wrap items-center justify-between gap-3">
                <Input
                    placeholder="Search by course, trainer, room..."
                    value={search}
                    onChange={handleSearchChange}
                    className="w-full min-w-[16rem] sm:max-w-lg"
                />
                {(role === 'ADMIN' || role === 'EDITOR') && (
                    <Button onClick={() => setStep('form')}>
                        <Plus className="mr-2 h-4 w-4" />
                        Add Booking
                    </Button>
                )}
            </div>

            <DataTable
                columns={columns({ role, openEditDialog, confirmDelete })}
                data={bookings}
                filterField="course.title"
                loading={loading}
            />

            {step === 'form' && (
                <BookingModal
                    isOpen={step === 'form'}
                    onClose={resetBookingFlow}
                    onNext={handleNextStep}
                    loading={false}
                    initialData={bookingData}
                    courses={courses}
                    trainers={trainers}
                    rooms={rooms}
                    languages={languages}
                    categories={categories}
                    locations={locations}
                />
            )}

            {step === 'seats' && (
                <SeatSelectionModal
                    isOpen={step === 'seats'}
                    onClose={resetBookingFlow}
                    onBack={() => setStep('form')}
                    room={bookingData?.room}
                    selectedSeats={selectedSeats}
                    onSeatChange={(seats) => setSelectedSeats(seats)}
                    onConfirm={handleFinalSubmit}
                    delegates={delegates}
                    setDelegates={setDelegates}
                />
            )}

            {step === 'error' && (
                <Dialog
                    isOpen={step === 'error'}
                    onClose={resetBookingFlow}
                    title="Booking Conflict Detected"
                    onSubmit={() => setStep('form')}
                    submitLabel="Go Back and Edit"
                >
                    <ul className="list-disc space-y-2 pl-5 text-sm text-red-600">
                        {conflictErrors.map((reason, idx) => (
                            <li key={idx}>{reason}</li>
                        ))}
                    </ul>
                    <p className="mt-4 text-sm text-gray-500">
                        Please adjust the trainer, room, or time and try again.
                    </p>
                </Dialog>
            )}

            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Booking"
                onSubmit={handleDelete}
                buttonLoading={false}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="font-semibold text-red-600">
                        {bookingToDelete?.course.title}
                    </span>{' '}
                    booking?
                </p>
            </Dialog>
        </div>
    )
}
