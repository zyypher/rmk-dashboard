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
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/locations/columns'
import { Location } from '@/types/location'
import * as yup from 'yup'
import { yupResolver } from '@hookform/resolvers/yup'
import { Checkbox } from '@/components/ui/checkbox'

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
    const [deleteLoading, setDeleteLoading] = useState(false)
    const [dependencyErrorModal, setDependencyErrorModal] = useState(false)
    const [dependencyInfo, setDependencyInfo] = useState<{
        rooms: number
    } | null>(null)

    const locationSchema = yup.object({
        name: yup.string().required('Branch name is required'),
        address: yup.string().required('Address is required'),
        isOnline: yup.boolean().required('Please specify online status'),
    })

    const {
        register,
        handleSubmit,
        reset,
        setValue,
        watch,
        trigger,
        formState: { errors },
    } = useForm({
        resolver: yupResolver(locationSchema),
        defaultValues: {
            isOnline: false,
        },
    })

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
        setValue('isOnline', location.isOnline)
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)
        try {
            if (selectedLocation) {
                await axios.put(`/api/locations/${selectedLocation.id}`, data)
                toast.success('Location updated')
            } else {
                await axios.post('/api/locations', data)
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
        setDeleteLoading(true)

        try {
            await axios.delete(`/api/locations/${locationToDelete.id}`)
            toast.success('Location deleted successfully')
            fetchLocations()
        } catch (err: any) {
            if (err?.response?.status === 409 && err.response.data?.rooms) {
                setDependencyInfo({ rooms: err.response.data.rooms })
                setDependencyErrorModal(true)
            } else {
                toast.error('Failed to delete location')
            }
        } finally {
            setDeleteDialogOpen(false)
            setLocationToDelete(null)
            setDeleteLoading(false)
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

            <DataTable
                columns={columns({ openEditDialog, confirmDelete })}
                data={locations}
                filterField="name"
                loading={loading}
            />

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
                    <div className="flex items-center gap-2">
                        <Checkbox
                            id="isOnline"
                            checked={watch('isOnline') === true}
                            onCheckedChange={(checked) =>
                                setValue('isOnline', !!checked, {
                                    shouldValidate: true,
                                })
                            }
                            className="h-3 w-3 data-[state=checked]:bg-primary data-[state=checked]:text-white"
                        />
                        <label
                            htmlFor="isOnline"
                            className="text-muted-foreground text-sm"
                        >
                            Online Location
                        </label>
                    </div>
                </div>
            </Dialog>
            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Location"
                onSubmit={handleDelete}
                buttonLoading={deleteLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="text-red-600 font-semibold">
                        {locationToDelete?.name}
                    </span>
                    ?
                </p>
            </Dialog>
            <Dialog
                isOpen={dependencyErrorModal}
                onClose={() => {
                    setDependencyErrorModal(false)
                    setLocationToDelete(null)
                }}
                title="Cannot Delete Location"
                submitLabel="Close"
            >
                <p className="text-sm text-gray-700">
                    This location cannot be deleted because it is linked to the
                    following:
                </p>
                <ul className="text-red-600 mt-4 list-disc space-y-1 pl-5 text-sm">
                    {dependencyInfo && dependencyInfo.rooms && (
                        <li>
                            {dependencyInfo.rooms} room(s) assigned to this
                            location
                        </li>
                    )}
                </ul>
                <p className="mt-4 text-sm text-gray-500">
                    Please delete or reassign those rooms before deleting this
                    location.
                </p>
            </Dialog>
        </div>
    )
}
