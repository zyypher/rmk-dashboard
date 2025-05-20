import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { Client } from '@/types/client'
import { Role } from '@/types/roles'

export const columns = ({
  role,
  openEditDialog,
  confirmDelete,
}: {
  role: Role
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
    accessorKey: 'contactPersonPosition',
    header: 'Contact Person Position',
    cell: ({ row }) => row.original.contactPersonPosition || '-',
  },
  {
    accessorKey: 'phone',
    header: 'Phone',
  },
  {
    accessorKey: 'landline',
    header: 'Landline',
    cell: ({ row }) => row.original.landline || '-',
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
    cell: ({ row }) => {
      const client = row.original

      const canEdit = role === 'ADMIN' || role === 'EDITOR'
      const canDelete = role === 'ADMIN'

      return (
        <div className="flex gap-2">
          {canEdit && (
            <button
              className="text-blue-600 hover:text-blue-800"
              onClick={() => openEditDialog(client)}
            >
              <Pencil className="h-4 w-4" />
            </button>
          )}
          {canDelete && (
            <button
              className="text-red-500 hover:text-red-700"
              onClick={() => confirmDelete(client)}
            >
              <Trash2 className="h-4 w-4" />
            </button>
          )}
        </div>
      )
    },
  },
]
