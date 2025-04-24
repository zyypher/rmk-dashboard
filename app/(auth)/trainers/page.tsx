'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Plus } from 'lucide-react'
import { Skeleton } from '@/components/ui/skeleton'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/trainers/columns'
import { Dialog } from '@/components/ui/dialog'
import { useForm } from 'react-hook-form'
import { Input } from '@/components/ui/input'
import { Day, daysList } from '@/lib/constants'
import { MultiSelect, MultiSelectItem } from '@/components/ui/multi-select'

interface Trainer {
    id: string
    name: string
    email: string
    phone: string
    languages: string[]
    availableDays: Day[]
    timeSlots: { start: string; end: string }[]
    courses: { id: string; title: string }[]
}

interface Language {
    id: string
    name: string
}

export default function TrainersPage() {
    const [trainers, setTrainers] = useState<Trainer[]>([])
    const [languagesList, setLanguagesList] = useState<Language[]>([])
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
        formState: { errors },
    } = useForm()

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

    useEffect(() => {
        fetchTrainers()
        fetchLanguages()
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
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)
        try {
            if (selectedTrainer) {
                await axios.put(`/api/trainers/${selectedTrainer.id}`, data)
                toast.success('Trainer updated successfully')
            } else {
                await axios.post('/api/trainers', data)
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
            {loading ? (
                <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
                    {Array.from({ length: 6 }).map((_, i) => (
                        <Skeleton key={i} className="h-24 w-full rounded-lg" />
                    ))}
                </div>
            ) : (
                <DataTable
                    columns={columns({ openEditDialog, confirmDelete })}
                    data={trainers}
                    filterField="name"
                />
            )}

            {/* Add/Edit Dialog */}
            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedTrainer ? 'Edit Trainer' : 'Add Trainer'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    <div>
                        <Input
                            placeholder="Name"
                            {...register('name', {
                                required: 'Name is required',
                            })}
                        />
                        {errors.name && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.name.message as string}
                            </p>
                        )}
                    </div>

                    <div>
                        <Input
                            placeholder="Email"
                            {...register('email', {
                                required: 'Email is required',
                            })}
                        />
                        {errors.email && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.email.message as string}
                            </p>
                        )}
                    </div>

                    <div>
                        <Input
                            placeholder="Phone"
                            {...register('phone', {
                                required: 'Phone is required',
                            })}
                        />
                        {errors.phone && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.phone.message as string}
                            </p>
                        )}
                    </div>

                    <div className="space-y-1">
                        <label className="text-sm font-medium text-gray-700">
                            Languages
                        </label>
                        <MultiSelect
                            label="Languages"
                            defaultValue={selectedTrainer?.languages || []}
                            onChange={(vals) =>
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
                                At least one language is required.
                            </p>
                        )}
                    </div>

                    <div className="space-y-1">
                        <label className="text-sm font-medium text-gray-700">
                            Available Days
                        </label>
                        <MultiSelect
                            label="Available Days"
                            defaultValue={selectedTrainer?.availableDays || []}
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
                                At least one day is required.
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
