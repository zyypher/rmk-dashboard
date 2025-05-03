import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { Client } from '@/types/client'

export const columns = ({
  openEditDialog,
  confirmDelete,
}: {
  openEditDialog: (client: Client) => void
  confirmDelete: (client: Client) => void
}): ColumnDef<Client>[] => [
  {
    accessorKey: 'name',
    header: 'Name',
  },
  {
    accessorKey: 'contactPersonName',
    header: 'Contact Person Name',
    cell: ({ row }) => row.original.contactPersonName || '-',
  },
  {
    accessorKey: 'phone',
    header: 'Phone',
  },
  {
    accessorKey: 'email',
    header: 'Email',
    cell: ({ row }) => row.original.email || '-',
  },
  {
    accessorKey: 'tradeLicenseNumber',
    header: 'Trade License Number',
    cell: ({ row }) => row.original.tradeLicenseNumber || '-',
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
