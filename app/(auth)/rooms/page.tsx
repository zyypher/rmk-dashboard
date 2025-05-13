'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { useForm, Controller } from 'react-hook-form'
import { yupResolver } from '@hookform/resolvers/yup'
import * as yup from 'yup'
import { Plus } from 'lucide-react'
import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'
import { Textarea } from '@/components/ui/textarea'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/rooms/columns'
import { Room } from '@/types/room'
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select'
import { FloatingLabelInput } from '@/components/ui/FloatingLabelInput'
import { useUserRole } from '@/hooks/useUserRole'

const MAXIMUM_ROOM_CAPACITY = 30

interface Location {
    id: string
    name: string
}

// ✅ Yup schema with max capacity
const roomSchema = yup.object({
    name: yup.string().required('Room number is required'),
    capacity: yup
        .number()
        .typeError('Capacity must be a number')
        .required('Capacity is required')
        .integer('Only whole numbers allowed')
        .max(
            MAXIMUM_ROOM_CAPACITY,
            `Maximum allowed is ${MAXIMUM_ROOM_CAPACITY}`,
        ),
    locationId: yup.string().required('Location is required'),
    notes: yup.string().optional(),
})

export default function RoomsPage() {
    const [rooms, setRooms] = useState<Room[]>([])
    const [locations, setLocations] = useState<Location[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [selectedRoom, setSelectedRoom] = useState<Room | null>(null)
    const [roomToDelete, setRoomToDelete] = useState<Room | null>(null)
    const [formLoading, setFormLoading] = useState(false)
    const [deleteLoading, setDeleteLoading] = useState(false)
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
        resolver: yupResolver(roomSchema),
    })

    const fetchRooms = async () => {
        setLoading(true)
        try {
            const res = await axios.get('/api/rooms')
            setRooms(res.data)
        } catch {
            toast.error('Failed to fetch rooms')
        } finally {
            setLoading(false)
        }
    }

    const fetchLocations = async () => {
        try {
            const res = await axios.get('/api/locations')
            setLocations(res.data)
        } catch {
            toast.error('Failed to fetch locations')
        }
    }

    useEffect(() => {
        fetchRooms()
        fetchLocations()
    }, [])

    const openEditDialog = (room: Room) => {
        setSelectedRoom(room)
        setDialogOpen(true)
        setValue('name', room.name)
        setValue('capacity', room.capacity ?? 0)
        setValue('notes', room.notes)
        setValue('locationId', room.locationId)
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)
        const payload = {
            ...data,
            capacity: parseInt(data.capacity, 10),
        }
        try {
            if (selectedRoom) {
                await axios.put(`/api/rooms/${selectedRoom.id}`, payload)
                toast.success('Room updated successfully')
            } else {
                await axios.post('/api/rooms', payload)
                toast.success('Room added successfully')
            }
            fetchRooms()
            setDialogOpen(false)
        } catch {
            toast.error('Failed to submit form')
        } finally {
            setFormLoading(false)
        }
    }

    const confirmDelete = (room: Room) => {
        setRoomToDelete(room)
        setDeleteDialogOpen(true)
    }

    const handleDelete = async () => {
        if (!roomToDelete) return
        setDeleteLoading(true)
        try {
            await axios.delete(`/api/rooms/${roomToDelete.id}`)
            toast.success('Room deleted successfully')
            fetchRooms()
        } catch {
            toast.error('Failed to delete room')
        } finally {
            setDeleteDialogOpen(false)
            setRoomToDelete(null)
            setDeleteLoading(false)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Rooms" />

            {(role === 'ADMIN' || role === 'EDITOR') && (
                <div className="flex justify-end">
                    <Button
                        onClick={() => {
                            reset()
                            setSelectedRoom(null)
                            setDialogOpen(true)
                        }}
                    >
                        <Plus className="mr-2 h-4 w-4" />
                        Add Room
                    </Button>
                </div>
            )}

            <DataTable
                columns={columns({ role, openEditDialog, confirmDelete })}
                data={rooms}
                filterField="name"
                loading={loading}
            />

            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedRoom ? 'Edit Room' : 'Add Room'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    <div className="space-y-4">
                        <label className="text-sm font-medium text-gray-700">
                            Branch
                        </label>
                        <Controller
                            name="locationId"
                            control={control}
                            render={({ field }) => (
                                <Select
                                    value={field.value}
                                    onValueChange={field.onChange}
                                >
                                    <SelectTrigger>
                                        <SelectValue placeholder="Select Location" />
                                    </SelectTrigger>
                                    <SelectContent>
                                        {locations.map((loc) => (
                                            <SelectItem
                                                key={loc.id}
                                                value={loc.id}
                                            >
                                                {loc.name}
                                            </SelectItem>
                                        ))}
                                    </SelectContent>
                                </Select>
                            )}
                        />
                        {errors.locationId && (
                            <p className="text-sm text-red-600">
                                {errors.locationId.message as string}
                            </p>
                        )}

                        <FloatingLabelInput
                            label="Room Number"
                            value={watch('name')}
                            onChange={(val) =>
                                setValue('name', val, { shouldValidate: true })
                            }
                            name="name"
                            error={errors.name?.message as string}
                        />

                        <FloatingLabelInput
                            label="Room Capacity"
                            type="number"
                            value={String(watch('capacity') ?? '')}
                            onChange={(val) =>
                                setValue('capacity', parseInt(val || '0', 10), {
                                    shouldValidate: true,
                                })
                            }
                            name="capacity"
                            onKeyDown={(
                                e: React.KeyboardEvent<HTMLInputElement>,
                            ) => {
                                if (e.key === '.' || e.key === 'e')
                                    e.preventDefault()
                            }}
                            error={errors.capacity?.message as string}
                        />
                    </div>

                    <Textarea placeholder="Notes" {...register('notes')} />
                </div>
            </Dialog>

            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Room"
                onSubmit={handleDelete}
                buttonLoading={deleteLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="font-semibold text-red-600">
                        {roomToDelete?.name}
                    </span>
                    ?
                </p>
            </Dialog>
        </div>
    )
}
