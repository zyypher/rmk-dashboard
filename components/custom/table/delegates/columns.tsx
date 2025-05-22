import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { Delegate } from '@/types/delegate'
import { Role } from '@/types/roles'

export const columns = ({
  role,
  openEditDialog,
  confirmDelete,
}: {
  role: Role
  openEditDialog: (delegate: Delegate) => void
  confirmDelete: (delegate: Delegate) => void
}): ColumnDef<Delegate>[] => [
  {
    accessorKey: 'name',
    header: 'Name',
  },
  {
    accessorKey: 'email',
    header: 'Email',
    cell: ({ row }) => row.original.email || '-',
  },
  {
    accessorKey: 'phone',
    header: 'Phone',
    cell: ({ row }) => row.original.phone || '-',
  },
  {
    accessorKey: 'emiratesId',
    header: 'Emirates ID',
    cell: ({ row }) => row.original.emiratesId || '-',
  },
  {
    accessorKey: 'companyName',
    header: 'Company',
    cell: ({ row }) => row.original.companyName || '-',
  },
  {
    accessorKey: 'client.name',
    header: 'Client',
    cell: ({ row }) => row.original.client?.name || '-',
  },
//   {
//     accessorKey: 'sessionId',
//     header: 'Booking ID',
//   },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) =>
      row.original.status === 'CONFIRMED' ? 'Confirmed' : 'Not Confirmed',
  },
  {
    accessorKey: 'createdAt',
    header: 'Created At',
    cell: ({ row }) =>
      row.original.createdAt
        ? new Date(row.original.createdAt).toLocaleDateString()
        : 'N/A',
  },
//   {
//     id: 'actions',
//     header: 'Actions',
//     cell: ({ row }) => {
//       const delegate = row.original

//       const canEdit = role === 'ADMIN' || role === 'EDITOR'
//       const canDelete = role === 'ADMIN'

//       return (
//         <div className="flex gap-2">
//           {canEdit && (
//             <button
//               className="text-blue-600 hover:text-blue-800"
//               onClick={() => openEditDialog(delegate)}
//             >
//               <Pencil className="h-4 w-4" />
//             </button>
//           )}
//           {canDelete && (
//             <button
//               className="text-red-500 hover:text-red-700"
//               onClick={() => confirmDelete(delegate)}
//             >
//               <Trash2 className="h-4 w-4" />
//             </button>
//           )}
//         </div>
//       )
//     },
//   },
]
