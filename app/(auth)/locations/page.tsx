'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import { useForm, Controller } from 'react-hook-form'
import { Plus } from 'lucide-react'
import toast from 'react-hot-toast'
import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/locations/columns'
import { Location } from '@/types/location'
import * as yup from 'yup'
import { yupResolver } from '@hookform/resolvers/yup'
import { FloatingLabelInput } from '@/components/ui/FloatingLabelInput'
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select'
import { useUserRole } from '@/hooks/useUserRole'
import debounce from 'lodash/debounce'
import { Input } from '@/components/ui/input'

const EMIRATES = [
    'Abu Dhabi',
    'Dubai',
    'Sharjah',
    'Ajman',
    'Fujairah',
    'Ras Al Khaimah',
    'Umm Al Quwain',
    'Al Ain',
]

const LOCATION_TYPES = ['RMK', 'Client', 'Rented']

const locationSchema = yup.object({
    name: yup.string().required('Location name is required'),
    emirate: yup.string().required('Emirate is required'),
    deliveryApproach: yup.string().required(),
    zoomLink: yup.string().when('deliveryApproach', {
        is: 'Online',
        then: (schema) =>
            schema
                .required('Zoom link is required')
                .url('Zoom link must be a valid URL'),
        otherwise: (schema) => schema.notRequired(),
    }),
    locationType: yup.string().when('deliveryApproach', {
        is: 'Offline',
        then: (schema) => schema.required('Please select location type'),
        otherwise: (schema) => schema.notRequired(),
    }),
})

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
    const [search, setSearch] = useState('')

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
        resolver: yupResolver(locationSchema),
        defaultValues: {
            deliveryApproach: '',
        },
    })

    const deliveryApproach = watch('deliveryApproach')

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
        setValue('emirate', location.emirate)
        setValue('zoomLink', location.zoomLink || '')
        setValue('locationType', location.locationType || '')
        setValue('deliveryApproach', location.deliveryApproach || '')
    }

    const debouncedSearch = debounce(async (query: string) => {
        try {
            setLoading(true)
            const res = await axios.get('/api/locations/search', {
                params: { q: query },
            })
            setLocations(res.data)
        } catch {
            toast.error('Failed to search locations')
        } finally {
            setLoading(false)
        }
    }, 500)

    const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const val = e.target.value
        setSearch(val)
        debouncedSearch(val)
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
        } catch {
            toast.error('Failed to delete location')
        } finally {
            setDeleteDialogOpen(false)
            setLocationToDelete(null)
            setDeleteLoading(false)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Locations" />

            <div className="flex flex-wrap items-center justify-between gap-3">
                <Input
                    placeholder="Search by location name or emirate"
                    value={search}
                    onChange={handleSearchChange}
                    className="w-full min-w-[18rem] sm:max-w-lg"
                />
                {(role === 'ADMIN' || role === 'EDITOR') && (
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
                )}
            </div>

            <DataTable
                columns={columns({ role, openEditDialog, confirmDelete })}
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
                    <FloatingLabelInput
                        label="Location Name"
                        value={watch('name')}
                        onChange={(val) =>
                            setValue('name', val, { shouldValidate: true })
                        }
                        name="name"
                        error={errors.name?.message as string}
                    />

                    <Controller
                        name="emirate"
                        control={control}
                        render={({ field }) => (
                            <Select
                                value={field.value}
                                onValueChange={field.onChange}
                            >
                                <SelectTrigger>
                                    <SelectValue placeholder="Select Emirate" />
                                </SelectTrigger>
                                <SelectContent>
                                    {EMIRATES.map((e) => (
                                        <SelectItem key={e} value={e}>
                                            {e}
                                        </SelectItem>
                                    ))}
                                </SelectContent>
                            </Select>
                        )}
                    />
                    {errors.emirate && (
                        <p className="text-sm text-red-600">
                            {errors.emirate.message as string}
                        </p>
                    )}

                    <Controller
                        name="deliveryApproach"
                        control={control}
                        render={({ field }) => (
                            <Select
                                value={field.value}
                                onValueChange={field.onChange}
                            >
                                <SelectTrigger>
                                    <SelectValue placeholder="Select Delivery Approach" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="Online">
                                        Online
                                    </SelectItem>
                                    <SelectItem value="Offline">
                                        Offline
                                    </SelectItem>
                                </SelectContent>
                            </Select>
                        )}
                    />

                    {deliveryApproach === 'Online' ? (
                        <FloatingLabelInput
                            label="Zoom Link"
                            value={watch('zoomLink')}
                            onChange={(val) =>
                                setValue('zoomLink', val, {
                                    shouldValidate: true,
                                })
                            }
                            name="zoomLink"
                            error={errors.zoomLink?.message as string}
                        />
                    ) : (
                        <Controller
                            name="locationType"
                            control={control}
                            render={({ field }) => (
                                <Select
                                    value={field.value}
                                    onValueChange={field.onChange}
                                >
                                    <SelectTrigger>
                                        <SelectValue placeholder="Select Location Type" />
                                    </SelectTrigger>
                                    <SelectContent>
                                        {LOCATION_TYPES.map((type) => (
                                            <SelectItem key={type} value={type}>
                                                {type} Location
                                            </SelectItem>
                                        ))}
                                    </SelectContent>
                                </Select>
                            )}
                        />
                    )}
                    {errors.locationType && (
                        <p className="text-sm text-red-600">
                            {errors.locationType.message as string}
                        </p>
                    )}
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
                    <span className="font-semibold text-red-600">
                        {locationToDelete?.name}
                    </span>
                    ?
                </p>
            </Dialog>
        </div>
    )
}
