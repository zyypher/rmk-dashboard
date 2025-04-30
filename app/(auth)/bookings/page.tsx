'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import { Plus } from 'lucide-react'
import toast from 'react-hot-toast'

import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'
import { Skeleton } from '@/components/ui/skeleton'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/bookings/columns'
import { Booking } from '@/types/booking'
import BookingModal from '@/components/BookingModal'
import SeatSelectionModal from '@/components/SeatSelectionModal'

import { Course } from '@/types/course'
import { Trainer } from '@/types'
import { Room } from '@/types/room'
import { Language } from '@/types/language'

export default function BookingsPage() {
    const [bookings, setBookings] = useState<Booking[]>([])
    const [loading, setLoading] = useState(true)
    const [step, setStep] = useState<'form' | 'seats' | null>(null)
    const [courses, setCourses] = useState<Course[]>([])
    const [trainers, setTrainers] = useState<Trainer[]>([])
    const [rooms, setRooms] = useState<Room[]>([])
    const [languages, setLanguages] = useState<Language[]>([])
    const [selectedBooking, setSelectedBooking] = useState<Booking | null>(null)
    const [bookingToDelete, setBookingToDelete] = useState<Booking | null>(null)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [bookingData, setBookingData] = useState<any>(null)
    const [selectedSeats, setSelectedSeats] = useState<string[]>([])

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

    const fetchDropdowns = async () => {
        try {
            const [c, t, r, l] = await Promise.all([
                axios.get('/api/courses'),
                axios.get('/api/trainers'),
                axios.get('/api/rooms'),
                axios.get('/api/languages'),
            ])
            setCourses(c.data)
            setTrainers(t.data)
            setRooms(r.data)
            setLanguages(l.data)
        } catch {
            toast.error('Failed to fetch dropdowns')
        }
    }

    const openEditDialog = (booking: Booking) => {
        setSelectedBooking(booking)
        setBookingData(booking) // important ✅
        setSelectedSeats(booking.selectedSeats || []) // important ✅
        setStep('form')
    }

    const confirmDelete = (booking: Booking) => {
        setBookingToDelete(booking)
        setDeleteDialogOpen(true)
    }

    const resetBookingFlow = () => {
        setStep(null)
        setBookingData(null)
        setSelectedSeats([])
        setSelectedBooking(null)
    }

    const handleNextStep = (data: any) => {
        setBookingData(data)
        setStep('seats')
    }

    const handleFinalSubmit = async (seats: string[]) => {
        try {
            const payload = {
                ...bookingData,
                selectedSeats: seats,
                participants: seats.length,
                date: new Date(bookingData.date),
                startTime: new Date(bookingData.startTime),
                endTime: new Date(bookingData.endTime),
            }

            if (bookingData?.id) {
                // 🛠 Edit Existing
                await axios.put(`/api/bookings/${bookingData.id}`, payload)
                toast.success('Booking updated')
            } else {
                // 🆕 Create New
                await axios.post('/api/bookings', payload)
                toast.success('Booking created')
            }

            fetchBookings()
        } catch (err) {
            toast.error('Failed to save booking')
            console.error('Save error:', err)
        } finally {
            resetBookingFlow()
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
            <div className="flex justify-end">
                <Button onClick={() => setStep('form')}>
                    <Plus className="mr-2 h-4 w-4" />
                    Add Booking
                </Button>
            </div>

            <DataTable
                columns={columns({ openEditDialog, confirmDelete })}
                data={bookings}
                filterField="course.title"
                loading={loading}
            />

            {/* STEP MODAL CONTROLLER */}
            {step === 'form' && (
                <BookingModal
                    isOpen={step === 'form'}
                    onClose={resetBookingFlow}
                    onNext={handleNextStep}
                    onSubmit={handleNextStep} // fallback
                    loading={false}
                    initialData={selectedBooking}
                    courses={courses}
                    trainers={trainers}
                    rooms={rooms}
                    languages={languages}
                />
            )}

            {step === 'seats' && (
                <SeatSelectionModal
                    isOpen={step === 'seats'}
                    onClose={resetBookingFlow}
                    onBack={() => setStep('form')}
                    roomId={bookingData?.roomId}
                    selectedSeats={selectedSeats}
                    onSeatChange={(seats) => setSelectedSeats(seats)}
                    onConfirm={handleFinalSubmit}
                    initialCapacity={bookingData?.room?.capacity}
                />
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
                    <span className="text-red-600 font-semibold">
                        {bookingToDelete?.course.title}
                    </span>{' '}
                    booking?
                </p>
            </Dialog>
        </div>
    )
}
