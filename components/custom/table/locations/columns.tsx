import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { Location } from '@/types/location'
import toast from 'react-hot-toast'
import { Role } from '@/types/roles'

export const columns = ({
    role,
    openEditDialog,
    confirmDelete,
}: {
    role: Role
    openEditDialog: (location: Location) => void
    confirmDelete: (location: Location) => void
}): ColumnDef<Location>[] => [
    {
        accessorKey: 'emirate',
        header: 'Emirate',
    },
    {
        accessorKey: 'name',
        header: 'Branch Name',
    },
    {
        accessorKey: 'deliveryApproach',
        header: 'Delivery Approach',
    },
    {
        accessorKey: 'locationType',
        header: 'Location Type',
        cell: ({ row }) => row.original.locationType || '-',
    },
    {
        accessorKey: 'zoomLink',
        header: 'Zoom Link',
        cell: ({ row }) => {
            const zoomLink = row.original.zoomLink
            if (!zoomLink) return '—'

            const handleCopy = async () => {
                try {
                    await navigator.clipboard.writeText(zoomLink)
                    toast.success('Zoom link copied to clipboard!')
                } catch {
                    toast.error('Failed to copy link')
                }
            }

            return (
                <button
                    onClick={handleCopy}
                    className="text-blue-600 hover:text-blue-800 text-sm hover:underline"
                    title="Click to copy full Zoom link"
                >
                    Copy Link
                </button>
            )
        },
    },
    {
        accessorKey: 'createdAt',
        header: 'Created At',
        cell: ({ row }) =>
            row.original.createdAt
                ? new Date(row.original.createdAt).toLocaleDateString()
                : 'N/A',
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
                            onClick={() => openEditDialog(row.original)}
                            className="text-blue-600 hover:text-blue-800"
                        >
                            <Pencil className="h-4 w-4" />
                        </button>
                    )}
                    {canDelete && (
                        <button
                            onClick={() => confirmDelete(row.original)}
                            className="text-red-500 hover:text-red-700"
                        >
                            <Trash2 className="h-4 w-4" />
                        </button>
                    )}
                </div>
            )
        },
        enableSorting: false,
    },
]
