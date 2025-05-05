import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'
import { Booking } from '@/types/booking'

export const columns = ({
  openEditDialog,
  confirmDelete,
}: {
  openEditDialog: (booking: Booking) => void
  confirmDelete: (booking: Booking) => void
}): ColumnDef<Booking>[] => [
  {
    accessorKey: 'course.title',
    header: 'Course',
    cell: ({ row }) =>
      row.original.course?.title ?? <span className="text-gray-400 italic">N/A</span>,
  },
  {
    accessorKey: 'trainer.name',
    header: 'Trainer',
    cell: ({ row }) => {
      const trainers = row.original.course?.trainers
      return trainers && trainers.length > 0
        ? trainers[0].name
        : <span className="text-gray-400 italic">N/A</span>
    },
  },
  
  {
    accessorKey: 'room.name',
    header: 'Room',
    cell: ({ row }) =>
      row.original.room?.name ?? <span className="text-gray-400 italic">N/A</span>,
  },
  {
    accessorKey: 'date',
    header: 'Date',
    cell: ({ row }) =>
      new Date(row.original.date).toLocaleDateString(),
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
      row.original.language ?? <span className="text-gray-400 italic">N/A</span>,
  },
  {
    accessorKey: 'notes',
    header: 'Notes',
    cell: ({ row }) =>
      row.original.notes ?? <span className="text-gray-400 italic">—</span>,
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
