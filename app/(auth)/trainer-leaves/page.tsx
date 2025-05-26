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
import { useUserRole } from '@/hooks/useUserRole'
import { TrainerLeave } from '@/types/trainer-leave'

interface Trainer {
    id: string
    name: string
}

const leaveSchema = yup.object({
    trainerId: yup.string().required('Trainer is required'),
    startDate: yup.date().required('Start date is required'),
    endDate: yup
        .date()
        .required('End date is required')
        .min(yup.ref('startDate'), 'End date must be after start date'),
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
    const [currentPage, setCurrentPage] = useState(1)
    const [totalPages, setTotalPages] = useState(1)

    const role = useUserRole()

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
            startDate: undefined,
            endDate: undefined,
            reason: '',
        },
    })

    const fetchLeaves = async (page = 1, pageSize = 10) => {
        setLoading(true)
        try {
            const res = await axios.get('/api/trainer-leaves', {
                params: { page, pageSize },
            })
            setLeaves(res.data.leaves)
            setTotalPages(res.data.totalPages)
        } catch {
            toast.error('Failed to fetch trainer leaves')
        } finally {
            setLoading(false)
        }
    }

    const fetchTrainers = async () => {
        try {
            const res = await axios.get('/api/trainers')
            setTrainers(res.data.trainers)
        } catch {
            toast.error('Failed to fetch trainers')
        }
    }

    useEffect(() => {
        fetchLeaves(currentPage)
        fetchTrainers()
    }, [currentPage])

    const handlePageChange = (page: number) => {
        setCurrentPage(page)
    }

    const openEditDialog = (leave: TrainerLeave) => {
        setSelectedLeave(leave)
        setDialogOpen(true)
        setValue('trainerId', leave.trainerId)
        setValue('startDate', new Date(leave.startDate))
        setValue('endDate', new Date(leave.endDate))
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
            trainerId: data.trainerId,
            startDate: data.startDate.toISOString(),
            endDate: data.endDate.toISOString(),
            reason: data.reason,
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

            {(role === 'ADMIN' || role === 'EDITOR') && (
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
            )}

            <DataTable
                columns={columns({ role, openEditDialog, confirmDelete })}
                data={leaves}
                filterField="trainer.name"
                loading={loading}
                manualPagination
                currentPage={currentPage}
                totalPages={totalPages}
                onPageChange={handlePageChange}
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
                            <p className="text-sm text-red-600">
                                {errors.trainerId.message}
                            </p>
                        )}
                    </div>

                    {/* Start Date Picker */}
                    <div>
                        <label className="text-sm font-medium text-gray-700">
                            Start Date
                        </label>
                        <Controller
                            name="startDate"
                            control={control}
                            render={({ field }) => (
                                <DatePicker
                                    date={field.value}
                                    onChange={field.onChange}
                                />
                            )}
                        />
                        {errors.startDate && (
                            <p className="text-sm text-red-600">
                                {errors.startDate.message as string}
                            </p>
                        )}
                    </div>

                    {/* End Date Picker */}
                    <div>
                        <label className="text-sm font-medium text-gray-700">
                            End Date
                        </label>
                        <Controller
                            name="endDate"
                            control={control}
                            render={({ field }) => (
                                <DatePicker
                                    date={field.value}
                                    onChange={field.onChange}
                                />
                            )}
                        />
                        {errors.endDate && (
                            <p className="text-sm text-red-600">
                                {errors.endDate.message as string}
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
                    <span className="font-semibold text-red-600">
                        {`${leaveToDelete?.trainer.name}'s`} leave
                    </span>
                    ?
                </p>
            </Dialog>
        </div>
    )
}
