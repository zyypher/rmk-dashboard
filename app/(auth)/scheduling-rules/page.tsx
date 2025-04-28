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
import { DataTable } from '@/components/custom/table/data-table'
import { Skeleton } from '@/components/ui/skeleton'
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
import { Day, daysList } from '@/lib/constants'
import { TrainerSchedulingRule } from '@/types/scheduling-rule'

interface Trainer {
    id: string
    name: string
}

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

    const {
        register,
        handleSubmit,
        setValue,
        control,
        reset,
        formState: { errors },
    } = useForm()

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

        try {
            await axios.delete(`/api/scheduling-rules/${ruleToDelete.id}`)
            toast.success('Rule deleted successfully')
            fetchRules()
        } catch {
            toast.error('Failed to delete rule')
        } finally {
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
        } catch {
            toast.error('Failed to submit')
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

            {loading ? (
                <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
                    {Array.from({ length: 6 }).map((_, i) => (
                        <Skeleton key={i} className="h-24 w-full rounded-lg" />
                    ))}
                </div>
            ) : (
                <DataTable
                    columns={columns({ openEditDialog, confirmDelete })}
                    data={rules}
                    filterField="trainer.name"
                />
            )}

            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedRule ? 'Edit Rule' : 'Add Rule'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    <Controller
                        name="trainerId"
                        control={control}
                        rules={{ required: 'Trainer is required' }}
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
                            {errors.trainerId.message as string}
                        </p>
                    )}

                    <Input
                        type="number"
                        placeholder="Max Sessions Per Day"
                        {...register('maxSessionsPerDay', {
                            required: 'Max sessions is required',
                        })}
                    />
                    {errors.maxSessionsPerDay && (
                        <p className="text-red-600 text-sm">
                            {errors.maxSessionsPerDay.message as string}
                        </p>
                    )}

                    <MultiSelect
                        onChange={(vals) => setValue('daysOff', vals)}
                        defaultValue={selectedRule?.daysOff || []}
                    >
                        {daysList.map((day) => (
                            <MultiSelectItem key={day} value={day}>
                                {day}
                            </MultiSelectItem>
                        ))}
                    </MultiSelect>

                    <RadioGroup defaultValue="no" {...register('allowOverlap')}>
                        <div className="flex gap-4">
                            <label className="flex items-center gap-2">
                                <RadioGroupItem value="yes" /> Yes
                            </label>
                            <label className="flex items-center gap-2">
                                <RadioGroupItem value="no" /> No
                            </label>
                        </div>
                    </RadioGroup>
                </div>
            </Dialog>

            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Rule"
                onSubmit={handleDelete}
                buttonLoading={formLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="text-red-600 font-semibold">
                        {ruleToDelete?.trainer.name}
                    </span>{' '}
                    rule?
                </p>
            </Dialog>
        </div>
    )
}
