import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { Location } from '@/types/location'

export const columns = ({
  openEditDialog,
  confirmDelete,
}: {
  openEditDialog: (location: Location) => void
  confirmDelete: (location: Location) => void
}): ColumnDef<Location>[] => [
  {
    accessorKey: 'name',
    header: 'Branch Name',
  },
  {
    accessorKey: 'address',
    header: 'Full Address',
  },
  {
    accessorKey: 'isOnline',
    header: 'Location Type',
    cell: ({ row }) => (row.original.isOnline ? 'Online' : 'Offline'),
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
    cell: ({ row }) => (
      <div className="flex gap-2">
        <button
          onClick={() => openEditDialog(row.original)}
          className="text-blue-600 hover:text-blue-800"
        >
          <Pencil className="h-4 w-4" />
        </button>
        <button
          onClick={() => confirmDelete(row.original)}
          className="text-red-500 hover:text-red-700"
        >
          <Trash2 className="h-4 w-4" />
        </button>
      </div>
    ),
    enableSorting: false,
  },
]
