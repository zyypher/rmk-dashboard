import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { TrainerSchedulingRule } from '@/types/scheduling-rule'

export const columns = ({
  openEditDialog,
  confirmDelete,
}: {
  openEditDialog: (rule: TrainerSchedulingRule) => void
  confirmDelete: (rule: TrainerSchedulingRule) => void
}): ColumnDef<TrainerSchedulingRule>[] => [
  {
    accessorKey: 'trainer.name',
    header: 'Trainer',
    cell: ({ row }) => row.original.trainer.name,
  },
  {
    accessorKey: 'daysOff',
    header: 'Days Off',
    cell: ({ row }) => (
      <div className="flex flex-wrap gap-1">
        {row.original.daysOff?.map((day: string, i: number) => (
          <span
            key={i}
            className="rounded-full border border-gray-300 bg-gray-100 px-2 py-0.5 text-xs text-gray-700"
          >
            {day}
          </span>
        ))}
      </div>
    ),
  },
  {
    accessorKey: 'maxSessionsPerDay',
    header: 'Max Sessions/Day',
  },
  {
    accessorKey: 'notes',
    header: 'Notes',
  },
  {
    accessorKey: 'allowOverlap',
    header: 'Overlap',
    cell: ({ row }) => (row.original.allowOverlap ? '✅' : '❌'),
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
