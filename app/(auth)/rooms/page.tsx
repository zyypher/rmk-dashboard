'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { Button } from '@/components/ui/button'
import { Plus } from 'lucide-react'
import { Dialog } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import PageHeading from '@/components/layout/page-heading'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/rooms/columns'
import {
    Select,
    SelectTrigger,
    SelectValue,
    SelectContent,
    SelectItem,
} from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { Skeleton } from '@/components/ui/skeleton'
import { useForm, Controller } from 'react-hook-form'
import { Room } from '@/types/room'

interface Location {
    id: string
    name: string
}

export default function RoomsPage() {
    const [rooms, setRooms] = useState<Room[]>([])
    const [locations, setLocations] = useState<Location[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [selectedRoom, setSelectedRoom] = useState<Room | null>(null)
    const [formLoading, setFormLoading] = useState(false)
    const {
        register,
        handleSubmit,
        reset,
        setValue,
        watch,
        trigger,
        control,
        formState: { errors },
    } = useForm()

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
        setValue('type', room.type)
        setValue('capacity', room.capacity)
        setValue('notes', room.notes)
        setValue('locationId', room.locationId)
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)
        try {
            if (selectedRoom) {
                await axios.put(`/api/rooms/${selectedRoom.id}`, data)
                toast.success('Room updated successfully')
            } else {
                await axios.post('/api/rooms', data)
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

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Rooms" />
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
            {loading ? (
                <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
                    {Array.from({ length: 6 }).map((_, i) => (
                        <Skeleton key={i} className="h-24 w-full rounded-lg" />
                    ))}
                </div>
            ) : (
                <DataTable
                    columns={columns({ openEditDialog })}
                    data={rooms}
                    filterField="name"
                />
            )}

            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedRoom ? 'Edit Room' : 'Add Room'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    <div>
                        <Input
                            placeholder="Room Name"
                            {...register('name', {
                                required: 'Room name is required',
                            })}
                        />
                        {errors.name && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.name.message as string}
                            </p>
                        )}
                    </div>

                    <div>
                        <Controller
                            name="type"
                            control={control}
                            rules={{ required: 'Room type is required' }}
                            render={({ field }) => (
                                <Select
                                    value={field.value}
                                    onValueChange={(val) => field.onChange(val)}
                                >
                                    <SelectTrigger>
                                        <SelectValue placeholder="Select Room Type" />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="ONLINE">
                                            Online
                                        </SelectItem>
                                        <SelectItem value="OFFLINE">
                                            Offline
                                        </SelectItem>
                                    </SelectContent>
                                </Select>
                            )}
                        />
                        {errors.type && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.type.message as string}
                            </p>
                        )}
                    </div>

                    <div>
                        <Input
                            type="number"
                            step="1"
                            placeholder="Capacity"
                            {...register('capacity', {
                                required: 'Capacity is required',
                                validate: (value) =>
                                    Number.isInteger(Number(value)) ||
                                    'Only whole numbers allowed',
                            })}
                            onKeyDown={(e) => {
                                if (e.key === '.' || e.key === 'e') {
                                    e.preventDefault()
                                }
                            }}
                        />

                        {errors.capacity && (
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.capacity.message as string}
                            </p>
                        )}
                    </div>

                    <div>
                        <Textarea placeholder="Notes" {...register('notes')} />
                    </div>

                    <div>
                        <Controller
                            name="locationId"
                            control={control}
                            rules={{ required: 'Branch is required' }}
                            render={({ field }) => (
                                <Select
                                    value={field.value}
                                    onValueChange={(val) => field.onChange(val)}
                                >
                                    <SelectTrigger>
                                        <SelectValue placeholder="Select Branch" />
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
                            <p className="text-red-600 mt-1 text-sm">
                                {errors.locationId.message as string}
                            </p>
                        )}
                    </div>
                </div>
            </Dialog>
        </div>
    )
}
