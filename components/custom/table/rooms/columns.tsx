import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { Room } from '@/types/room'

export const columns = ({
    openEditDialog,
    confirmDelete,
}: {
    openEditDialog: (room: Room) => void
    confirmDelete: (room: Room) => void
}): ColumnDef<Room>[] => [
    {
        accessorKey: 'location.name',
        header: 'Location',
        cell: ({ row }) => row.original.location?.name ?? '-',
    },
    {
        accessorKey: 'name',
        header: 'Room number',
    },
    {
        accessorKey: 'capacity',
        header: 'Room capacity',
    },
    {
        accessorKey: 'notes',
        header: 'Notes',
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
