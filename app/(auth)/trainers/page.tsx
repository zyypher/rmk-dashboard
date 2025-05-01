'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Plus } from 'lucide-react'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/trainers/columns'
import { Dialog } from '@/components/ui/dialog'
import { useForm } from 'react-hook-form'
import { MultiSelect, MultiSelectItem } from '@/components/ui/multi-select'
import { FloatingLabelInput } from '@/components/ui/FloatingLabelInput'
import { Day, daysList } from '@/lib/constants'
import * as yup from 'yup'
import { yupResolver } from '@hookform/resolvers/yup'
import { TimePicker } from '@/components/ui/TimePicker'

interface CourseOption {
    id: string
    title: string
}

interface Language {
    id: string
    name: string
}

interface Trainer {
    id: string
    name: string
    email: string
    phone: string
    languages: string[]
    availableDays: Day[]
    timeSlots: { start: string; end: string }[]
    dailyTimeSlots?: { start: Date; end: Date }[]
    courses: { id: string; title: string }[]
}

const trainerSchema = yup.object({
    name: yup.string().required('Name is required'),
    email: yup
        .string()
        .required('Email is required')
        .email('Invalid email address'),
    phone: yup
        .string()
        .required('Phone is required')
        .matches(/^(\+?\d{1,3}[- ]?)?\d{10}$/, 'Invalid phone number'),
    languages: yup
        .array()
        .of(yup.string())
        .min(1, 'At least one language is required'),
    availableDays: yup
        .array()
        .of(yup.string())
        .min(1, 'At least one day is required'),
    courses: yup
        .array()
        .of(yup.string())
        .min(1, 'At least one course is required'),
    dailyTimeSlots: yup
        .array()
        .of(
            yup.object({
                start: yup
                    .date()
                    .typeError('Start time is required')
                    .required(),
                end: yup.date().typeError('End time is required').required(),
            }),
        )
        .min(1, 'At least one time slot is required'),
})

