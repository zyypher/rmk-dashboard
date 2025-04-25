import { ColumnDef } from '@tanstack/react-table'
import { Pencil } from 'lucide-react'
import { Room } from '@/types/room'

export const columns = ({
    openEditDialog,
}: {
    openEditDialog: (room: Room) => void
}): ColumnDef<Room>[] => [
    {
        accessorKey: 'name',
        header: 'Name',
    },
    {
        accessorKey: 'type',
        header: 'Type',
        cell: ({ row }) =>
            row.original.type === 'ONLINE' ? 'Online' : 'Offline',
    },
    {
        accessorKey: 'capacity',
        header: 'Capacity',
    },
    {
        accessorKey: 'location.name',
        header: 'Branch',
        cell: ({ row }) => row.original.location.name,
    },
    {
        accessorKey: 'notes',
        header: 'Notes',
    },
    {
        id: 'actions',
        header: '',
        cell: ({ row }) => (
            <button
                onClick={() => openEditDialog(row.original)}
                className="text-blue-600 hover:text-blue-800"
            >
                <Pencil className="h-4 w-4" />
            </button>
        ),
    },
]
