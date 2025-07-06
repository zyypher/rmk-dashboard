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
import BookingFlowDialog from '@/components/custom/booking-flow-dialog'
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
    const [deleteLoading, setDeleteLoading] = useState(false)
    const [totalPages, setTotalPages] = useState(1)
    const [currentPage, setCurrentPage] = useState(1)

    const role = useUserRole()

    // Fetch only once for dropdowns
    useEffect(() => {
        fetchDropdowns()
    }, [])

    // Fetch bookings whenever page changes
    useEffect(() => {
        fetchBookings(currentPage)
    }, [currentPage])

    const fetchBookings = async (page = 1, pageSize = 10) => {
        setLoading(true)
        try {
            const res = await axios.get('/api/bookings', {
                params: { page, pageSize },
            })
            setBookings(res.data.bookings)
            setTotalPages(res.data.totalPages)
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
            const res = await axios.get('/api/bookings/dropdowns')
            const {
                courses,
                trainers,
                rooms,
                languages,
                categories,
                locations,
            } = res.data
            setCourses(courses)
            setTrainers(trainers)
            setRooms(rooms)
            setLanguages(languages)
            setCategories(categories)
            setLocations(locations)
        } catch {
            toast.error('Failed to fetch dropdowns')
        }
    }

    const openEditDialog = (booking: Booking) => {
        console.log(
            'BookingsPage: openEditDialog - setting selectedBooking and step to form',
            booking,
        )
        setSelectedBooking(booking)
        setStep('form') // Set step to 'form' to open the dialog
    }

    const openAddDialog = () => {
        console.log(
            'BookingsPage: openAddDialog - setting selectedBooking to null and step to form',
        )
        setSelectedBooking(null) // Clear selected booking for add mode
        setStep('form') // Set step to 'form' to open the dialog
    }

    const confirmDelete = (booking: Booking) => {
        setBookingToDelete(booking)
        setDeleteDialogOpen(true)
    }

    const resetBookingFlow = () => {
        setStep(null)
        setSelectedBooking(null)
        setBookingData(null)
        setSelectedSeats([])
        setDelegates({})
        // Clear search and refresh the table after any booking operation
        setSearch('')
        fetchBookings(currentPage)
    }

    const handleDelete = async () => {
        if (!bookingToDelete) return
        setDeleteLoading(true)

        try {
            await axios.delete(`/api/bookings/${bookingToDelete.id}`)
            toast.success('Booking deleted')
            setSearch('') // Clear search state
            fetchBookings(currentPage) // Refresh with current page
        } catch {
            toast.error('Failed to delete booking')
        } finally {
            setDeleteLoading(false)
            setDeleteDialogOpen(false)
            setBookingToDelete(null)
        }
    }

    return (
        <div className="relative z-10 space-y-6 p-6">
            <PageHeading heading="Bookings" />

            <div className="flex flex-wrap items-center justify-between gap-3">
                <Input
                    placeholder="Search by course, trainer, room..."
                    value={search}
                    onChange={handleSearchChange}
                    className="w-full min-w-[16rem] sm:max-w-lg"
                />
                {(role === 'ADMIN' || role === 'EDITOR') && (
                    <Button onClick={openAddDialog}>
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
                manualPagination
                currentPage={currentPage}
                totalPages={totalPages}
                onPageChange={(page) => {
                    setCurrentPage(page)
                    fetchBookings(page)
                }}
            />

            <BookingFlowDialog
                isOpen={step === 'form' || step === 'seats' || step === 'error'}
                onClose={() => {
                    console.log(
                        'BookingsPage: BookingFlowDialog onClose called',
                    )
                    resetBookingFlow()
                }}
                initialBooking={selectedBooking}
                courses={courses}
                trainers={trainers}
                rooms={rooms}
                languages={languages}
                categories={categories}
                locations={locations}
            />

            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Booking"
                onSubmit={handleDelete}
                buttonLoading={deleteLoading}
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
