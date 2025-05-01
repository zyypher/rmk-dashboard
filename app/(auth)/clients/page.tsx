'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { useForm } from 'react-hook-form'
import { Plus } from 'lucide-react'
import * as yup from 'yup'
import { yupResolver } from '@hookform/resolvers/yup'
import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/clients/columns'
import { Client } from '@/types/client'
import { FloatingLabelInput } from '@/components/ui/FloatingLabelInput'

const clientSchema = yup.object({
    name: yup.string().required('Name is required'),
    phone: yup
        .string()
        .required('Phone is required')
        .matches(
            /^(\+?\d{1,3}[- ]?)?\d{10}$/,
            'Invalid phone number (must be 10 digits or include country code)',
        ),
    email: yup.string().email('Invalid email').optional(),
    company: yup.string().optional(),
})

export default function ClientsPage() {
    const [clients, setClients] = useState<Client[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [formLoading, setFormLoading] = useState(false)
    const [selectedClient, setSelectedClient] = useState<Client | null>(null)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [clientToDelete, setClientToDelete] = useState<Client | null>(null)
    const [deleteLoading, setDeleteLoading] = useState(false)

    const {
        register,
        handleSubmit,
        reset,
        setValue,
        watch,
        formState: { errors },
    } = useForm({
        resolver: yupResolver(clientSchema),
        defaultValues: {
            name: '',
            phone: '',
            email: '',
            company: '',
        },
    })

    const fetchClients = async () => {
        setLoading(true)
        try {
            const res = await axios.get('/api/clients')
            setClients(res.data)
        } catch {
            toast.error('Failed to fetch clients')
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        fetchClients()
    }, [])

    const openEditDialog = (client: Client) => {
        setSelectedClient(client)
        setDialogOpen(true)
        setValue('name', client.name)
        setValue('email', client.email ?? '')
        setValue('phone', client.phone)
        setValue('company', client.company ?? '')
    }

    const handleAddOrEdit = async (data: any) => {
        setFormLoading(true)

        try {
            if (selectedClient) {
                await axios.put(`/api/clients/${selectedClient.id}`, data)
                toast.success('Client updated')
            } else {
                await axios.post('/api/clients', data)
                toast.success('Client added')
            }
            fetchClients()
            setDialogOpen(false)
        } catch {
            toast.error('Failed to submit')
        } finally {
            setFormLoading(false)
        }
    }

    const confirmDelete = (client: Client) => {
        setClientToDelete(client)
        setDeleteDialogOpen(true)
    }

    const handleDelete = async () => {
        if (!clientToDelete) return
        setDeleteLoading(true)

        try {
            await axios.delete(`/api/clients/${clientToDelete.id}`)
            toast.success('Client deleted successfully')
            fetchClients()
        } catch {
            toast.error('Failed to delete client')
        } finally {
            setDeleteLoading(false)
            setDeleteDialogOpen(false)
            setClientToDelete(null)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Clients" />
            <div className="flex justify-end">
                <Button
                    onClick={() => {
                        reset()
                        setSelectedClient(null)
                        setDialogOpen(true)
                    }}
                >
                    <Plus className="mr-2 h-4 w-4" />
                    Add Client
                </Button>
            </div>

            <DataTable
                columns={columns({ openEditDialog, confirmDelete })}
                data={clients}
                filterField="name"
                loading={loading}
            />

            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title={selectedClient ? 'Edit Client' : 'Add Client'}
                onSubmit={handleSubmit(handleAddOrEdit)}
                buttonLoading={formLoading}
            >
                <div className="space-y-4">
                    <FloatingLabelInput
                        label="Name"
                        name="name"
                        value={watch('name')}
                        onChange={(val) =>
                            setValue('name', val, { shouldValidate: true })
                        }
                        error={errors.name?.message}
                    />

                    <FloatingLabelInput
                        label="Phone"
                        name="phone"
                        value={watch('phone')}
                        onChange={(val) =>
                            setValue('phone', val, { shouldValidate: true })
                        }
                        error={errors.phone?.message}
                    />

                    <FloatingLabelInput
                        label="Email (optional)"
                        name="email"
                        value={watch('email')}
                        onChange={(val) => setValue('email', val)}
                        error={errors.email?.message}
                    />

                    <FloatingLabelInput
                        label="Company (optional)"
                        name="company"
                        value={watch('company')}
                        onChange={(val) => setValue('company', val)}
                        error={errors.company?.message}
                    />
                </div>
            </Dialog>

            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Delete Client"
                onSubmit={handleDelete}
                buttonLoading={deleteLoading}
            >
                <p className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="text-red-600 font-semibold">
                        {clientToDelete?.name}
                    </span>
                    ?
                </p>
            </Dialog>
        </div>
    )
}
