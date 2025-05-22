// app/(dashboard)/delegates/page.tsx
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
import { Input } from '@/components/ui/input'
import { FloatingLabelInput } from '@/components/ui/FloatingLabelInput'
import { DataTable } from '@/components/custom/table/data-table'
import { columns } from '@/components/custom/table/delegates/columns'
import { useUserRole } from '@/hooks/useUserRole'
import debounce from 'lodash/debounce'
import { Delegate } from '@/types/delegate'

const schema = yup.object({
  name: yup.string().required(),
  emiratesId: yup.string().required(),
  phone: yup.string().required(),
  email: yup.string().email().optional(),
  companyName: yup.string().required(),
})

export default function DelegatesPage() {
  const [delegates, setDelegates] = useState<Delegate[]>([])
  const [loading, setLoading] = useState(true)
  const [dialogOpen, setDialogOpen] = useState(false)
  const [formLoading, setFormLoading] = useState(false)
  const [search, setSearch] = useState('')
  const [selectedDelegate, setSelectedDelegate] = useState<Delegate | null>(null)
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
  const [delegateToDelete, setDelegateToDelete] = useState<Delegate | null>(null)
  const [deleteLoading, setDeleteLoading] = useState(false)

  const role = useUserRole()

  const {
    register,
    handleSubmit,
    reset,
    setValue,
    watch,
    formState: { errors },
  } = useForm({
    resolver: yupResolver(schema),
    defaultValues: {
      name: '',
      emiratesId: '',
      phone: '',
      email: '',
      companyName: '',
    },
  })

  const fetchDelegates = async () => {
    setLoading(true)
    try {
      const res = await axios.get('/api/delegates')
      setDelegates(res.data)
    } catch {
      toast.error('Failed to fetch delegates')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchDelegates()
  }, [])

  const debouncedSearch = debounce(async (query: string) => {
    try {
      setLoading(true)
      const res = await axios.get('/api/delegates/search', {
        params: { q: query },
      })
      setDelegates(res.data)
    } catch {
      toast.error('Search failed')
    } finally {
      setLoading(false)
    }
  }, 500)

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value
    setSearch(val)
    debouncedSearch(val)
  }

  const openEditDialog = (delegate: Delegate) => {
    setSelectedDelegate(delegate)
    setDialogOpen(true)
    setValue('name', delegate.name)
    setValue('emiratesId', delegate.emiratesId)
    setValue('phone', delegate.phone)
    setValue('email', delegate.email)
    setValue('companyName', delegate.companyName)
  }

  const confirmDelete = (delegate: Delegate) => {
    setDelegateToDelete(delegate)
    setDeleteDialogOpen(true)
  }

  const handleAddOrEdit = async (data: any) => {
    setFormLoading(true)
    try {
      if (selectedDelegate) {
        await axios.put(`/api/delegates/${selectedDelegate.id}`, data)
        toast.success('Delegate updated')
      } else {
        await axios.post('/api/delegates', data)
        toast.success('Delegate added')
      }
      fetchDelegates()
      setDialogOpen(false)
    } catch {
      toast.error('Submit failed')
    } finally {
      setFormLoading(false)
    }
  }

  const handleDelete = async () => {
    if (!delegateToDelete) return
    setDeleteLoading(true)
    try {
      await axios.delete(`/api/delegates/${delegateToDelete.id}`)
      toast.success('Delegate deleted')
      fetchDelegates()
    } catch {
      toast.error('Delete failed')
    } finally {
      setDeleteDialogOpen(false)
      setDeleteLoading(false)
    }
  }

  return (
    <div className="space-y-6 p-6">
      <PageHeading heading="Delegates" />
      <div className="flex flex-wrap items-center justify-between gap-3">
        <Input
          placeholder="Search by name, email, or ID"
          value={search}
          onChange={handleSearchChange}
          className="w-full min-w-[16rem] sm:max-w-lg"
        />
        {/* <div className="flex gap-2">
          {(role === 'ADMIN' || role === 'EDITOR') && (
            <Button
              onClick={() => {
                reset()
                setSelectedDelegate(null)
                setDialogOpen(true)
              }}
            >
              <Plus className="mr-2 h-4 w-4" /> Add Delegate
            </Button>
          )}
        </div> */}
      </div>

      <DataTable
        columns={columns({ role, openEditDialog, confirmDelete })}
        data={delegates}
        filterField="name"
        loading={loading}
      />

      <Dialog
        isOpen={dialogOpen}
        onClose={() => setDialogOpen(false)}
        title={selectedDelegate ? 'Edit Delegate' : 'Add Delegate'}
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
            label="Emirates ID"
            name="emiratesId"
            value={watch('emiratesId')}
            onChange={(val) =>
              setValue('emiratesId', val, { shouldValidate: true })
            }
            error={errors.emiratesId?.message}
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
            label="Email"
            name="email"
            value={watch('email')}
            onChange={(val) => setValue('email', val)}
            error={errors.email?.message}
          />
          <FloatingLabelInput
            label="Company Name"
            name="companyName"
            value={watch('companyName')}
            onChange={(val) => setValue('companyName', val)}
            error={errors.companyName?.message}
          />
        </div>
      </Dialog>

      <Dialog
        isOpen={deleteDialogOpen}
        onClose={() => setDeleteDialogOpen(false)}
        title="Delete Delegate"
        onSubmit={handleDelete}
        buttonLoading={deleteLoading}
      >
        <p className="text-sm">
          Are you sure you want to delete{' '}
          <span className="font-semibold text-red-600">
            {delegateToDelete?.name}
          </span>
          ?
        </p>
      </Dialog>
    </div>
  )
}
