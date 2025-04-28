'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import { useForm } from 'react-hook-form'
import { Plus } from 'lucide-react'
import toast from 'react-hot-toast'

import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import {
    Select,
    SelectTrigger,
    SelectValue,
    SelectContent,
    SelectItem,
} from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/locations/columns'
import { Location } from '@/types/location'

export default function LocationsPage() {
    const [locations, setLocations] = useState<Location[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [formLoading, setFormLoading] = useState(false)
    const [selectedLocation, setSelectedLocation] = useState<Location | null>(
        null,
    )
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [locationToDelete, setLocationToDelete] = useState<Location | null>(
        null,
    )

    const {
        register,
        handleSubmit,
        reset,
        setValue,
        watch,
        formState: { errors },
    } = useForm()

    const fetchLocations = async () => {
        setLoading(true)
        try {
            const res = await axios.get('/api/locations')
            setLocations(res.data)
        } catch {
            toast.error('Failed to fetch locations')
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        fetchLocations()
    }, [])

    const openEditDialog = (location: Location) => {
        setSelectedLocation(location)
        setDialogOpen(true)
        setValue('name', location.name)
        setValue('address', location.address)
        setValue('type', location.type)
        setValue('capacity', location.capacity)
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)
        try {
            const payload = {
                ...data,
                capacity: parseInt(data.capacity, 10), // 👈 ensure it's a number
              }
            if (selectedLocation) {
                await axios.put(`/api/locations/${selectedLocation.id}`, payload)
                toast.success('Location updated')
            } else {
                await axios.post('/api/locations', payload)
                toast.success('Location added')
            }
            fetchLocations()
            setDialogOpen(false)
        } catch {
            toast.error('Failed to submit')
        } finally {
            setFormLoading(false)
        }
    }

    const confirmDelete = (location: Location) => {
        setLocationToDelete(location)
        setDeleteDialogOpen(true)
    }

    const handleDelete = async () => {
        if (!locationToDelete) return

        try {
            await axios.delete(`/api/locations/${locationToDelete.id}`)
            toast.success('Location deleted successfully')
            fetchLocations()
        } catch {
            toast.error('Failed to delete location')
        } finally {
            setDeleteDialogOpen(false)
            setLocationToDelete(null)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Locations" />
            <div className="flex justify-end">
                <Button
                    onClick={() => {
                        reset()
                        setSelectedLocation(null)
                        setDialogOpen(true)
                    }}
                >
                    <Plus className="mr-2 h-4 w-4" />
                    Add Location
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
                    data={locations}
                    filterField="name"
                />
            )}

            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedLocation ? 'Edit Location' : 'Add Location'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    <Input
                        placeholder="Branch Name"
                        {...register('name', {
                            required: 'Branch name is required',
                        })}
                    />
                    {errors.name && (
                        <p className="text-red-600 text-sm">
                            {errors.name.message as string}
                        </p>
                    )}

                    <Input
                        placeholder="Full Address"
                        {...register('address', {
                            required: 'Address is required',
                        })}
                    />
                    {errors.address && (
                        <p className="text-red-600 text-sm">
                            {errors.address.message as string}
                        </p>
                    )}

                    <Select
                        value={watch('type')}
                        onValueChange={(val) =>
                            setValue('type', val, { shouldValidate: true })
                        }
                    >
                        <SelectTrigger>
                            <SelectValue placeholder="Select Type" />
                        </SelectTrigger>
                        <SelectContent>
                            <SelectItem value="ONLINE">Online</SelectItem>
                            <SelectItem value="OFFLINE">Offline</SelectItem>
                        </SelectContent>
                    </Select>
                    {errors.type && (
                        <p className="text-red-600 text-sm">Type is required</p>
                    )}

                    <Input
                        type="number"
                        placeholder="Capacity"
                        {...register('capacity', {
                            required: 'Capacity is required',
                        })}
                    />
                    {errors.capacity && (
                        <p className="text-red-600 text-sm">
                            {errors.capacity.message as string}
                        </p>
                    )}
                </div>
            </Dialog>
            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Location"
                onSubmit={handleDelete}
                buttonLoading={formLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="text-red-600 font-semibold">
                        {locationToDelete?.name}
                    </span>
                    ?
                </p>
            </Dialog>
        </div>
    )
}
