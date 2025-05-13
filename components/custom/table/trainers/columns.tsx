import { ColumnDef } from '@tanstack/react-table'
import { Trainer } from '@/types'
import { Trash2, Pencil } from 'lucide-react'
import { formatDayList } from '@/lib/constants'
import { Role } from '@/types/roles' // ✅ Import the Role type

interface ColumnActions {
  role: Role
  openEditDialog: (trainer: Trainer) => void
  confirmDelete: (trainer: Trainer) => void
}

export function columns({
  role,
  openEditDialog,
  confirmDelete,
}: ColumnActions): ColumnDef<Trainer>[] {
  return [
    {
      accessorKey: 'name',
      header: 'Name',
    },
    {
      accessorKey: 'email',
      header: 'Email',
    },
    {
      accessorKey: 'phone',
      header: 'Phone',
    },
    {
      accessorKey: 'languages',
      header: 'Languages',
      cell: ({ row }) => row.original.languages.join(', '),
    },
    {
      accessorKey: 'availableDays',
      header: 'Available Days',
      cell: ({ row }) => formatDayList(row.original.availableDays),
    },
    {
      accessorKey: 'courses',
      header: 'Courses',
      cell: ({ row }) => row.original.courses.map((c) => c.title).join(', '),
    },
    {
      accessorKey: 'dailyTimeSlots',
      header: 'Time Slots',
      cell: ({ row }) =>
        row.original.dailyTimeSlots
          ?.map((slot) => {
            const start = new Date(slot.start)
            const end = new Date(slot.end)
            return `${start.toLocaleTimeString([], {
              hour: '2-digit',
              minute: '2-digit',
            })} - ${end.toLocaleTimeString([], {
              hour: '2-digit',
              minute: '2-digit',
            })}`
          })
          .join(', ') || '-',
    },
    {
      id: 'actions',
      header: '',
      cell: ({ row }) => {
        const trainer = row.original
        const canEdit = role === 'ADMIN' || role === 'EDITOR'
        const canDelete = role === 'ADMIN'

        return (
          <div className="flex items-center gap-2">
            {canEdit && (
              <button onClick={() => openEditDialog(trainer)}>
                <Pencil className="text-blue-500 h-4 w-4" />
              </button>
            )}
            {canDelete && (
              <button onClick={() => confirmDelete(trainer)}>
                <Trash2 className="text-red-500 h-4 w-4" />
              </button>
            )}
          </div>
        )
      },
    },
  ]
}
