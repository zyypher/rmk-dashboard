'use client'

import React, { useState, useEffect } from 'react'
import { Dialog } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Checkbox } from '@/components/ui/checkbox'
import { Booking } from '@/types/booking'
import { Trash2, Calendar, Clock, MapPin, Users } from 'lucide-react'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import axios from 'axios'
import toast from 'react-hot-toast'

dayjs.extend(utc)
dayjs.extend(timezone)

interface DeleteBookingsDialogProps {
    isOpen: boolean
    onClose: () => void
    selectedDate: Date | null
    onBookingsDeleted: () => void
}

export default function DeleteBookingsDialog({
    isOpen,
    onClose,
    selectedDate,
    onBookingsDeleted,
}: DeleteBookingsDialogProps) {
    const [bookings, setBookings] = useState<Booking[]>([])
    const [selectedBookings, setSelectedBookings] = useState<string[]>([])
    const [loading, setLoading] = useState(false)
    const [deleteLoading, setDeleteLoading] = useState(false)

    // Use bookings directly everywhere below

    useEffect(() => {
        if (isOpen && selectedDate) {
            console.log('##[DeleteBookingsDialog] isOpen:', isOpen, 'selectedDate:', selectedDate);
            fetchBookingsForDate()
        }
    }, [isOpen, selectedDate])

    const fetchBookingsForDate = async () => {
        if (!selectedDate) return
        
        setLoading(true)
        try {
            const dateString = dayjs(selectedDate).format('YYYY-MM-DD')
            console.log('##[DeleteBookingsDialog] Fetching bookings for dateString:', dateString, 'from selectedDate:', selectedDate);
            const response = await axios.get(`/api/bookings?date=${dateString}&page=1&pageSize=9999`)
            console.log('##[DeleteBookingsDialog] Bookings received:', response.data.bookings);
            setBookings(response.data.bookings || [])
            setSelectedBookings([])
        } catch (error) {
            console.error('Error fetching bookings for date:', error)
            toast.error('Failed to fetch bookings for this date')
        } finally {
            setLoading(false)
        }
    }

    const handleSelectAll = (checked: boolean) => {
        if (checked) {
            setSelectedBookings(bookings.map(booking => booking.id))
        } else {
            setSelectedBookings([])
        }
    }

    const handleSelectBooking = (bookingId: string, checked: boolean) => {
        if (checked) {
            setSelectedBookings(prev => [...prev, bookingId])
        } else {
            setSelectedBookings(prev => prev.filter(id => id !== bookingId))
        }
    }

    const handleDeleteBookings = async () => {
        if (selectedBookings.length === 0) {
            toast.error('Please select at least one booking to delete')
            return
        }

        setDeleteLoading(true)
        try {
            // Delete bookings one by one
            for (const bookingId of selectedBookings) {
                await axios.delete(`/api/bookings/${bookingId}`)
            }
            
            toast.success(`Successfully deleted ${selectedBookings.length} booking(s)`)
            onBookingsDeleted()
            onClose()
        } catch (error) {
            console.error('Error deleting bookings:', error)
            toast.error('Failed to delete some bookings')
        } finally {
            setDeleteLoading(false)
        }
    }

    const formatTime = (start: string, end: string) => {
        if (!start || !end) return 'N/A'
        const formattedStart = dayjs(start).format('hh:mm A')
        const formattedEnd = dayjs(end).format('hh:mm A')
        return `${formattedStart} - ${formattedEnd}`
    }

    const confirmedDelegates = (booking: Booking) => {
        return booking.delegates?.filter(d => d.status === 'CONFIRMED')?.length || 0
    }

    const totalDelegates = (booking: Booking) => {
        return booking.delegates?.length || 0
    }

    return (
        <Dialog
            isOpen={isOpen}
            onClose={onClose}
            title={`Delete Bookings - ${selectedDate ? dayjs(selectedDate).format('MMMM D, YYYY') : ''}`}
            className="max-w-4xl"
        >
            <div className="space-y-4">
                {loading ? (
                    <div className="flex items-center justify-center py-8">
                        <div className="text-gray-500">Loading bookings...</div>
                    </div>
                ) : bookings.length === 0 ? (
                    <div className="flex items-center justify-center py-8">
                        <div className="text-gray-500">No bookings found for this date</div>
                    </div>
                ) : (
                    <>
                        <div className="flex items-center justify-between border-b pb-3">
                            <div className="flex items-center space-x-2">
                                <Checkbox
                                    checked={selectedBookings.length === bookings.length && bookings.length > 0}
                                    onCheckedChange={handleSelectAll}
                                />
                                <span className="font-medium">
                                    Select All ({bookings.length} bookings)
                                </span>
                            </div>
                            {selectedBookings.length > 0 && (
                                <span className="text-sm text-gray-500">
                                    {selectedBookings.length} selected
                                </span>
                            )}
                        </div>

                        <div className="max-h-96 space-y-3 overflow-y-auto">
                            {bookings.map((booking) => (
                                <div
                                    key={booking.id}
                                    className="flex items-start space-x-3 rounded-lg border p-3 hover:bg-gray-50"
                                >
                                    <Checkbox
                                        checked={selectedBookings.includes(booking.id)}
                                        onCheckedChange={(checked) => 
                                            handleSelectBooking(booking.id, checked as boolean)
                                        }
                                    />
                                    <div className="flex-1 space-y-2">
                                        <div className="flex items-start justify-between">
                                            <div className="flex-1">
                                                <h4 className="font-semibold text-gray-900">
                                                    {booking.course?.title || 'Untitled Course'}
                                                </h4>
                                                <p className="text-sm text-gray-600">
                                                    {booking.course?.category?.name || 'No Category'}
                                                </p>
                                            </div>
                                            <div className="flex items-center space-x-1 text-xs text-gray-500">
                                                <Users className="h-3 w-3" />
                                                <span>
                                                    {confirmedDelegates(booking)}/{totalDelegates(booking)}
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div className="grid grid-cols-2 gap-2 text-xs text-gray-600">
                                            <div className="flex items-center space-x-1">
                                                <Clock className="h-3 w-3" />
                                                <span>{formatTime(booking.startTime, booking.endTime)}</span>
                                            </div>
                                            <div className="flex items-center space-x-1">
                                                <MapPin className="h-3 w-3" />
                                                <span>{booking.location?.name || 'No Location'}</span>
                                            </div>
                                        </div>
                                        
                                        <div className="text-xs text-gray-500">
                                            <span className="font-medium">Trainer:</span> {booking.trainer?.name || 'No Trainer'}
                                            {booking.room && (
                                                <>
                                                    <span className="mx-1">•</span>
                                                    <span className="font-medium">Room:</span> {booking.room.name}
                                                </>
                                            )}
                                            {booking.language && (
                                                <>
                                                    <span className="mx-1">•</span>
                                                    <span className="font-medium">Language:</span> {booking.language}
                                                </>
                                            )}
                                        </div>
                                        
                                        {booking.notes && (
                                            <div className="text-xs text-gray-500">
                                                <span className="font-medium">Notes:</span> {booking.notes}
                                            </div>
                                        )}
                                    </div>
                                </div>
                            ))}
                        </div>

                        <div className="flex items-center justify-between border-t pt-4">
                            <div className="text-sm text-gray-600">
                                {selectedBookings.length > 0 ? (
                                    <span className="text-red-600 font-medium">
                                        {selectedBookings.length} booking(s) selected for deletion
                                    </span>
                                ) : (
                                    'Select bookings to delete'
                                )}
                            </div>
                            <div className="flex space-x-2">
                                <Button
                                    variant="outline-general"
                                    onClick={onClose}
                                    disabled={deleteLoading}
                                >
                                    Cancel
                                </Button>
                                <Button
                                    variant="destructive"
                                    onClick={handleDeleteBookings}
                                    disabled={selectedBookings.length === 0 || deleteLoading}
                                >
                                    {deleteLoading ? (
                                        <span className="loader mr-2"></span>
                                    ) : (
                                        <Trash2 className="mr-2 h-4 w-4" />
                                    )}
                                    Delete Selected ({selectedBookings.length})
                                </Button>
                            </div>
                        </div>
                    </>
                )}
            </div>
        </Dialog>
    )
} 