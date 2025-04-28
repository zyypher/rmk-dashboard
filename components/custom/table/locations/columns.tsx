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
    accessorKey: 'type',
    header: 'Room Type',
    cell: ({ row }) => row.original.type === 'ONLINE' ? 'Online' : 'Offline',
  },
  {
    accessorKey: 'capacity',
    header: 'Room Capacity',
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
