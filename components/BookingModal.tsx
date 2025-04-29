'use client'

import { useEffect } from 'react'
import { useForm, Controller } from 'react-hook-form'
import { yupResolver } from '@hookform/resolvers/yup'
import * as yup from 'yup'
import { Dialog } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
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
import { SessionStatus } from '@prisma/client'
import { Course } from '@/types/course'
import { Trainer } from '@/types'
import { Room } from '@/types/room'
import { Language } from '@/types/language'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'

interface BookingModalProps {
    isOpen: boolean
    onClose: () => void
    onNext: (data: any) => void
    onSubmit: (data: any) => void
    loading?: boolean
    initialData?: any
    courses: Course[]
    trainers: Trainer[]
    rooms: Room[]
    languages: Language[]
}

type BookingFormValues = {
    courseId: string
    trainerId: string
    roomId: string
    date: Date | null
    startTime: Date | null
    endTime: Date | null
    language: string
    status: SessionStatus
    notes?: string
}

export const bookingSchema = yup.object({
    courseId: yup.string().required('Course is required'),
    trainerId: yup.string().required('Trainer is required'),
    roomId: yup.string().required('Room is required'),
    date: yup.date().nullable().required('Date is required'),
    startTime: yup.date().nullable().required('Start time is required'),
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

    language: yup.string().required('Language is required'),
    status: yup.mixed().required('Status is required'),
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
            trainerId: '',
            roomId: '',
            date: null,
            startTime: null,
            endTime: null,
            language: '',
            status: undefined,
            notes: '',
        },
        resolver: yupResolver(bookingSchema) as any,
    })

    useEffect(() => {
        if (initialData) {
            reset({
                ...initialData,
                date: initialData.date ? new Date(initialData.date) : null,
                startTime: initialData.startTime
                    ? new Date(initialData.startTime)
                    : null,
                endTime: initialData.endTime
                    ? new Date(initialData.endTime)
                    : null,
            })
        }
    }, [initialData, reset])

    return (
        <Dialog
            isOpen={isOpen}
            onClose={onClose}
            title={initialData ? 'Edit Booking' : 'Add Booking'}
            onSubmit={handleSubmit(onNext)}
            submitLabel="Next"
        >
            <div className="max-h-[75vh] space-y-4 overflow-y-auto">
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
                    <p className="text-red-500 text-sm">
                        {errors.courseId.message}
                    </p>
                )}

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
                    <p className="text-red-500 text-sm">
                        {errors.trainerId.message}
                    </p>
                )}

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
                        {rooms.map((room) => (
                            <SelectItem key={room.id} value={room.id}>
                                {room.name}
                            </SelectItem>
                        ))}
                    </SelectContent>
                </Select>
                {errors.roomId && (
                    <p className="text-red-500 text-sm">
                        {errors.roomId.message}
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
                    <p className="text-red-500 text-sm">
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
                            <p className="text-red-500 text-sm">
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
                            <p className="text-red-500 text-sm">
                                {errors.endTime.message}
                            </p>
                        )}
                    </div>
                </div>

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
                    <p className="text-red-500 text-sm">
                        {errors.language.message}
                    </p>
                )}

                <Select
                    value={watch('status')}
                    onValueChange={(val) =>
                        setValue('status', val as SessionStatus, {
                            shouldValidate: true,
                        })
                    }
                >
                    <SelectTrigger>
                        <SelectValue placeholder="Select Status" />
                    </SelectTrigger>
                    <SelectContent>
                        {Object.values(SessionStatus).map((status) => (
                            <SelectItem key={status} value={status}>
                                {status}
                            </SelectItem>
                        ))}
                    </SelectContent>
                </Select>
                {errors.status && (
                    <p className="text-red-500 text-sm">
                        {errors.status.message}
                    </p>
                )}

                <Textarea
                    placeholder="Notes (optional)"
                    {...register('notes')}
                />
            </div>
        </Dialog>
    )
}
