'use client'

import { useEffect, useState } from 'react'
import api from '@/lib/api'
import toast from 'react-hot-toast'
import { DataTable } from '@/components/custom/table/data-table'
import { Button } from '@/components/ui/button'
import { Plus } from 'lucide-react'
import { useForm } from 'react-hook-form'
import PageHeading from '@/components/layout/page-heading'
import { columns } from '@/components/custom/table/users/columns'
import { Dialog } from '@/components/ui/dialog'
import * as yup from 'yup'
import { yupResolver } from '@hookform/resolvers/yup'
import { FloatingLabelInput } from '@/components/ui/FloatingLabelInput'

const userSchema = yup.object({
    email: yup.string().email('Invalid email').required('Email is required'),
    role: yup.string().required('Role is required'),
})

type User = {
    id: string
    email: string
    role: string
    createdAt: string
}

const UsersPage = () => {
    const [users, setUsers] = useState<User[]>([])
    const [loading, setLoading] = useState(true)
    const [isDialogOpen, setIsDialogOpen] = useState(false)
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
    const [userToDelete, setUserToDelete] = useState<string | null>(null)
    const [buttonLoading, setButtonLoading] = useState(false)
    const [selectedUser, setSelectedUser] = useState<User | null>(null)
    const [deleteLoading, setDeleteLoading] = useState(false)

    const {
        register,
        handleSubmit,
        reset,
        setValue,
        watch,
        formState: { errors },
    } = useForm({
        resolver: yupResolver(userSchema),
    })

    useEffect(() => {
        fetchUsers()

        const editHandler = (event: CustomEvent) => openEditModal(event.detail)
        const deleteHandler = (event: CustomEvent) =>
            openDeleteDialog(event.detail)

        window.addEventListener('openEditUser', editHandler as EventListener)
        window.addEventListener(
            'confirmDeleteUser',
            deleteHandler as EventListener,
        )

        return () => {
            window.removeEventListener(
                'openEditUser',
                editHandler as EventListener,
            )
            window.removeEventListener(
                'confirmDeleteUser',
                deleteHandler as EventListener,
            )
        }
    }, [])

    const fetchUsers = async () => {
        setLoading(true)
        try {
            const response = await api.get('/api/users')
            setUsers(response.data)
        } catch (error) {
            toast.error('Failed to load users')
        } finally {
            setLoading(false)
        }
    }

    const handleAddUser = async (data: any) => {
        setButtonLoading(true)
        try {
            let response

            if (selectedUser) {
                response = await api.put(`/api/users/${selectedUser.id}`, data)
                toast.success('User updated successfully')
            } else {
                response = await api.post('/api/users', data)
                toast.success('User added successfully')
            }

            reset()
            setIsDialogOpen(false)
            fetchUsers()
        } catch (error) {
            toast.error('Failed to submit user')
            console.error(error)
        } finally {
            setButtonLoading(false)
        }
    }

    const handleDeleteUser = async () => {
        if (!userToDelete) return
        setDeleteLoading(true)
        try {
            await api.delete(`/api/users/${userToDelete}`)
            toast.success('User deleted successfully')
            fetchUsers()
        } catch (error) {
            toast.error('Failed to delete user')
        } finally {
            setDeleteLoading(false)
            setDeleteDialogOpen(false)
            setUserToDelete(null)
        }
    }

    const openEditModal = (user: User) => {
        setSelectedUser(user)
        setValue('email', user.email)
        setValue('role', user.role)
        setIsDialogOpen(true)
    }

    const openDeleteDialog = (id: string) => {
        setUserToDelete(id)
        setDeleteDialogOpen(true)
    }

    return (
        <div className="space-y-4">
            <PageHeading heading="Users" />
            <div className="flex items-center justify-end">
                <Button variant="black" onClick={() => setIsDialogOpen(true)}>
                    <Plus className="mr-2" />
                    Add User
                </Button>
            </div>

            <DataTable
                columns={columns}
                data={users}
                filterField="email"
                loading={loading}
            />

            {/* Add/Edit User Dialog */}
            <Dialog
                isOpen={isDialogOpen}
                onClose={() => setIsDialogOpen(false)}
                title={selectedUser ? 'Edit User' : 'Add User'}
                onSubmit={handleSubmit(handleAddUser)}
                buttonLoading={buttonLoading}
            >
                <div className="space-y-4">
                    <FloatingLabelInput
                        label="Email"
                        value={watch('email')}
                        onChange={(val) =>
                            setValue('email', val, { shouldValidate: true })
                        }
                        name="email"
                        error={errors.email?.message as string}
                    />

                    <div>
                        <label className="text-sm font-medium text-gray-700">
                            Role
                        </label>
                        <select
                            className="mt-1 w-full rounded border p-2"
                            {...register('role')}
                        >
                            <option value="">Select Role</option>
                            <option value="ADMIN">Admin</option>
                            <option value="EDITOR">Editor</option>
                            <option value="VIEWER">Viewer</option>
                        </select>
                        {errors.role && (
                            <p className="text-red-500 mt-1 text-sm">
                                {String(errors.role.message)}
                            </p>
                        )}
                    </div>
                </div>
            </Dialog>

            {/* Delete Confirmation Dialog */}
            <Dialog
                isOpen={deleteDialogOpen}
                onClose={() => setDeleteDialogOpen(false)}
                title="Confirm Delete"
                onSubmit={handleDeleteUser}
                buttonLoading={deleteLoading}
            >
                <div className="text-lg font-semibold">
                    Are you sure you want to delete{' '}
                    <span className="text-red-600 font-bold">
                        {users.find((u) => u.id === userToDelete)?.email ||
                            'this user'}
                    </span>
                    ?
                </div>
            </Dialog>
        </div>
    )
}

export default UsersPage
