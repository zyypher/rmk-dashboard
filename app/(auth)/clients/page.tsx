'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { useForm } from 'react-hook-form'
import { Plus } from 'lucide-react'

import PageHeading from '@/components/layout/page-heading'
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Skeleton } from '@/components/ui/skeleton'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/clients/columns'
import { Client } from '@/types/client'

export default function ClientsPage() {
  const [clients, setClients] = useState<Client[]>([])
  const [loading, setLoading] = useState(true)
  const [dialogOpen, setDialogOpen] = useState(false)
  const [formLoading, setFormLoading] = useState(false)
  const [selectedClient, setSelectedClient] = useState<Client | null>(null)
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
  const [clientToDelete, setClientToDelete] = useState<Client | null>(null)

  const {
    register,
    handleSubmit,
    reset,
    setValue,
    formState: { errors },
  } = useForm()

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
    setValue('email', client.email)
    setValue('phone', client.phone)
    setValue('company', client.company)
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

    try {
      await axios.delete(`/api/clients/${clientToDelete.id}`)
      toast.success('Client deleted successfully')
      fetchClients()
    } catch {
      toast.error('Failed to delete client')
    } finally {
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

      {loading ? (
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
          {Array.from({ length: 6 }).map((_, i) => (
            <Skeleton key={i} className="h-24 w-full rounded-lg" />
          ))}
        </div>
      ) : (
        <DataTable
          columns={columns({ openEditDialog, confirmDelete })}
          data={clients}
          filterField="name"
        />
      )}

      <Dialog
        isOpen={dialogOpen}
        onClose={() => setDialogOpen(false)}
        title={selectedClient ? 'Edit Client' : 'Add Client'}
        onSubmit={handleSubmit(handleAddOrEdit)}
        buttonLoading={formLoading}
      >
        <div className="space-y-4">
          <Input placeholder="Name" {...register('name', { required: 'Name is required' })} />
          {errors.name && <p className="text-sm text-red-600">{errors.name.message as string}</p>}

          <Input placeholder="Phone" {...register('phone', { required: 'Phone is required' })} />
          {errors.phone && <p className="text-sm text-red-600">{errors.phone.message as string}</p>}

          <Input placeholder="Email (optional)" {...register('email')} />
          <Input placeholder="Company (optional)" {...register('company')} />
        </div>
      </Dialog>

      <Dialog
        isOpen={deleteDialogOpen}
        onClose={() => setDeleteDialogOpen(false)}
        title="Delete Client"
        onSubmit={handleDelete}
        buttonLoading={formLoading}
      >
        <p className="text-sm">
          Are you sure you want to delete{' '}
          <span className="text-red-600 font-semibold">{clientToDelete?.name}</span>?
        </p>
      </Dialog>
    </div>
  )
}
