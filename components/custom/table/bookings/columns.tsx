import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { Booking } from '@/types/booking'
import { Role } from '@/types/roles'

export const columns = ({
    role,
    openEditDialog,
    confirmDelete,
}: {
    role: Role
    openEditDialog: (booking: Booking) => void
    confirmDelete: (booking: Booking) => void
}): ColumnDef<Booking>[] => [
    {
        accessorKey: 'course.title',
        header: 'Course',
        cell: ({ row }) =>
            row.original.course?.title ?? (
                <span className="italic text-gray-400">N/A</span>
            ),
    },
    {
        accessorKey: 'trainer.name',
        header: 'Trainer',
        cell: ({ row }) =>
            row.original.trainer?.name ?? (
                <span className="italic text-gray-400">N/A</span>
            ),
    },
    {
        accessorKey: 'room.name',
        header: 'Room',
        cell: ({ row }) =>
            row.original.room?.name ?? (
                <span className="italic text-gray-400">N/A</span>
            ),
    },
    {
        accessorKey: 'date',
        header: 'Date',
        cell: ({ row }) => new Date(row.original.date).toLocaleDateString(),
    },
    {
        accessorKey: 'startTime',
        header: 'Start Time',
        cell: ({ row }) =>
            new Date(row.original.startTime).toLocaleTimeString([], {
                hour: '2-digit',
                minute: '2-digit',
            }),
    },
    {
        accessorKey: 'endTime',
        header: 'End Time',
        cell: ({ row }) =>
            new Date(row.original.endTime).toLocaleTimeString([], {
                hour: '2-digit',
                minute: '2-digit',
            }),
    },
    {
        accessorKey: 'language',
        header: 'Language',
        cell: ({ row }) =>
            row.original.language ?? (
                <span className="italic text-gray-400">N/A</span>
            ),
    },
    {
        accessorKey: 'notes',
        header: 'Notes',
        cell: ({ row }) =>
            row.original.notes ?? (
                <span className="italic text-gray-400">—</span>
            ),
    },
    {
        id: 'actions',
        header: 'Actions',
        cell: ({ row }) => {
            console.log('##role', role)
            const booking = row.original

            if (role === 'VIEWER') return null // ❌ No actions

            return (
                <div className="flex gap-2">
                    {/* ✏️ Edit allowed for both ADMIN and EDITOR */}
                    <button
                        className="text-blue-600 hover:text-blue-800"
                        onClick={() => openEditDialog(booking)}
                    >
                        <Pencil className="h-4 w-4" />
                    </button>

                    {/* 🗑️ Delete only for ADMIN */}
                    {role === 'ADMIN' && (
                        <button
                            className="text-red-500 hover:text-red-700"
                            onClick={() => confirmDelete(booking)}
                        >
                            <Trash2 className="h-4 w-4" />
                        </button>
                    )}
                </div>
            )
        },
    },
]
