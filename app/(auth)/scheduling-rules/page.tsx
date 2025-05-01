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
import { columns } from '@/components/custom/table/scheduling-rules/columns'
import { MultiSelect, MultiSelectItem } from '@/components/ui/multi-select'
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group'
import {
    Select,
    SelectTrigger,
    SelectValue,
    SelectContent,
    SelectItem,
} from '@/components/ui/select'
import { daysList } from '@/lib/constants'
import { TrainerSchedulingRule } from '@/types/scheduling-rule'
import { FloatingLabelInput } from '@/components/ui/FloatingLabelInput'

interface Trainer {
    id: string
    name: string
}

const ruleSchema = yup.object({
    trainerId: yup.string().required('Trainer is required'),
    maxSessionsPerDay: yup
        .number()
        .required('Max sessions is required')
        .typeError('Max sessions must be a number')
        .min(1, 'Must be at least 1'),
    daysOff: yup.array().of(yup.string()).default([]),
    allowOverlap: yup
        .string()
        .oneOf(['yes', 'no'], 'Invalid overlap selection')
        .required('Overlap selection is required'),
})

export default function SchedulingRulesPage() {
    const [rules, setRules] = useState<TrainerSchedulingRule[]>([])
    const [trainers, setTrainers] = useState<Trainer[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [ruleToDelete, setRuleToDelete] =
        useState<TrainerSchedulingRule | null>(null)
    const [formLoading, setFormLoading] = useState(false)
    const [selectedRule, setSelectedRule] =
        useState<TrainerSchedulingRule | null>(null)
    const [deleteLoading, setDeleteLoading] = useState(false)
    const [constraintErrorModalOpen, setConstraintErrorModalOpen] =
        useState(false)
    const [constraintErrorMessage, setConstraintErrorMessage] = useState('')

    const {
        register,
        handleSubmit,
        setValue,
        control,
        reset,
        watch,
        formState: { errors },
    } = useForm({
        resolver: yupResolver(ruleSchema),
        defaultValues: {
            trainerId: '',
            maxSessionsPerDay: 1,
            daysOff: [],
            allowOverlap: 'no',
        },
    })

    const fetchRules = async () => {
        setLoading(true)
        try {
            const res = await axios.get('/api/scheduling-rules')
            setRules(res.data)
        } catch {
            toast.error('Failed to fetch scheduling rules')
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
        fetchRules()
        fetchTrainers()
    }, [])

    const openEditDialog = (rule: TrainerSchedulingRule) => {
        setSelectedRule(rule)
        setDialogOpen(true)
        setValue('trainerId', rule.trainerId)
        setValue('maxSessionsPerDay', rule.maxSessionsPerDay)
        setValue('daysOff', rule.daysOff)
        setValue('allowOverlap', rule.allowOverlap ? 'yes' : 'no')
    }

    const confirmDelete = (rule: TrainerSchedulingRule) => {
        setRuleToDelete(rule)
        setDeleteDialogOpen(true)
    }

    const handleDelete = async () => {
        if (!ruleToDelete) return
        setDeleteLoading(true)
        try {
            await axios.delete(`/api/scheduling-rules/${ruleToDelete.id}`)
            toast.success('Rule deleted successfully')
            fetchRules()
        } catch {
            toast.error('Failed to delete rule')
        } finally {
            setDeleteLoading(false)
            setDeleteDialogOpen(false)
            setRuleToDelete(null)
        }
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)
        const transformed = {
            ...data,
            allowOverlap: data.allowOverlap === 'yes',
        }
        try {
            if (selectedRule) {
                await axios.put(
                    `/api/scheduling-rules/${selectedRule.id}`,
                    transformed,
                )
                toast.success('Rule updated')
            } else {
                await axios.post('/api/scheduling-rules', transformed)
                toast.success('Rule added')
            }
            fetchRules()
            setDialogOpen(false)
        } catch (error: any) {
            setDialogOpen(false)
            if (
                error?.response?.data?.error?.includes('Unique constraint') ||
                error?.response?.status === 400
            ) {
                setConstraintErrorMessage(
                    'A scheduling rule already exists for this trainer. Please edit the existing rule instead.',
                )
                setConstraintErrorModalOpen(true)
            } else {
                toast.error('Failed to submit')
            }
        } finally {
            setFormLoading(false)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Trainer Scheduling Rules" />
            <div className="flex justify-end">
                <Button
                    onClick={() => {
                        reset()
                        setSelectedRule(null)
                        setDialogOpen(true)
                    }}
                >
                    <Plus className="mr-2 h-4 w-4" />
                    Add Rule
                </Button>
            </div>

            <DataTable
                columns={columns({ openEditDialog, confirmDelete })}
                data={rules}
                filterField="trainer.name"
                loading={loading}
            />

            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedRule ? 'Edit Rule' : 'Add Rule'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    {/* Trainer */}
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

                    {/* Max Sessions Per Day */}
                    <FloatingLabelInput
                        label="Max Sessions Per Day"
                        type="number"
                        name="maxSessionsPerDay"
                        value={String(watch('maxSessionsPerDay') ?? '')}
                        onChange={(val) =>
                            setValue('maxSessionsPerDay', Number(val), {
                                shouldValidate: true,
                            })
                        }
                        error={errors.maxSessionsPerDay?.message}
                    />

                    {/* Days Off */}
                    <div>
                        <label className="text-sm font-medium text-gray-700">
                            Days Off
                        </label>
                        <Controller
                            name="daysOff"
                            control={control}
                            render={({ field }) => (
                                <MultiSelect
                                    value={(field.value || []).filter(
                                        (v): v is string =>
                                            typeof v === 'string',
                                    )}
                                    onChange={(vals) => field.onChange(vals)}
                                >
                                    {daysList.map((day) => (
                                        <MultiSelectItem key={day} value={day}>
                                            {day}
                                        </MultiSelectItem>
                                    ))}
                                </MultiSelect>
                            )}
                        />
                        {errors.daysOff && (
                            <p className="text-red-600 text-sm">
                                {errors.daysOff.message as string}
                            </p>
                        )}
                    </div>

                    {/* Allow Overlap */}
                    <div>
                        <label className="text-sm font-medium text-gray-700">
                            Allow Overlap
                        </label>
                        <Controller
                            name="allowOverlap"
                            control={control}
                            render={({ field }) => (
                                <RadioGroup
                                    value={field.value}
                                    onValueChange={field.onChange}
                                >
                                    <div className="flex gap-4">
                                        <label className="flex items-center gap-2">
                                            <RadioGroupItem value="yes" /> Yes
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <RadioGroupItem value="no" /> No
                                        </label>
                                    </div>
                                </RadioGroup>
                            )}
                        />
                        {errors.allowOverlap && (
                            <p className="text-red-600 text-sm">
                                {errors.allowOverlap.message}
                            </p>
                        )}
                    </div>
                </div>
            </Dialog>

            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Rule"
                onSubmit={handleDelete}
                buttonLoading={deleteLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="text-red-600 font-semibold">
                        {ruleToDelete?.trainer.name}
                    </span>{' '}
                    rule?
                </p>
            </Dialog>
            <Dialog
                isOpen={constraintErrorModalOpen}
                onClose={() => setConstraintErrorModalOpen(false)}
                title="Cannot Add Rule"
                submitLabel="Close"
                onSubmit={() => setConstraintErrorModalOpen(false)}
            >
                <p className="text-sm text-gray-700">
                    {constraintErrorMessage}
                </p>
            </Dialog>
        </div>
    )
}
