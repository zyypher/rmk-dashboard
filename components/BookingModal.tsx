'use client'

import { useEffect, useState } from 'react'
import { useForm, Controller } from 'react-hook-form'
import { yupResolver } from '@hookform/resolvers/yup'
import * as yup from 'yup'
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { DatePicker } from '@/components/ui/DatePicker'
import { TimePicker } from '@/components/ui/TimePicker'
import { Course } from '@/types/course'
import { Trainer } from '@/types'
import { Room } from '@/types/room'
import { Language } from '@/types/language'
import { Category } from '@/types/category'
import { Location } from '@/types/location'
import { Label } from '@/components/ui/label'
import { Booking } from '@/types/booking'
import { Button } from '@/components/ui/button'

interface BookingModalProps {
    onNext: (data: any) => void
    loading?: boolean
    booking?: Booking | null
    courses: Course[]
    trainers: Trainer[]
    rooms: Room[]
    languages: Language[]
    categories: Category[]
    locations: Location[]
    onClose: () => void
}

type BookingFormValues = {
    courseId: string
    categoryId: string
    language: string
    locationId: string
    roomId: string
    trainerId: string
    date: Date | null
    startTime: Date | null
    endTime: Date | null
    notes?: string
}

export const bookingSchema = yup.object({
    courseId: yup.string().required('Course is required'),
    categoryId: yup.string().required('Category is required'),
    language: yup.string().required('Language is required'),
    locationId: yup.string().required('Location is required'),
    roomId: yup.string().required('Room is required'),
    date: yup.date().nullable().required('Date is required'),
    startTime: yup.date().nullable().required('Start time is required'),
    trainerId: yup.string().required('Trainer is required'),
    endTime: yup
        .date()
        .nullable()
        .required('End time is required')
        .when('startTime', {
            is: (startTime: Date | null) => !!startTime,
            then: (schema) =>
                schema.min(
                    yup.ref('startTime'),
                    'End time must be after start time',
                ),
            otherwise: (schema) => schema,
        }),
    notes: yup.string().notRequired(),
})

