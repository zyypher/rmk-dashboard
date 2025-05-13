import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { TrainerLeave } from '@/types/trainer-leave'
import { Role } from '@/types/roles' // Make sure you have this Role type

export const columns = ({
    role,
    openEditDialog,
    confirmDelete,
}: {
    role: Role
    openEditDialog: (leave: TrainerLeave) => void
    confirmDelete: (leave: TrainerLeave) => void
}): ColumnDef<TrainerLeave>[] => [
    {
        accessorKey: 'trainer.name',
        header: 'Trainer',
        cell: ({ row }) => row.original.trainer.name,
    },
    {
        accessorKey: 'date',
        header: 'Leave Date',
        cell: ({ row }) => new Date(row.original.date).toLocaleDateString(),
    },
    {
        accessorKey: 'reason',
        header: 'Reason',
    },
    {
        id: 'actions',
        header: 'Actions',
        cell: ({ row }) => {
            const canEdit = role === 'ADMIN' || role === 'EDITOR'
            const canDelete = role === 'ADMIN'

            return (
                <div className="flex gap-2">
                    {canEdit && (
                        <button
                            className="text-blue-600 hover:text-blue-800"
                            onClick={() => openEditDialog(row.original)}
                        >
                            <Pencil className="h-4 w-4" />
                        </button>
                    )}
                    {canDelete && (
                        <button
                            className="text-red-500 hover:text-red-700"
                            onClick={() => confirmDelete(row.original)}
                        >
                            <Trash2 className="h-4 w-4" />
                        </button>
                    )}
                </div>
            )
        },
    },
]
