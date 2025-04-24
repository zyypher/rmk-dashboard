'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { Button } from '@/components/ui/button'
import { Plus } from 'lucide-react'
import PageHeading from '@/components/layout/page-heading'
import { Dialog } from '@/components/ui/dialog'
import { Skeleton } from '@/components/ui/skeleton'
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
        setValue('languages', course.languages)
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
            await axios.delete(`/api/courses/${courseToDelete.id}`)
            toast.success('Course deleted successfully')
            fetchCourses()
        } catch {
            toast.error('Failed to delete course')
        } finally {
            setDeleteDialogOpen(false)
            setCourseToDelete(null)
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
            {loading ? (
                <div className="mt-4 grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
                    {Array.from({ length: 6 }).map((_, i) => (
                        <Skeleton key={i} className="h-24 w-full rounded-lg" />
                    ))}
                </div>
            ) : (
                <DataTable
                    columns={columns({ openEditDialog, confirmDelete })}
                    data={courses}
                    filterField="title"
                />
            )}

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
                            defaultValue={selectedCourse?.languages || []}
                            onChange={(vals: string[]) =>
                                setValue('languages', vals)
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

                    <RadioGroup defaultValue="public" {...register('isPublic')}>
                        <div className="flex gap-4">
                            <label className="flex items-center gap-2">
                                <RadioGroupItem value="public" /> Public
                            </label>
                            <label className="flex items-center gap-2">
                                <RadioGroupItem value="inhouse" /> In-house
                            </label>
                        </div>
                    </RadioGroup>

                    <RadioGroup defaultValue="yes" {...register('isCertified')}>
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
        </div>
    )
}

export default CoursesPage