export default function BookingModal({
    onNext,
    loading,
    booking,
    courses,
    trainers,
    rooms,
    languages,
    categories,
    locations,
    onClose,
}: BookingModalProps) {
    const {
        register,
        control,
        handleSubmit,
        setValue,
        watch,
        reset,
        formState: { errors },
    } = useForm<BookingFormValues>({
        mode: 'onChange',
        defaultValues: {
            courseId: '',
            categoryId: '',
            language: '',
            locationId: '',
            roomId: '',
            date: null,
            startTime: null,
            endTime: null,
            notes: '',
        },
        resolver: yupResolver(bookingSchema) as any,
    })

    const [displayRoomName, setDisplayRoomName] = useState('Select Room')

    useEffect(() => {
        if (booking) {
            reset({
                courseId: booking.courseId || '',
                categoryId: booking.course?.category?.id || '',
                language: booking.language || '',
                locationId: booking.locationId || '',
                trainerId: booking.trainerId || '',
                date: booking.date ? new Date(booking.date) : null,
                startTime: booking.startTime
                    ? new Date(booking.startTime)
                    : null,
                endTime: booking.endTime ? new Date(booking.endTime) : null,
                notes: booking.notes || '',
                roomId: rooms.some(
                    (room) =>
                        room.id === booking.roomId &&
                        room.locationId === booking.locationId,
                )
                    ? booking.roomId
                    : '',
            })
            console.log(
                '##BookingModal: booking updated, roomId:',
                booking.roomId,
                'locationId:',
                booking.locationId,
                'filteredRooms length (after reset):',
                rooms.filter(
                    (room) =>
                        room.locationId === booking.locationId &&
                        room.capacity &&
                        room.capacity > 0,
                ).length,
            )
        }
    }, [booking, reset, rooms])

    const selectedLocationId = watch('locationId')
    const filteredRooms = rooms.filter(
        (room) =>
            room.locationId === selectedLocationId &&
            room.capacity &&
            room.capacity > 0,
    )

    // Effect to reset roomId if selectedLocationId changes and current roomId is not valid for new location
    useEffect(() => {
        const currentRoomId = watch('roomId')
        if (selectedLocationId && currentRoomId) {
            const roomExistsInFiltered = filteredRooms.some(
                (room) => room.id === currentRoomId,
            )
            if (!roomExistsInFiltered) {
                console.log(
                    'BookingModal: Resetting roomId because it is not valid for the new location.',
                    {
                        selectedLocationId,
                        currentRoomId,
                        filteredRoomsLength: filteredRooms.length,
                    },
                )
                setValue('roomId', '', { shouldValidate: true })
            }
        }
    }, [selectedLocationId, filteredRooms, setValue, watch])

    // Effect to update displayRoomName
    useEffect(() => {
        const currentRoomId = watch('roomId')
        const currentSelectedLocationId = watch('locationId')
        const foundRoom = rooms.find(
            (room) =>
                room.id === currentRoomId &&
                room.locationId === currentSelectedLocationId,
        )

        if (foundRoom) {
            setDisplayRoomName(foundRoom.name)
        } else {
            setDisplayRoomName('Select Room')
        }
    }, [watch('roomId'), watch('locationId'), rooms])

    return (
        <form onSubmit={handleSubmit(onNext)} className="space-y-4">
            <div className="max-h-[75vh] space-y-4 overflow-y-auto px-1">
                {/* Course */}
                <Controller
                    name="courseId"
                    control={control}
                    render={({ field }) => (
                        <Select
                            key={field.value}
                            value={field.value}
                            onValueChange={field.onChange}
                        >
                            <SelectTrigger>
                                <SelectValue placeholder="Select Course">
                                    {field.value
                                        ? courses.find(
                                              (course) =>
                                                  course.id === field.value,
                                          )?.title
                                        : 'Select Course'}
                                </SelectValue>
                            </SelectTrigger>
                            <SelectContent>
                                {courses.map((course) => (
                                    <SelectItem
                                        key={course.id}
                                        value={course.id}
                                    >
                                        {course.title}
                                    </SelectItem>
                                ))}
                            </SelectContent>
                        </Select>
                    )}
                />
                {errors.courseId && (
                    <p className="text-sm text-red-500">
                        {errors.courseId.message}
                    </p>
                )}

                {/* Category */}
                <Controller
                    name="categoryId"
                    control={control}
                    render={({ field }) => (
                        <Select
                            key={field.value}
                            value={field.value}
                            onValueChange={field.onChange}
                        >
                            <SelectTrigger>
                                <SelectValue placeholder="Select Category">
                                    {field.value
                                        ? categories.find(
                                              (cat) => cat.id === field.value,
                                          )?.name
                                        : 'Select Category'}
                                </SelectValue>
                            </SelectTrigger>
                            <SelectContent>
                                {categories.map((cat) => (
                                    <SelectItem key={cat.id} value={cat.id}>
                                        {cat.name}
                                    </SelectItem>
                                ))}
                            </SelectContent>
                        </Select>
                    )}
                />
                {errors.categoryId && (
                    <p className="text-sm text-red-500">
                        {errors.categoryId.message}
                    </p>
                )}

                {/* Language */}
                <Controller
                    name="language"
                    control={control}
                    render={({ field }) => (
                        <Select
                            key={field.value}
                            value={field.value}
                            onValueChange={field.onChange}
                        >
                            <SelectTrigger>
                                <SelectValue placeholder="Select Language">
                                    {field.value
                                        ? languages.find(
                                              (lang) =>
                                                  lang.name === field.value,
                                          )?.name
                                        : 'Select Language'}
                                </SelectValue>
                            </SelectTrigger>
                            <SelectContent>
                                {languages.map((lang) => (
                                    <SelectItem key={lang.id} value={lang.name}>
                                        {lang.name}
                                    </SelectItem>
                                ))}
                            </SelectContent>
                        </Select>
                    )}
                />
                {errors.language && (
                    <p className="text-sm text-red-500">
                        {errors.language.message}
                    </p>
                )}

                {/* Location */}
                <Controller
                    name="locationId"
                    control={control}
                    render={({ field }) => (
                        <Select
                            key={field.value}
                            value={field.value}
                            onValueChange={(val) => {
                                if (val) {
                                    field.onChange(val)
                                    // Also reset roomId when location changes to ensure valid room selection
                                    setValue('roomId', '', {
                                        shouldValidate: true,
                                    })
                                }
                            }}
                        >
                            <SelectTrigger>
                                <SelectValue placeholder="Select Location">
                                    {field.value
                                        ? locations.find(
                                              (loc) => loc.id === field.value,
                                          )?.name
                                        : 'Select Location'}
                                </SelectValue>
                            </SelectTrigger>
                            <SelectContent>
                                {locations.map((loc) => (
                                    <SelectItem key={loc.id} value={loc.id}>
                                        {loc.name}
                                    </SelectItem>
                                ))}
                            </SelectContent>
                        </Select>
                    )}
                />
                {errors.locationId && (
                    <p className="text-sm text-red-500">
                        {errors.locationId.message}
                    </p>
                )}

                {/* Room */}
                <Controller
                    name="roomId"
                    control={control}
                    render={({ field }) => (
                        <Select
                            key={field.value}
                            value={field.value}
                            onValueChange={(val) => {
                                if (val) {
                                    field.onChange(val)
                                }
                            }}
                        >
                            <SelectTrigger>
                                <SelectValue placeholder="Select Room">
                                    {displayRoomName}
                                </SelectValue>
                            </SelectTrigger>
                            <SelectContent>
                                {/* {filteredRooms.map((room) => (
                                    <SelectItem key={room.id} value={room.id}>
                                        {room.name}
                                    </SelectItem>
                                ))} */}
                                {filteredRooms.length > 0 ? (
                                    filteredRooms.map((room) => (
                                        <SelectItem
                                            key={room.id}
                                            value={room.id}
                                        >
                                            {`${room.name} – ${room.capacity} participants – ${room.location.name}`}
                                        </SelectItem>
                                    ))
                                ) : (
                                    <div className="px-4 py-2 text-sm text-gray-500">
                                        No rooms available for the selected
                                        location.
                                    </div>
                                )}
                            </SelectContent>
                        </Select>
                    )}
                />
                {errors.roomId && (
                    <p className="text-sm text-red-500">
                        {errors.roomId.message}
                    </p>
                )}

                {/* Trainer */}
                <Controller
                    name="trainerId"
                    control={control}
                    render={({ field }) => (
                        <Select
                            key={field.value}
                            value={field.value}
                            onValueChange={(val) => {
                                if (val) {
                                    field.onChange(val)
                                } else {
                                    field.onChange('')
                                }
                            }}
                        >
                            <SelectTrigger>
                                <SelectValue placeholder="Select Trainer">
                                    {field.value
                                        ? trainers.find(
                                              (trainer) =>
                                                  trainer.id === field.value,
                                          )?.name
                                        : 'Select Trainer'}
                                </SelectValue>
                            </SelectTrigger>
                            <SelectContent>
                                {trainers.map((trainer) => (
                                    <SelectItem
                                        key={trainer.id}
                                        value={trainer.id}
                                    >
                                        {trainer.name}
                                    </SelectItem>
                                ))}
                            </SelectContent>
                        </Select>
                    )}
                />
                {errors.trainerId && (
                    <p className="text-sm text-red-500">
                        {errors.trainerId.message}
                    </p>
                )}

                {/* Date */}
                <div className="space-y-1">
                    <Label className="mb-1">Date</Label>
                    <Controller
                        control={control}
                        name="date"
                        render={({ field }) => (
                            <DatePicker
                                date={field.value}
                                onChange={(d: Date | null) => field.onChange(d)}
                                placeholderText="Select Date"
                                className="w-full"
                            />
                        )}
                    />
                </div>
                {errors.date && (
                    <p className="text-sm text-red-500">
                        {errors.date.message}
                    </p>
                )}

                <div className="flex gap-4">
                    <div className="flex-1">
                        <Label>Start Time</Label>
                        <Controller
                            control={control}
                            name="startTime"
                            render={({ field }) => (
                                <TimePicker
                                    time={field.value}
                                    onChange={(d: Date | null) =>
                                        field.onChange(d)
                                    }
                                    placeholderText="Select Start Time"
                                />
                            )}
                        />
                        {errors.startTime && (
                            <p className="text-sm text-red-500">
                                {errors.startTime.message}
                            </p>
                        )}
                    </div>

                    <div className="flex-1">
                        <Label>End Time</Label>
                        <Controller
                            control={control}
                            name="endTime"
                            render={({ field }) => (
                                <TimePicker
                                    time={field.value}
                                    onChange={(d: Date | null) =>
                                        field.onChange(d)
                                    }
                                    placeholderText="Select End Time"
                                />
                            )}
                        />
                        {errors.endTime && (
                            <p className="text-sm text-red-500">
                                {errors.endTime.message}
                            </p>
                        )}
                    </div>
                </div>

                {/* Notes */}
                <Textarea
                    {...register('notes')}
                    placeholder="Notes (optional)"
                    rows={3}
                />
            </div>

            <div className="flex justify-end gap-2">
                <Button type="button" variant="outline" onClick={onClose}>
                    Cancel
                </Button>
                <Button type="submit" disabled={loading}>
                    Next
                </Button>
            </div>
        </form>
    )
}
