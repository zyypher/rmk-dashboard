'use client'

import { useEffect, useState } from 'react'
import { Plus } from 'lucide-react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { useForm, Controller } from 'react-hook-form'
import * as yup from 'yup'
import { yupResolver } from '@hookform/resolvers/yup'
import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/trainer-leaves/columns'
import {
    Select,
    SelectTrigger,
    SelectValue,
    SelectContent,
    SelectItem,
} from '@/components/ui/select'
import { FloatingLabelInput } from '@/components/ui/FloatingLabelInput'
import { DatePicker } from '@/components/ui/DatePicker'

interface Trainer {
    id: string
    name: string
}

interface TrainerLeave {
    id: string
    trainerId: string
    trainer: { name: string }
    date: string
    reason?: string
}

const leaveSchema = yup.object({
    trainerId: yup.string().required('Trainer is required'),
    date: yup.date().required('Date is required').typeError('Date is required'),
    reason: yup.string().optional(),
})

export default function TrainerLeavesPage() {
    const [leaves, setLeaves] = useState<TrainerLeave[]>([])
    const [trainers, setTrainers] = useState<Trainer[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [formLoading, setFormLoading] = useState(false)
    const [deleteLoading, setDeleteLoading] = useState(false)
    const [selectedLeave, setSelectedLeave] = useState<TrainerLeave | null>(
        null,
    )
    const [leaveToDelete, setLeaveToDelete] = useState<TrainerLeave | null>(
        null,
    )

    const {
        register,
        handleSubmit,
        reset,
        setValue,
        control,
        watch,
        formState: { errors },
    } = useForm({
        resolver: yupResolver(leaveSchema),
        defaultValues: {
            trainerId: '',
            date: undefined,
            reason: '',
        },
    })

    const fetchLeaves = async () => {
        setLoading(true)
        try {
            const res = await axios.get('/api/trainer-leaves')
            setLeaves(res.data)
        } catch {
            toast.error('Failed to fetch trainer leaves')
        } finally {
            setLoading(false)
        }
    }

    const fetchTrainers = async () => {
        try {
            const res = await axios.get('/api/trainers')
            setTrainers(res.data)
        } catch {
            toast.error('Failed to fetch trainers')
        }
    }

    useEffect(() => {
        fetchLeaves()
        fetchTrainers()
    }, [])

    const openEditDialog = (leave: TrainerLeave) => {
        setSelectedLeave(leave)
        setDialogOpen(true)
        setValue('trainerId', leave.trainerId)
        setValue('date', new Date(leave.date))
        setValue('reason', leave.reason || '')
    }

    const confirmDelete = (leave: TrainerLeave) => {
        setLeaveToDelete(leave)
        setDeleteDialogOpen(true)
    }

    const handleDelete = async () => {
        if (!leaveToDelete) return
        setDeleteLoading(true)
        try {
            await axios.delete(`/api/trainer-leaves/${leaveToDelete.id}`)
            toast.success('Leave deleted')
            fetchLeaves()
        } catch {
            toast.error('Failed to delete leave')
        } finally {
            setDeleteDialogOpen(false)
            setLeaveToDelete(null)
            setDeleteLoading(false)
        }
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)
        const payload = {
            ...data,
            date: data.date.toISOString(),
        }

        try {
            if (selectedLeave) {
                await axios.put(
                    `/api/trainer-leaves/${selectedLeave.id}`,
                    payload,
                )
                toast.success('Leave updated')
            } else {
                await axios.post('/api/trainer-leaves', payload)
                toast.success('Leave added')
            }
            fetchLeaves()
            setDialogOpen(false)
        } catch {
            toast.error('Failed to submit leave')
        } finally {
            setFormLoading(false)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Trainer Leaves" />
            <div className="flex justify-end">
                <Button
                    onClick={() => {
                        reset()
                        setSelectedLeave(null)
                        setDialogOpen(true)
                    }}
                >
                    <Plus className="mr-2 h-4 w-4" /> Add Leave
                </Button>
            </div>

            <DataTable
                columns={columns({ openEditDialog, confirmDelete })}
                data={leaves}
                filterField="trainer.name"
                loading={loading}
            />

            {/* Create/Edit Dialog */}
            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedLeave ? 'Edit Leave' : 'Add Leave'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    {/* Trainer Select */}
                    <div>
                        <label className="text-sm font-medium text-gray-700">
                            Trainer
                        </label>
                        <Controller
                            name="trainerId"
                            control={control}
                            render={({ field }) => (
                                <Select
                                    value={field.value}
                                    onValueChange={field.onChange}
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
                            )}
                        />
                        {errors.trainerId && (
                            <p className="text-red-600 text-sm">
                                {errors.trainerId.message}
                            </p>
                        )}
                    </div>

                    {/* Date Picker */}
                    <div>
                        <label className="text-sm font-medium text-gray-700">
                            Date
                        </label>
                        <Controller
                            name="date"
                            control={control}
                            render={({ field }) => (
                                <DatePicker
                                    date={field.value}
                                    onChange={field.onChange}
                                />
                            )}
                        />
                        {errors.date && (
                            <p className="text-red-600 text-sm">
                                {errors.date.message as string}
                            </p>
                        )}
                    </div>

                    {/* Reason Input */}
                    <FloatingLabelInput
                        label="Reason (optional)"
                        name="reason"
                        value={watch('reason')}
                        onChange={(val) => setValue('reason', val)}
                        error={errors.reason?.message}
                    />
                </div>
            </Dialog>

            {/* Delete Dialog */}
            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Leave"
                onSubmit={handleDelete}
                buttonLoading={deleteLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="text-red-600 font-semibold">
                        {`${leaveToDelete?.trainer.name}'s`} leave
                    </span>
                    ?
                </p>
            </Dialog>
        </div>
    )
}
