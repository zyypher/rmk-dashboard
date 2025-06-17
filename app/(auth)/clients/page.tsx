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
import { useUserRole } from '@/hooks/useUserRole'
import debounce from 'lodash/debounce'
import { Input } from '@/components/ui/input'
import * as XLSX from 'xlsx'

interface ImportedClient {
    name: string
    phone: string
    landline?: string
    email: string
    contactPersonName?: string
    contactPersonPosition?: string
    tradeLicenseNumber?: string
}

const clientSchema = yup.object({
    name: yup.string().required('Name is required'),
    phone: yup
        .string()
        .required('Phone is required')
        .matches(
            /^(\+?\d{1,3}[- ]?)?\d{10}$/,
            'Invalid phone number (must be 10 digits or include country code)',
        ),
    email: yup.string().email('Invalid email').required('Email is required'),
    landline: yup.string().optional(),
    contactPersonName: yup.string().optional(),
    contactPersonPosition: yup.string().optional(),
    tradeLicenseNumber: yup.string().optional(),
})

export default function ClientsPage() {
    const [clients, setClients] = useState<Client[]>([])
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [formLoading, setFormLoading] = useState(false)
    const [importing, setImporting] = useState(false)
    const [selectedClient, setSelectedClient] = useState<Client | null>(null)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [clientToDelete, setClientToDelete] = useState<Client | null>(null)
    const [deleteLoading, setDeleteLoading] = useState(false)
    const [search, setSearch] = useState('')
    const [currentPage, setCurrentPage] = useState(1)
    const [totalPages, setTotalPages] = useState(1)

    const role = useUserRole()

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
            landline: '',
            email: '',
            contactPersonName: '',
            contactPersonPosition: '',
            tradeLicenseNumber: '',
        },
    })

    const debouncedSearch = debounce(async (query: string) => {
        try {
            setLoading(true)
            const res = await axios.get('/api/clients/search', {
                params: { q: query },
            })
            setClients(res.data)
        } catch {
            toast.error('Failed to search clients')
        } finally {
            setLoading(false)
        }
    }, 500)

    const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const val = e.target.value
        setSearch(val)
        debouncedSearch(val)
    }

    const fetchClients = async (page = 1, pageSize = 10) => {
        setLoading(true)
        try {
            const res = await axios.get('/api/clients', {
                params: { page, pageSize, paginated: true },
            })
            setClients(res.data.clients)
            setTotalPages(res.data.totalPages)
        } catch {
            toast.error('Failed to fetch clients')
        } finally {
            setLoading(false)
        }
    }

    const handlePageChange = (page: number) => {
        setCurrentPage(page)
    }

    useEffect(() => {
        const delayDebounce = setTimeout(() => {
            if (search.trim()) {
                axios
                    .get('/api/clients/search', {
                        params: { q: search.trim() },
                    })
                    .then((res) => setClients(res.data))
                    .catch(() => toast.error('Failed to search clients'))
                    .finally(() => setLoading(false))
            } else {
                fetchClients()
            }
        }, 500)

        return () => clearTimeout(delayDebounce)
    }, [search])

    const openEditDialog = (client: Client) => {
        setSelectedClient(client)
        setDialogOpen(true)
        setValue('name', client.name)
        setValue('phone', client.phone)
        setValue('landline', client.landline ?? '')
        setValue('email', client.email ?? '')
        setValue('contactPersonName', client.contactPersonName ?? '')
        setValue('contactPersonPosition', client.contactPersonPosition ?? '')
        setValue('tradeLicenseNumber', client.tradeLicenseNumber ?? '')
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

    useEffect(() => {
        fetchClients(currentPage)
    }, [currentPage])

    const handleImportClients = async (
        e: React.ChangeEvent<HTMLInputElement>,
    ) => {
        const file = e.target.files?.[0]
        if (!file) return

        setImporting(true)
        const data = await file.arrayBuffer()
        const workbook = XLSX.read(data)
        const sheetName = workbook.SheetNames[0]
        const sheet = workbook.Sheets[sheetName]
        const rows = XLSX.utils.sheet_to_json(sheet)

        const missingFields: string[] = []
        const validClients: ImportedClient[] = []

        rows.forEach((row: any, index: number) => {
            const rowNumber = index + 2
            if (!row.name || !row.phone || !row.email) {
                missingFields.push(`Row ${rowNumber}`)
            } else {
                validClients.push({
                    name: String(row.name).trim(),
                    phone: String(row.phone).trim(),
                    email: String(row.email).trim(),
                    landline: row.landline ? String(row.landline).trim() : '',
                    contactPersonName: row.contactPersonName
                        ? String(row.contactPersonName).trim()
                        : '',
                    contactPersonPosition: row.contactPersonPosition
                        ? String(row.contactPersonPosition).trim()
                        : '',
                    tradeLicenseNumber: row.tradeLicenseNumber
                        ? String(row.tradeLicenseNumber).trim()
                        : '',
                })
            }
        })

        if (missingFields.length) {
            setImporting(false)
            toast.error(
                `Missing required fields in: ${missingFields.join(', ')}`,
                { duration: 6000 },
            )
            return
        }

        try {
            await axios.post('/api/clients/import', validClients)
            toast.success('Clients imported successfully')
            fetchClients()
        } catch (err: any) {
            toast.error(err?.response?.data?.error || 'Import failed')
        } finally {
            setImporting(false)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <PageHeading heading="Clients" />
            <div className="flex flex-wrap items-center justify-between gap-3">
                <Input
                    placeholder="Search by name, email, or phone"
                    value={search}
                    onChange={handleSearchChange}
                    className="w-full min-w-[16rem] sm:max-w-lg"
                />
                <div className="flex gap-2">
                    <Button
                        variant="outline"
                        onClick={() =>
                            window.open('/sample/clients.xlsx', '_blank')
                        }
                    >
                        Download Sample Excel
                    </Button>
                    <Button
                        variant="outline"
                        onClick={() =>
                            document.getElementById('import-clients')?.click()
                        }
                        disabled={importing}
                    >
                        {importing ? 'Importing...' : 'Import Clients'}
                    </Button>
                    <input
                        id="import-clients"
                        type="file"
                        accept=".xlsx,.xls"
                        className="hidden"
                        onChange={handleImportClients}
                    />
                    {(role === 'ADMIN' || role === 'EDITOR') && (
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
                    )}
                </div>
            </div>

            <DataTable
                columns={columns({ role, openEditDialog, confirmDelete })}
                data={clients}
                filterField="name"
                loading={loading}
                manualPagination
                currentPage={currentPage}
                totalPages={totalPages}
                onPageChange={handlePageChange}
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
                        label="Contact Person Name"
                        name="contactPersonName"
                        value={watch('contactPersonName')}
                        onChange={(val) => setValue('contactPersonName', val)}
                        error={errors.contactPersonName?.message}
                    />
                    <FloatingLabelInput
                        label="Contact Person Position"
                        name="contactPersonPosition"
                        value={watch('contactPersonPosition')}
                        onChange={(val) =>
                            setValue('contactPersonPosition', val)
                        }
                        error={errors.contactPersonPosition?.message}
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
                        label="Landline (optional)"
                        name="landline"
                        value={watch('landline')}
                        onChange={(val) => setValue('landline', val)}
                        error={errors.landline?.message}
                    />
                    <FloatingLabelInput
                        label="Email"
                        name="email"
                        value={watch('email')}
                        onChange={(val) => setValue('email', val)}
                        error={errors.email?.message}
                    />
                    <FloatingLabelInput
                        label="Trade License Number (optional)"
                        name="tradeLicenseNumber"
                        value={watch('tradeLicenseNumber')}
                        onChange={(val) => setValue('tradeLicenseNumber', val)}
                        error={errors.tradeLicenseNumber?.message}
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
                    <span className="font-semibold text-red-600">
                        {clientToDelete?.name}
                    </span>
                    ?
                </p>
            </Dialog>
        </div>
    )
}
