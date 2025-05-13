import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { Room } from '@/types/room'
import { Role } from '@/types/roles' // Make sure Role type is imported

export const columns = ({
    role,
    openEditDialog,
    confirmDelete,
}: {
    role: Role
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
