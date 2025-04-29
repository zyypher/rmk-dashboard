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
  const [dialogOpen, setDialogOpen] = useState(false)
  const [courses, setCourses] = useState<Course[]>([])
  const [trainers, setTrainers] = useState<Trainer[]>([])
  const [rooms, setRooms] = useState<Room[]>([])
  const [languages, setLanguages] = useState<Language[]>([])
  const [selectedBooking, setSelectedBooking] = useState<Booking | null>(null)
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
  const [bookingToDelete, setBookingToDelete] = useState<Booking | null>(null)
  const [seatModalOpen, setSeatModalOpen] = useState(false)
  const [bookingData, setBookingData] = useState<any>(null)

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
    setDialogOpen(true)
  }

  const confirmDelete = (booking: Booking) => {
    setBookingToDelete(booking)
    setDeleteDialogOpen(true)
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

  const handleNextStep = (data: any) => {
    setBookingData(data)
    setDialogOpen(false)
    setSeatModalOpen(true)
  }

  const handleFinalSubmit = async (data: any, seats: string[]) => {
    try {
      const payload = {
        ...data,
        selectedSeats: seats,
        participants: seats.length,
        date: new Date(data.date),
        startTime: new Date(data.startTime),
        endTime: new Date(data.endTime),
      }

      await axios.post('/api/bookings', payload)
      toast.success('Booking created')
      fetchBookings()
    } catch {
      toast.error('Failed to create booking')
    } finally {
      setSeatModalOpen(false)
      setBookingData(null)
    }
  }

  return (
    <div className="space-y-6 p-6">
      <PageHeading heading="Bookings" />
      <div className="flex justify-end">
        <Button onClick={() => setDialogOpen(true)}>
          <Plus className="mr-2 h-4 w-4" />
          Add Booking
        </Button>
      </div>

      {loading ? (
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
          {Array.from({ length: 6 }).map((_, i) => (
            <Skeleton key={i} className="h-24 w-full rounded-lg" />
          ))}
        </div>
      ) : (
        <DataTable
          columns={columns({ openEditDialog, confirmDelete })}
          data={bookings}
          filterField="course.title"
        />
      )}

      <BookingModal
        isOpen={dialogOpen}
        onClose={() => setDialogOpen(false)}
        onNext={handleNextStep}
        onSubmit={handleNextStep}
        loading={false}
        initialData={selectedBooking}
        courses={courses}
        trainers={trainers}
        rooms={rooms}
        languages={languages}
        // onSubmit={() => {}} // not used in step 1
      />

      <SeatSelectionModal
        isOpen={seatModalOpen}
        onClose={() => setSeatModalOpen(false)}
        roomId={bookingData?.roomId}
        selectedSeats={bookingData?.selectedSeats || []}
        onConfirm={(seats) => handleFinalSubmit(bookingData, seats)}
      />

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