export default function TrainersPage() {
    const [trainers, setTrainers] = useState<Trainer[]>([])
    const [languagesList, setLanguagesList] = useState<Language[]>([])
    const [coursesList, setCoursesList] = useState<CourseOption[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [selectedTrainer, setSelectedTrainer] = useState<Trainer | null>(null)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [trainerToDelete, setTrainerToDelete] = useState<Trainer | null>(null)
    const [formLoading, setFormLoading] = useState(false)
    const [deleteLoading, setDeleteLoading] = useState(false)

    const {
        register,
        handleSubmit,
        reset,
        setValue,
        watch,
        trigger,
        formState: { errors },
    } = useForm({
        resolver: yupResolver(trainerSchema),
    })

    const [slots, setSlots] = useState<
        { start: Date | null; end: Date | null }[]
    >([])

    const fetchTrainers = async () => {
        setLoading(true)
        try {
            const res = await axios.get('/api/trainers')
            setTrainers(res.data)
        } catch {
            toast.error('Failed to fetch trainers')
        } finally {
            setLoading(false)
        }
    }

    const fetchLanguages = async () => {
        try {
            const res = await axios.get('/api/languages')
            setLanguagesList(res.data)
        } catch {
            toast.error('Failed to fetch languages')
        }
    }

    const fetchCourses = async () => {
        try {
            const res = await axios.get('/api/courses')
            setCoursesList(res.data)
        } catch {
            toast.error('Failed to fetch courses')
        }
    }

    useEffect(() => {
        fetchTrainers()
        fetchLanguages()
        fetchCourses()
    }, [])

    const openAddDialog = () => {
        setSelectedTrainer(null)
        reset()
        setDialogOpen(true)
    }

    const openEditDialog = (trainer: Trainer) => {
        setSelectedTrainer(trainer)
        setDialogOpen(true)
        setValue('name', trainer.name)
        setValue('email', trainer.email)
        setValue('phone', trainer.phone)
        setValue('languages', trainer.languages)
        setValue('availableDays', trainer.availableDays)
        setValue(
            'courses',
            trainer.courses.map((c) => c.id),
        )
        setSlots(
            (trainer.dailyTimeSlots || []).map((s) => ({
                start: new Date(s.start),
                end: new Date(s.end),
            })),
        )
        setValue('dailyTimeSlots', trainer.dailyTimeSlots || [])
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)
        const payload = {
            ...data,
            dailyTimeSlots: data.dailyTimeSlots,
            courses: data.courses,
        }

        try {
            if (selectedTrainer) {
                await axios.put(`/api/trainers/${selectedTrainer.id}`, payload)
                toast.success('Trainer updated successfully')
            } else {
                await axios.post('/api/trainers', payload)
                toast.success('Trainer added successfully')
            }
            fetchTrainers()
            setDialogOpen(false)
        } catch {
            toast.error('Failed to submit form')
        } finally {
            setFormLoading(false)
        }
    }

    const confirmDelete = (trainer: Trainer) => {
        setTrainerToDelete(trainer)
        setDeleteDialogOpen(true)
    }

    const handleDelete = async () => {
        if (!trainerToDelete) return
        setDeleteLoading(true)
        try {
            await axios.delete(`/api/trainers/${trainerToDelete.id}`)
            toast.success('Trainer deleted successfully')
            fetchTrainers()
        } catch {
            toast.error('Failed to delete trainer')
        } finally {
            setDeleteDialogOpen(false)
            setTrainerToDelete(null)
            setDeleteLoading(false)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Trainers" />
            <div className="flex justify-end">
                <Button onClick={openAddDialog}>
                    <Plus className="mr-2 h-4 w-4" />
                    Add Trainer
                </Button>
            </div>

            <DataTable
                columns={columns({ openEditDialog, confirmDelete })}
                data={trainers}
                filterField="name"
                loading={loading}
            />

            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedTrainer ? 'Edit Trainer' : 'Add Trainer'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    <FloatingLabelInput
                        label="Name"
                        value={watch('name')}
                        onChange={(val) =>
                            setValue('name', val, { shouldValidate: true })
                        }
                        name="name"
                        error={errors.name?.message as string}
                    />

                    <FloatingLabelInput
                        label="Email"
                        value={watch('email')}
                        onChange={(val) =>
                            setValue('email', val, { shouldValidate: true })
                        }
                        name="email"
                        error={errors.email?.message as string}
                    />

                    <FloatingLabelInput
                        label="Phone"
                        value={watch('phone')}
                        onChange={(val) =>
                            setValue('phone', val, { shouldValidate: true })
                        }
                        name="phone"
                        error={errors.phone?.message as string}
                    />

                    <div className="space-y-1">
                        <label className="text-sm font-medium text-gray-700">
                            Languages
                        </label>
                        <MultiSelect
                            value={(watch('languages') || []).filter(
                                (v): v is string => Boolean(v),
                            )}
                            onChange={(vals) => {
                                setValue('languages', vals, {
                                    shouldValidate: true,
                                })
                                trigger('languages')
                            }}
                        >
                            {languagesList.map((lang) => (
                                <MultiSelectItem
                                    key={lang.id}
                                    value={lang.name}
                                >
                                    {lang.name}
                                </MultiSelectItem>
                            ))}
                        </MultiSelect>
                        {errors.languages && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.languages.message as string}
                            </p>
                        )}
                    </div>

                    <div className="space-y-1">
                        <label className="text-sm font-medium text-gray-700">
                            Available Days
                        </label>
                        <MultiSelect
                            value={(watch('availableDays') || []).filter(
                                (v): v is string => Boolean(v),
                            )}
                            onChange={(vals) =>
                                setValue('availableDays', vals, {
                                    shouldValidate: true,
                                })
                            }
                        >
                            {daysList.map((day) => (
                                <MultiSelectItem key={day} value={day}>
                                    {day}
                                </MultiSelectItem>
                            ))}
                        </MultiSelect>
                        {errors.availableDays && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.availableDays.message as string}
                            </p>
                        )}
                    </div>

                    <div className="space-y-1">
                        <label className="text-sm font-medium text-gray-700">
                            Assigned Courses
                        </label>
                        <MultiSelect
                            value={(watch('courses') || []).filter(
                                (v): v is string => Boolean(v),
                            )}
                            onChange={(vals) => setValue('courses', vals)}
                        >
                            {coursesList.map((course) => (
                                <MultiSelectItem
                                    key={course.id}
                                    value={course.id}
                                >
                                    {course.title}
                                </MultiSelectItem>
                            ))}
                        </MultiSelect>
                        {errors.courses && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.courses.message as string}
                            </p>
                        )}
                    </div>

                    {/* Daily Time Slots */}
                    <div className="space-y-2">
                        <label className="text-sm font-medium text-gray-700">
                            Daily Time Slots
                        </label>

                        {slots.map((slot, index) => (
                            <div
                                key={index}
                                className="flex items-center gap-2"
                            >
                                {/* Start Time Picker */}
                                <TimePicker
                                    time={slot.start}
                                    onChange={(val) => {
                                        const newSlots = [...slots]
                                        newSlots[index].start = val
                                        setSlots(newSlots)

                                        const validSlots = newSlots.filter(
                                            (
                                                s,
                                            ): s is {
                                                start: Date
                                                end: Date
                                            } =>
                                                s.start instanceof Date &&
                                                s.end instanceof Date,
                                        )
                                        setValue('dailyTimeSlots', validSlots)
                                    }}
                                />

                                <span>to</span>

                                {/* End Time Picker */}
                                <TimePicker
                                    time={slot.end}
                                    onChange={(val) => {
                                        const newSlots = [...slots]
                                        newSlots[index].end = val
                                        setSlots(newSlots)

                                        const validSlots = newSlots.filter(
                                            (
                                                s,
                                            ): s is {
                                                start: Date
                                                end: Date
                                            } =>
                                                s.start instanceof Date &&
                                                s.end instanceof Date,
                                        )
                                        setValue('dailyTimeSlots', validSlots)
                                    }}
                                />

                                {/* Remove Button */}
                                <Button
                                    type="button"
                                    //   variant="ghost"
                                    onClick={() => {
                                        const newSlots = slots.filter(
                                            (_, i) => i !== index,
                                        )
                                        setSlots(newSlots)

                                        const validSlots = newSlots.filter(
                                            (
                                                s,
                                            ): s is {
                                                start: Date
                                                end: Date
                                            } =>
                                                s.start instanceof Date &&
                                                s.end instanceof Date,
                                        )
                                        setValue('dailyTimeSlots', validSlots)
                                    }}
                                >
                                    Remove
                                </Button>
                            </div>
                        ))}

                        <Button
                            type="button"
                            variant="outline"
                            onClick={() => {
                                const now = new Date()
                                const oneHourLater = new Date(
                                    now.getTime() + 60 * 60 * 1000,
                                )

                                const newSlots = [
                                    ...slots,
                                    { start: now, end: oneHourLater },
                                ]
                                setSlots(newSlots)

                                const validSlots = newSlots.filter(
                                    (s): s is { start: Date; end: Date } =>
                                        s.start instanceof Date &&
                                        s.end instanceof Date,
                                )
                                setValue('dailyTimeSlots', validSlots)
                            }}
                        >
                            + Add Time Slot
                        </Button>

                        {errors.dailyTimeSlots && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.dailyTimeSlots.message as string}
                            </p>
                        )}
                    </div>
                </div>
            </Dialog>

            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Trainer"
                onSubmit={handleDelete}
                buttonLoading={deleteLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="text-red-600 font-semibold">
                        {trainerToDelete?.name}
                    </span>
                    ?
                </p>
            </Dialog>
        </div>
    )
}
