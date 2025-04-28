import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { TrainerLeave } from '@/types/trainer-leave'

export const columns = ({
    openEditDialog,
    confirmDelete,
}: {
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
        cell: ({ row }) => (
            <div className="flex gap-2">
                <button
                    className="text-blue-600 hover:text-blue-800"
                    onClick={() => openEditDialog(row.original)}
                >
                    <Pencil className="h-4 w-4" />
                </button>
                <button
                    className="text-red-500 hover:text-red-700"
                    onClick={() => confirmDelete(row.original)}
                >
                    <Trash2 className="h-4 w-4" />
                </button>
            </div>
        ),
    },
]
