'use client'

import { useEffect, useState } from 'react'
import { Plus } from 'lucide-react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { useForm, Controller } from 'react-hook-form'

import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Skeleton } from '@/components/ui/skeleton'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/trainer-leaves/columns'
import { Day, daysList } from '@/lib/constants'
import {
    Select,
    SelectTrigger,
    SelectValue,
    SelectContent,
    SelectItem,
} from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'

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

export default function TrainerLeavesPage() {
    const [leaves, setLeaves] = useState<TrainerLeave[]>([])
    const [trainers, setTrainers] = useState<Trainer[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [formLoading, setFormLoading] = useState(false)
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
        formState: { errors },
    } = useForm()

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
        setValue('date', leave.date)
        setValue('reason', leave.reason)
    }

    const confirmDelete = (leave: TrainerLeave) => {
        setLeaveToDelete(leave)
        setDeleteDialogOpen(true)
    }

    const handleDelete = async () => {
        if (!leaveToDelete) return
        try {
            await axios.delete(`/api/trainer-leaves/${leaveToDelete.id}`)
            toast.success('Leave deleted')
            fetchLeaves()
        } catch {
            toast.error('Failed to delete leave')
        } finally {
            setDeleteDialogOpen(false)
            setLeaveToDelete(null)
        }
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)
        try {
            if (selectedLeave) {
                await axios.put(`/api/trainer-leaves/${selectedLeave.id}`, data)
                toast.success('Leave updated')
            } else {
                await axios.post('/api/trainer-leaves', data)
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

            {loading ? (
                <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
                    {Array.from({ length: 6 }).map((_, i) => (
                        <Skeleton key={i} className="h-24 w-full rounded-lg" />
                    ))}
                </div>
            ) : (
                <DataTable
                    columns={columns({ openEditDialog, confirmDelete })}
                    data={leaves}
                    filterField="trainer.name"
                />
            )}

            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedLeave ? 'Edit Leave' : 'Add Leave'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    <Select
                        value={selectedLeave?.trainerId}
                        onValueChange={(val) => setValue('trainerId', val)}
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

                    <Input
                        type="date"
                        {...register('date', { required: true })}
                    />
                    {errors.date && (
                        <p className="text-red-600 text-sm">Date is required</p>
                    )}

                    <Textarea
                        placeholder="Reason (optional)"
                        {...register('reason')}
                    />
                </div>
            </Dialog>

            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Leave"
                onSubmit={handleDelete}
                buttonLoading={formLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="text-red-600 font-semibold">
                        {`${leaveToDelete?.trainer.name}'s leave`}
                    </span>
                    ?
                </p>
            </Dialog>
        </div>
    )
}
