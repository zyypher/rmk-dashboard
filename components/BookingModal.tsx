'use client'

import { useEffect } from 'react'
import { useForm, Controller } from 'react-hook-form'
import { yupResolver } from '@hookform/resolvers/yup'
import * as yup from 'yup'
import { Dialog } from '@/components/ui/dialog'
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

interface BookingModalProps {
    isOpen: boolean
    onClose: () => void
    onNext: (data: any) => void
    loading?: boolean
    initialData?: any
    courses: Course[]
    trainers: Trainer[]
    rooms: Room[]
    languages: Language[]
    categories: Category[]
    locations: Location[]
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
    isOpen,
    onClose,
    onNext,
    loading,
    initialData,
    courses,
    trainers,
    rooms,
    languages,
    categories,
    locations,
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

    useEffect(() => {
        if (initialData) {
            reset({
                courseId: initialData.courseId,
                categoryId:
                    initialData.course?.categoryId ||
                    initialData?.categoryId ||
                    '',
                language: initialData.language,
                locationId: initialData.locationId,
                roomId: initialData.roomId,
                trainerId: initialData.trainerId,
                date: initialData.date ? new Date(initialData.date) : null,
                startTime: initialData.startTime
                    ? new Date(initialData.startTime)
                    : null,
                endTime: initialData.endTime
                    ? new Date(initialData.endTime)
                    : null,
                notes: initialData.notes || '',
            })
        }
    }, [initialData, reset])

    const selectedLocationId = watch('locationId')
    const filteredRooms = rooms.filter(
        (room) =>
            room.locationId === selectedLocationId &&
            room.capacity &&
            room.capacity > 0,
    )

    return (
        <Dialog
            isOpen={isOpen}
            onClose={onClose}
            title={initialData ? 'Edit Booking' : 'Add Booking'}
            onSubmit={handleSubmit(onNext)}
            submitLabel="Next"
        >
            <div className="max-h-[75vh] space-y-4 overflow-y-auto">
                {/* Course */}
                <Select
                    value={watch('courseId')}
                    onValueChange={(val) =>
                        setValue('courseId', val, { shouldValidate: true })
                    }
                >
                    <SelectTrigger>
                        <SelectValue placeholder="Select Course" />
                    </SelectTrigger>
                    <SelectContent>
                        {courses.map((course) => (
                            <SelectItem key={course.id} value={course.id}>
                                {course.title}
                            </SelectItem>
                        ))}
                    </SelectContent>
                </Select>
                {errors.courseId && (
                    <p className="text-sm text-red-500">
                        {errors.courseId.message}
                    </p>
                )}

                {/* Category */}
                <Select
                    value={watch('categoryId')}
                    onValueChange={(val) =>
                        setValue('categoryId', val, { shouldValidate: true })
                    }
                >
                    <SelectTrigger>
                        <SelectValue placeholder="Select Category" />
                    </SelectTrigger>
                    <SelectContent>
                        {categories.map((cat) => (
                            <SelectItem key={cat.id} value={cat.id}>
                                {cat.name}
                            </SelectItem>
                        ))}
                    </SelectContent>
                </Select>
                {errors.categoryId && (
                    <p className="text-sm text-red-500">
                        {errors.categoryId.message}
                    </p>
                )}

                {/* Language */}
                <Select
                    value={watch('language')}
                    onValueChange={(val) =>
                        setValue('language', val, { shouldValidate: true })
                    }
                >
                    <SelectTrigger>
                        <SelectValue placeholder="Select Language" />
                    </SelectTrigger>
                    <SelectContent>
                        {languages.map((lang) => (
                            <SelectItem key={lang.id} value={lang.name}>
                                {lang.name}
                            </SelectItem>
                        ))}
                    </SelectContent>
                </Select>
                {errors.language && (
                    <p className="text-sm text-red-500">
                        {errors.language.message}
                    </p>
                )}

                {/* Location */}
                <Select
                    value={watch('locationId')}
                    onValueChange={(val) =>
                        setValue('locationId', val, { shouldValidate: true })
                    }
                >
                    <SelectTrigger>
                        <SelectValue placeholder="Select Location" />
                    </SelectTrigger>
                    <SelectContent>
                        {locations.map((loc) => (
                            <SelectItem key={loc.id} value={loc.id}>
                                {loc.name}
                            </SelectItem>
                        ))}
                    </SelectContent>
                </Select>
                {errors.locationId && (
                    <p className="text-sm text-red-500">
                        {errors.locationId.message}
                    </p>
                )}

                {/* Room */}
                <Select
                    value={watch('roomId')}
                    onValueChange={(val) =>
                        setValue('roomId', val, { shouldValidate: true })
                    }
                >
                    <SelectTrigger>
                        <SelectValue placeholder="Select Room" />
                    </SelectTrigger>
                    <SelectContent>
                    {filteredRooms.length > 0 ? (
                            filteredRooms.map((room) => (
                                <SelectItem key={room.id} value={room.id}>
                                    {`${room.name} – ${room.capacity} participants – ${room.location.name}`}
                                </SelectItem>
                            ))
                        ) : (
                            <div className="px-4 py-2 text-sm text-gray-500">
                                No rooms available for the selected location.
                            </div>
                        )}
                    </SelectContent>
                </Select>
                {errors.roomId && (
                    <p className="text-sm text-red-500">
                        {errors.roomId.message}
                    </p>
                )}

                {/* Trainer */}
                <Select
                    value={watch('trainerId')}
                    onValueChange={(val) =>
                        setValue('trainerId', val, { shouldValidate: true })
                    }
                >
                    <SelectTrigger>
                        <SelectValue placeholder="Select Trainer" />
                    </SelectTrigger>
                    <SelectContent>
                        {trainers.map((trainer) => (
                            <SelectItem key={trainer.id} value={trainer.id}>
                                {trainer.name}
                            </SelectItem>
                        ))}
                    </SelectContent>
                </Select>
                {errors.trainerId && (
                    <p className="text-sm text-red-500">
                        {errors.trainerId.message}
                    </p>
                )}

                <Label>Date</Label>
                <Controller
                    name="date"
                    control={control}
                    render={({ field }) => (
                        <DatePicker
                            date={field.value}
                            onChange={(val) => field.onChange(val)}
                        />
                    )}
                />
                {errors.date && (
                    <p className="text-sm text-red-500">
                        {errors.date.message}
                    </p>
                )}

                <div className="flex gap-4">
                    <div className="flex-1">
                        <Label>Start Time</Label>
                        <Controller
                            name="startTime"
                            control={control}
                            render={({ field }) => (
                                <TimePicker
                                    time={field.value}
                                    onChange={(val) => field.onChange(val)}
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
                            name="endTime"
                            control={control}
                            render={({ field }) => (
                                <TimePicker
                                    time={field.value}
                                    onChange={(val) => field.onChange(val)}
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

                <Textarea
                    placeholder="Notes (optional)"
                    {...register('notes')}
                />
            </div>
        </Dialog>
    )
}
