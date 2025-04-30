'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { Button } from '@/components/ui/button'
import { Plus } from 'lucide-react'
import PageHeading from '@/components/layout/page-heading'
import { Dialog } from '@/components/ui/dialog'
import { columns } from '@/components/custom/table/courses/columns'
import { DataTable } from '@/components/custom/table/data-table'
import { useForm } from 'react-hook-form'
import { Input } from '@/components/ui/input'
import {
    Select,
    SelectTrigger,
    SelectValue,
    SelectContent,
    SelectItem,
} from '@/components/ui/select'
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group'
import { MultiSelect, MultiSelectItem } from '@/components/ui/multi-select'

interface Category {
    id: string
    name: string
}

interface Trainer {
    id: string
    name: string
}

interface Language {
    id: string
    name: string
}

interface Course {
    id: string
    title: string
    duration: string
    isCertified: boolean
    isPublic: boolean
    trainerId: string
    categoryId: string
    languages: string[]
    category: { name: string }
    trainer: { name: string }
}

const CoursesPage = () => {
    const [courses, setCourses] = useState<Course[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [selectedCourse, setSelectedCourse] = useState<Course | null>(null)
    const [courseToDelete, setCourseToDelete] = useState<Course | null>(null)
    const [categories, setCategories] = useState<Category[]>([])
    const [trainers, setTrainers] = useState<Trainer[]>([])
    const [languagesList, setLanguagesList] = useState<Language[]>([])
    const [formLoading, setFormLoading] = useState(false)
    const [deleteLoading, setDeleteLoading] = useState(false)
    const [dependencyErrorModal, setDependencyErrorModal] = useState(false)
    const [dependencyInfo, setDependencyInfo] = useState<{
        bookings: number
        languages: number
    } | null>(null)

    const {
        register,
        handleSubmit,
        reset,
        watch,
        setValue,
        getValues,
        formState: { errors },
    } = useForm()

    const fetchCourses = async () => {
        setLoading(true)
        try {
            const res = await axios.get('/api/courses')
            setCourses(res.data)
        } catch {
            toast.error('Failed to fetch courses')
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        if (selectedCourse) {
            reset({
                title: selectedCourse.title,
                duration: selectedCourse.duration,
                categoryId: selectedCourse.categoryId,
                trainerId: selectedCourse.trainerId,
                isCertified: selectedCourse.isCertified ? 'yes' : 'no',
                isPublic: selectedCourse.isPublic ? 'public' : 'inhouse',
                languages: selectedCourse.languages.map((l: any) => l.name),
            })
        }
    }, [selectedCourse, reset])

    const fetchDropdowns = async () => {
        try {
            const [catRes, trainerRes, langRes] = await Promise.all([
                axios.get('/api/categories'),
                axios.get('/api/trainers').catch(() => ({ data: [] })),
                axios.get('/api/languages'),
            ])
            setCategories(catRes.data)
            setTrainers(trainerRes.data)
            setLanguagesList(langRes.data)
        } catch {
            toast.error('Failed to load dropdown data')
        }
    }

    useEffect(() => {
        fetchCourses()
        fetchDropdowns()
    }, [])

    const openAddDialog = () => {
        setSelectedCourse(null)
        reset()
        setDialogOpen(true)
    }

    const openEditDialog = (course: Course) => {
        setSelectedCourse(course)
        setDialogOpen(true)
        setValue('title', course.title)
        setValue('duration', course.duration)
        setValue('categoryId', course.categoryId)
        setValue('trainerId', course.trainerId)
        setValue('isCertified', course.isCertified ? 'yes' : 'no')
        setValue('isPublic', course.isPublic ? 'public' : 'inhouse')
        setValue('languages', course.languages.map((l: any) => l.name))
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)
        try {
            const transformedData = {
                ...data,
                isCertified: data.isCertified === 'yes',
                isPublic: data.isPublic === 'public',
            }

            if (selectedCourse) {
                await axios.put(
                    `/api/courses/${selectedCourse.id}`,
                    transformedData,
                )
                toast.success('Course updated successfully')
            } else {
                await axios.post('/api/courses', transformedData)
                toast.success('Course added successfully')
            }
            fetchCourses()
            setDialogOpen(false)
        } catch {
            toast.error('Failed to submit form')
        } finally {
            setFormLoading(false)
        }
    }

    const confirmDelete = (course: Course) => {
        setCourseToDelete(course)
        setDeleteDialogOpen(true)
    }

    const handleDelete = async () => {
        if (!courseToDelete) return
        setDeleteLoading(true)

        try {
            const res = await axios.delete(`/api/courses/${courseToDelete.id}`)
            if (res.status === 200) {
                toast.success('Course deleted successfully')
                fetchCourses()
                setDeleteDialogOpen(false)
            }
        } catch (err: any) {
            if (
                err?.response?.status === 409 &&
                err.response.data.dependencies
            ) {
                setDependencyInfo(err.response.data.dependencies)
                setDeleteDialogOpen(false)
                setDependencyErrorModal(true)
            } else {
                toast.error('Failed to delete course')
            }
        } finally {
            setDeleteLoading(false)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Courses" />
            <div className="flex justify-end">
                <Button onClick={openAddDialog}>
                    <Plus className="mr-2 h-4 w-4" />
                    Add Course
                </Button>
            </div>

            <DataTable
                columns={columns({ openEditDialog, confirmDelete })}
                data={courses}
                filterField="title"
                loading={loading}
            />

            {/* Add/Edit Dialog */}
            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedCourse ? 'Edit Course' : 'Add Course'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    <div>
                        <Input
                            placeholder="Course Title"
                            {...register('title', {
                                required: 'Course title is required',
                            })}
                        />
                        {errors.title && (
                            <p className="text-error text-red-600 mt-1 text-sm">
                                {errors.title.message as string}
                            </p>
                        )}
                    </div>

                    <div>
                        <Select
                            value={watch('categoryId')}
                            onValueChange={(value) =>
                                setValue('categoryId', value, {
                                    shouldValidate: true,
                                })
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
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.categoryId.message as string}
                            </p>
                        )}
                    </div>

                    <div>
                        <MultiSelect
                            value={watch('languages')}
                            onChange={(vals: string[]) =>
                                setValue('languages', vals, {
                                    shouldValidate: true,
                                })
                            }
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
                                At least one language is required
                            </p>
                        )}
                    </div>

                    <div>
                        <Input
                            type="number"
                            step="0.5"
                            placeholder="Duration (hours)"
                            {...register('duration', {
                                required: 'Duration is required',
                            })}
                        />
                        {errors.duration && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.duration.message as string}
                            </p>
                        )}
                    </div>

                    <div>
                        <Select
                            value={watch('trainerId')}
                            onValueChange={(value) =>
                                setValue('trainerId', value, {
                                    shouldValidate: true,
                                })
                            }
                        >
                            <SelectTrigger>
                                <SelectValue placeholder="Select Trainer" />
                            </SelectTrigger>
                            <SelectContent>
                                {trainers.map((t) => (
                                    <SelectItem key={t.id} value={t.id}>
                                        {t.name}
                                    </SelectItem>
                                ))}
                            </SelectContent>
                        </Select>
                        {errors.trainerId && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.trainerId.message as string}
                            </p>
                        )}
                    </div>

                    <RadioGroup
                        value={watch('isPublic')}
                        onValueChange={(val) =>
                            setValue('isPublic', val, { shouldValidate: true })
                        }
                    >
                        <div className="flex gap-4">
                            <label className="flex items-center gap-2">
                                <RadioGroupItem value="public" /> Public
                            </label>
                            <label className="flex items-center gap-2">
                                <RadioGroupItem value="inhouse" /> In-house
                            </label>
                        </div>
                    </RadioGroup>

                    <RadioGroup
                        value={watch('isCertified')}
                        onValueChange={(val) =>
                            setValue('isCertified', val, {
                                shouldValidate: true,
                            })
                        }
                    >
                        <div className="flex gap-4">
                            <label className="flex items-center gap-2">
                                <RadioGroupItem value="yes" /> Certified
                            </label>
                            <label className="flex items-center gap-2">
                                <RadioGroupItem value="no" /> Not Certified
                            </label>
                        </div>
                    </RadioGroup>
                </div>
            </Dialog>

            {/* Delete Dialog */}
            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Course"
                onSubmit={handleDelete}
                buttonLoading={deleteLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="text-red-600 font-semibold">
                        {courseToDelete?.title}
                    </span>
                    ?
                </p>
            </Dialog>
            <Dialog
                isOpen={dependencyErrorModal}
                onClose={() => {
                    setDependencyErrorModal(false)
                    setCourseToDelete(null)
                }}
                title="Cannot Delete Course"
                submitLabel="Close"
                onSubmit={() => {
                    setDependencyErrorModal(false)
                    setCourseToDelete(null)
                }}
            >
                <p className="text-sm text-gray-700">
                    This course cannot be deleted because it is linked to the
                    following:
                </p>
                {!dependencyInfo ? (
                    <p className="text-red-600 text-sm">
                        Unable to determine dependencies.
                    </p>
                ) : (
                    <ul className="text-red-600 mt-4 list-disc space-y-1 pl-5 text-sm">
                        {dependencyInfo.bookings > 0 && (
                            <li>
                                {dependencyInfo.bookings} training session(s)
                                using this course
                            </li>
                        )}
                        {dependencyInfo.languages > 0 && (
                            <li>
                                {dependencyInfo.languages} language relation(s)
                            </li>
                        )}
                    </ul>
                )}

                <p className="mt-4 text-sm text-gray-500">
                    Please remove these dependencies before deleting this
                    course.
                </p>
            </Dialog>
        </div>
    )
}

export default CoursesPage
