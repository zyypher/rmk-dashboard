import { ColumnDef } from '@tanstack/react-table'
import { Trainer } from '@/types'
import { Trash2, Pencil } from 'lucide-react'
import { formatDayList } from '@/lib/constants'

interface ColumnActions {
    openEditDialog: (trainer: Trainer) => void
    confirmDelete: (trainer: Trainer) => void
}

export function columns({
    openEditDialog,
    confirmDelete,
}: ColumnActions): ColumnDef<Trainer>[] {
    return [
        {
            accessorKey: 'name',
            header: 'Name',
        },
        {
            accessorKey: 'email',
            header: 'Email',
        },
        {
            accessorKey: 'phone',
            header: 'Phone',
        },
        {
            accessorKey: 'languages',
            header: 'Languages',
            cell: ({ row }) => row.original.languages.join(', '),
        },
        {
            accessorKey: 'availableDays',
            header: 'Available Days',
            cell: ({ row }) => formatDayList(row.original.availableDays),
        },
        {
            id: 'actions',
            header: '',
            cell: ({ row }) => {
                const trainer = row.original
                return (
                    <div className="flex items-center gap-2">
                        <button onClick={() => openEditDialog(trainer)}>
                            <Pencil className="text-blue-500 h-4 w-4" />
                        </button>
                        <button onClick={() => confirmDelete(trainer)}>
                            <Trash2 className="text-red-500 h-4 w-4" />
                        </button>
                    </div>
                )
            },
        },
    ]
}
