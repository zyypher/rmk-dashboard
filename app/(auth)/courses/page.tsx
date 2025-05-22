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
import {
    Select,
    SelectTrigger,
    SelectValue,
    SelectContent,
    SelectItem,
} from '@/components/ui/select'
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group'
import { MultiSelect, MultiSelectItem } from '@/components/ui/multi-select'
import { FloatingLabelInput } from '@/components/ui/FloatingLabelInput'
import * as yup from 'yup'
import { yupResolver } from '@hookform/resolvers/yup'
import { Course } from '@/types/course'
import { useUserRole } from '@/hooks/useUserRole'
import debounce from 'lodash/debounce'
import { Input } from '@/components/ui/input'

interface Category {
    id: string
    name: string
}

interface Language {
    id: string
    name: string
}

const courseSchema = yup.object({
    title: yup.string().required('Course title is required'),
    duration: yup.string().required('Duration is required'),
    categoryId: yup.string().required('Category is required'),
    isCertified: yup.string().required('Certification status is required'),
    isPublic: yup.string().required('Public status is required'),
    shortname: yup.string().notRequired(),
    languages: yup
        .array()
        .of(yup.string())
        .min(1, 'At least one language is required'),
})

const CoursesPage = () => {
    const [courses, setCourses] = useState<Course[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [selectedCourse, setSelectedCourse] = useState<Course | null>(null)
    const [courseToDelete, setCourseToDelete] = useState<Course | null>(null)
    const [categories, setCategories] = useState<Category[]>([])
    const [languagesList, setLanguagesList] = useState<Language[]>([])
    const [formLoading, setFormLoading] = useState(false)
    const [deleteLoading, setDeleteLoading] = useState(false)
    const [dependencyErrorModal, setDependencyErrorModal] = useState(false)
    const [dependencyInfo, setDependencyInfo] = useState<{
        bookings: number
        languages: number
    } | null>(null)
    const [search, setSearch] = useState('')

    const role = useUserRole()

    const {
        register,
        handleSubmit,
        reset,
        watch,
        setValue,
        trigger,
        formState: { errors },
    } = useForm({ resolver: yupResolver(courseSchema) })

    useEffect(() => {
        register('languages')
    }, [register])

    const debouncedSearch = debounce(async (query: string) => {
        try {
            setLoading(true)
            const res = await axios.get('/api/courses/search', {
                params: { q: query },
            })
            setCourses(res.data)
        } catch {
            toast.error('Failed to search courses')
        } finally {
            setLoading(false)
        }
    }, 500)

    // Call debounce when input changes
    const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const val = e.target.value
        setSearch(val)
        debouncedSearch(val)
    }

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
                isCertified: selectedCourse.isCertified ? 'yes' : 'no',
                isPublic: selectedCourse.isPublic ? 'public' : 'inhouse',
                languages: selectedCourse.languages.map((l: any) => l.name),
                shortname: selectedCourse.shortname || '',
            })
        }
    }, [selectedCourse, reset])

    const fetchDropdowns = async () => {
        try {
            const [catRes, langRes] = await Promise.all([
                axios.get('/api/categories'),
                axios.get('/api/languages'),
            ])
            setCategories(catRes.data)
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
        // Delay reset so it runs after the modal and RHF form mount
        setTimeout(() => {
            reset({
                title: '',
                shortname: '',
                duration: '',
                categoryId: '',
                isCertified: 'yes',
                isPublic: 'public',
                languages: [],
            })
        }, 0)
    }

    const openEditDialog = (course: Course) => {
        setSelectedCourse(course)
        setDialogOpen(true)
        setValue('title', course.title)
        setValue('duration', course.duration)
        setValue('categoryId', course.categoryId)
        setValue('isCertified', course.isCertified ? 'yes' : 'no')
        setValue('isPublic', course.isPublic ? 'public' : 'inhouse')
        setValue(
            'languages',
            course.languages.map((l: any) => l.name),
        )
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
            <div className="flex flex-wrap items-center justify-between gap-3">
                <Input
                    placeholder="Search courses"
                    value={search}
                    onChange={handleSearchChange}
                    className="w-full min-w-[16rem] sm:max-w-lg"
                />

                {(role === 'ADMIN' || role === 'EDITOR') && (
                    <div className="flex justify-end">
                        <Button onClick={openAddDialog}>
                            <Plus className="mr-2 h-4 w-4" />
                            Add Course
                        </Button>
                    </div>
                )}
            </div>

            <DataTable
                columns={columns({ role, openEditDialog, confirmDelete })}
                data={courses}
                filterField="title"
                loading={loading}
            />

            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedCourse ? 'Edit Course' : 'Add Course'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    <FloatingLabelInput
                        label="Course Title"
                        value={watch('title')}
                        onChange={(val) =>
                            setValue('title', val, { shouldValidate: true })
                        }
                        name="title"
                        error={errors.title?.message as string}
                    />

                    <FloatingLabelInput
                        label="Short Name"
                        value={watch('shortname') || ''}
                        onChange={(val) => setValue('shortname', val)}
                        name="shortname"
                        error={errors.shortname?.message as string}
                    />

                    <FloatingLabelInput
                        label="Duration (hours)"
                        type="number"
                        value={watch('duration')}
                        onChange={(val) =>
                            setValue('duration', val, {
                                shouldValidate: true,
                            })
                        }
                        name="duration"
                        error={errors.duration?.message as string}
                    />

                    <div>
                        <label className="text-sm font-medium text-gray-700">
                            Category
                        </label>
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
                            <p className="mt-1 text-sm text-red-600">
                                {errors.categoryId.message as string}
                            </p>
                        )}
                    </div>

                    <div>
                        <label className="text-sm font-medium text-gray-700">
                            Languages
                        </label>

                        <MultiSelect
                            value={
                                (watch('languages') || []).filter(
                                    Boolean,
                                ) as string[]
                            }
                            onChange={(vals: string[]) => {
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
                            <p className="mt-1 text-sm text-red-600">
                                {errors.languages.message as string}
                            </p>
                        )}
                    </div>

                    <div className="space-y-1">
                        <p className="text-sm font-medium text-gray-700">
                            Course Type
                        </p>
                        <RadioGroup
                            value={watch('isPublic')}
                            onValueChange={(val) =>
                                setValue('isPublic', val, {
                                    shouldValidate: true,
                                })
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
                        {errors.isPublic && (
                            <p className="text-sm text-red-600">
                                {errors.isPublic.message as string}
                            </p>
                        )}
                    </div>

                    <div className="space-y-1">
                        <p className="text-sm font-medium text-gray-700">
                            Certification
                        </p>
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
                        {errors.isCertified && (
                            <p className="text-sm text-red-600">
                                {errors.isCertified.message as string}
                            </p>
                        )}
                    </div>
                </div>
            </Dialog>

            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Course"
                onSubmit={handleDelete}
                buttonLoading={deleteLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="font-semibold text-red-600">
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
                    <p className="text-sm text-red-600">
                        Unable to determine dependencies.
                    </p>
                ) : (
                    <ul className="mt-4 list-disc space-y-1 pl-5 text-sm text-red-600">
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
