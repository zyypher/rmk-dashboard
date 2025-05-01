import { ColumnDef } from '@tanstack/react-table'
import { Edit, Trash2 } from 'lucide-react'
import { Badge } from '@/components/ui/badge'

export interface IUser {
    id: string
    email: string
    role: string
    createdAt: string
}

export const columns: ColumnDef<IUser>[] = [
    {
        accessorKey: 'email',
        header: 'Email',
        cell: ({ getValue }) => (
            <span className="text-sm font-medium">{getValue() as string}</span>
        ),
    },
    {
        accessorKey: 'role',
        header: 'Role',
        cell: ({ getValue }) => {
            const role = getValue() as string
            return (
                <Badge
                    variant={
                        role === 'ADMIN'
                            ? 'red'
                            : role === 'EDITOR'
                              ? 'blue'
                              : 'grey'
                    }
                >
                    {role.charAt(0) + role.slice(1).toLowerCase()}
                </Badge>
            )
        },
    },
    {
        accessorKey: 'createdAt',
        header: 'Created At',
        cell: ({ getValue }) => {
            const date = getValue() as string
            return (
                <span className="text-muted-foreground text-xs">
                    {new Date(date).toLocaleDateString()}
                </span>
            )
        },
    },
    {
        id: 'actions',
        header: '',
        cell: ({ row }) => {
            const user = row.original
            return (
                <div className="flex items-center gap-2">
                    <button
                        type="button"
                        onClick={() =>
                            window.dispatchEvent(
                                new CustomEvent('openEditUser', {
                                    detail: user,
                                }),
                            )
                        }
                        title="Edit"
                    >
                        <Edit className="text-blue-500 hover:text-blue-700 h-4 w-4" />
                    </button>
                    <button
                        type="button"
                        onClick={() =>
                            window.dispatchEvent(
                                new CustomEvent('confirmDeleteUser', {
                                    detail: user.id,
                                }),
                            )
                        }
                        title="Delete"
                    >
                        <Trash2 className="text-red-500 hover:text-red-700 h-4 w-4" />
                    </button>
                </div>
            )
        },
    },
]
