'use client'

import React, { useEffect, useState, useRef } from 'react'
import { Dialog } from '@/components/ui/dialog'
import BookingModal from '@/components/BookingModal'
import SeatSelectionModal from '@/components/SeatSelectionModal'
import { Booking } from '@/types/booking'
import { Course } from '@/types/course'
import { Trainer } from '@/types'
import { Room } from '@/types/room'
import { Language } from '@/types/language'
import { Category } from '@/types/category'
import { Location } from '@/types/location'
import { Delegate } from '@/types/delegate'
import axios from 'axios'
import toast from 'react-hot-toast'
import { Button } from '@/components/ui/button'

interface BookingFlowDialogProps {
    isOpen: boolean
    onClose: () => void
    initialBooking?: Booking | null
    courses?: Course[];
    trainers?: Trainer[];
    rooms?: Room[];
    languages?: Language[];
    categories?: Category[];
    locations?: Location[];
}

export default function BookingFlowDialog({
    isOpen,
    onClose,
    initialBooking,
    courses: propCourses,
    trainers: propTrainers,
    rooms: propRooms,
    languages: propLanguages,
    categories: propCategories,
    locations: propLocations,
}: BookingFlowDialogProps) {
    const [step, setStep] = useState<'form' | 'seats' | 'error' | null>(null)
    const [courses, setCourses] = useState<Course[]>([])
    const [trainers, setTrainers] = useState<Trainer[]>([])
    const [rooms, setRooms] = useState<Room[]>([])
    const [languages, setLanguages] = useState<Language[]>([])
    const [categories, setCategories] = useState<Category[]>([])
    const [locations, setLocations] = useState<Location[]>([])
    const [bookingData, setBookingData] = useState<any>(null)
    const [selectedSeats, setSelectedSeats] = useState<string[]>([])
    const [conflictErrors, setConflictErrors] = useState<string[]>([])
    const [delegates, setDelegates] = useState<Record<string, Delegate>>({})
    const [formLoading, setFormLoading] = useState(false)
    const [dropdownsLoading, setDropdownsLoading] = useState(true)

    const isAddModeInitialized = useRef(false); // To prevent infinite loop in add mode

    // Effect to handle opening the dialog and initial data setup
    useEffect(() => {
        if (isOpen) {
            setStep('form')
            console.log('BookingFlowDialog: Checking for prop dropdowns...', { propCourses: propCourses?.length, propTrainers: propTrainers?.length, propRooms: propRooms?.length, propLanguages: propLanguages?.length, propCategories: propCategories?.length, propLocations: propLocations?.length });
            if (propCourses && propTrainers && propRooms && propLanguages && propCategories && propLocations) {
                setCourses(propCourses);
                setTrainers(propTrainers);
                setRooms(propRooms);
                setLanguages(propLanguages);
                setCategories(propCategories);
                setLocations(propLocations);
                setDropdownsLoading(false); // Mark as loaded if props are provided
            } else {
                fetchDropdowns(); // Otherwise, fetch dropdowns
            }
        }
    }, [isOpen, propCourses, propTrainers, propRooms, propLanguages, propCategories, propLocations])

    // Effect to process initialBooking *after* dropdowns are loaded
    // This effect should only run when initialBooking (or its ID) truly changes, or when dropdowns are loaded.
    useEffect(() => {
        if (isOpen && !dropdownsLoading && courses.length > 0) { // Check for courses.length > 0 to ensure data is loaded
            if (initialBooking) {
                // Edit mode - always update with the new booking data
                console.log('##BookingFlowDialog: Edit mode, processing initialBooking.', { initialBookingId: initialBooking.id });
                const enrichedBooking = {
                    ...initialBooking,
                    course: courses.find((c) => c.id === initialBooking.courseId) || initialBooking.course,
                    trainer: trainers.find((t) => t.id === initialBooking.trainerId) || initialBooking.trainer,
                    location: locations.find((l) => l.id === initialBooking.locationId) || initialBooking.location,
                    room: rooms.find((r) => r.id === initialBooking.roomId) || initialBooking.room,
                }
                setBookingData(enrichedBooking)

                setSelectedSeats(initialBooking.selectedSeats || [])
                const delegateMap: Record<string, Delegate> = {}
                initialBooking.delegates?.forEach((d) => {
                    delegateMap[d.seatId] = d
                })
                setDelegates(delegateMap)
                isAddModeInitialized.current = false; // Reset flag when in edit mode
            } else {
                // Add mode - always reset state for new booking
                console.log('##BookingFlowDialog: Add mode, resetting internal state.');
                setBookingData(null)
                setSelectedSeats([])
                setDelegates({})
                isAddModeInitialized.current = true; // Set flag after initial reset
            }
        }
    }, [isOpen, initialBooking, dropdownsLoading, courses, trainers, rooms, locations])

    const fetchDropdowns = async () => {
        setDropdownsLoading(true)
        try {
            // Add cache-busting parameters
            const timestamp = Date.now()
            const [c, t, r, l, cat, loc] = await Promise.all([
                axios.get(`/api/courses?t=${timestamp}`, {
                    headers: { 'Cache-Control': 'no-cache', 'Pragma': 'no-cache' }
                }),
                axios.get(`/api/trainers?t=${timestamp}`, {
                    headers: { 'Cache-Control': 'no-cache', 'Pragma': 'no-cache' }
                }),
                axios.get(`/api/rooms?t=${timestamp}`, {
                    headers: { 'Cache-Control': 'no-cache', 'Pragma': 'no-cache' }
                }),
                axios.get(`/api/languages?t=${timestamp}`, {
                    headers: { 'Cache-Control': 'no-cache', 'Pragma': 'no-cache' }
                }),
                axios.get(`/api/categories?t=${timestamp}`, {
                    headers: { 'Cache-Control': 'no-cache', 'Pragma': 'no-cache' }
                }),
                axios.get(`/api/locations?t=${timestamp}`, {
                    headers: { 'Cache-Control': 'no-cache', 'Pragma': 'no-cache' }
                }),
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
        } finally {
            setDropdownsLoading(false)
        }
    }

    const handleNextStep = (data: any) => {
        const enrichedData = {
            ...data,
            id: bookingData?.id, // Preserve ID for edits
            course:
                courses.find((c) => c.id === data.courseId) ||
                bookingData?.course,
            trainer:
                trainers.find((t) => t.id === data.trainerId) ||
                bookingData?.trainer,
            location:
                locations.find((l) => l.id === data.locationId) ||
                bookingData?.location,
            room: rooms.find((r) => r.id === data.roomId) || bookingData?.room,
        }
        setBookingData(enrichedData)
        setStep('seats')
    }

    const handleFinalSubmit = async (seats: string[]) => {
        setFormLoading(true)
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
                delegates: delegateArray.map(({ photo, ...rest }) => rest), // Remove photo object for submission
            }

            const isEditing = !!bookingData?.id

            let res
            if (!isEditing) {
                const formData = new FormData()
                formData.append('data', JSON.stringify(payload))

                delegateArray.forEach((d) => {
                    if (d.photo && typeof d.photo !== 'string') {
                        formData.append(d.seatId, d.photo)
                    }
                })

                res = await fetch('/api/bookings', {
                    method: 'POST',
                    body: formData,
                })
            } else {
                const formData = new FormData()
                formData.append('data', JSON.stringify(payload))

                delegateArray.forEach((d) => {
                    if (d.photo && typeof d.photo !== 'string') {
                        formData.append(d.seatId, d.photo)
                    }
                })

                res = await fetch(`/api/bookings/${bookingData.id}`, {
                    method: 'PUT',
                    body: formData,
                })
            }

            if (!res.ok) {
                const err = await res.json()
                if (res.status === 409 && err?.reasons) {
                    setConflictErrors(err.reasons)
                    setStep('error')
                    return
                }
                throw new Error(err?.error || 'Failed to submit booking')
            }

            toast.success(`Booking ${isEditing ? 'updated' : 'added'} successfully`)
            // Reset state before closing
            setBookingData(null)
            setSelectedSeats([])
            setDelegates({})
            setConflictErrors([])
            isAddModeInitialized.current = false
            onClose() // Close the dialog on success
        } catch (error: any) {
            toast.error(error.message || 'Failed to submit')
            console.error('Error submitting booking:', error)
        } finally {
            setFormLoading(false)
        }
    }

    const handleClose = () => {
        setStep(null) // Reset step on close
        setBookingData(null)
        setSelectedSeats([])
        setDelegates({})
        setConflictErrors([])
        isAddModeInitialized.current = false
        onClose()
    }

    if (dropdownsLoading) {
        return (
            <Dialog isOpen={isOpen} onClose={handleClose} title="Loading...">
                <div className="p-4 text-center">Loading booking data and options...</div>
            </Dialog>
        )
    }

    console.log('BookingFlowDialog: Rendering BookingModal with bookingData (before return):', bookingData);

    return (
        <Dialog
            isOpen={isOpen}
            onClose={handleClose}
            title={initialBooking ? 'Edit Booking' : 'Add Booking'}
            buttonLoading={formLoading}
        >
            {step === 'form' && (
                <BookingModal
                    booking={bookingData}
                    courses={courses}
                    trainers={trainers}
                    rooms={rooms}
                    languages={languages}
                    categories={categories}
                    locations={locations}
                    onNext={handleNextStep}
                    onClose={handleClose}
                    loading={formLoading}
                />
            )}
            {step === 'seats' && (
                <SeatSelectionModal
                    isOpen={isOpen}
                    onClose={handleClose}
                    bookingData={bookingData}
                    room={bookingData?.room}
                    selectedSeats={selectedSeats}
                    setSelectedSeats={setSelectedSeats}
                    delegates={delegates}
                    setDelegates={setDelegates}
                    onBack={() => setStep('form')}
                    onFinalSubmit={handleFinalSubmit}
                    loading={formLoading}
                />
            )}
            {step === 'error' && (
                <div className="p-4 text-red-600">
                    <h2 className="text-lg font-semibold">Booking Conflict!</h2>
                    <p>The selected time slot conflicts with existing bookings:</p>
                    <ul className="list-disc pl-5 mt-2">
                        {conflictErrors.map((reason, index) => (
                            <li key={index}>{reason}</li>
                        ))}
                    </ul>
                    <div className="mt-4 flex justify-end gap-2">
                        <Button variant="outline" onClick={() => setStep('form')}>Go Back</Button>
                        <Button onClick={handleClose}>Cancel</Button>
                    </div>
                </div>
            )}
        </Dialog>
    )
} 