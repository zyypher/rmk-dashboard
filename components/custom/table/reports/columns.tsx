import { ColumnDef } from '@tanstack/react-table'
import { Booking } from '@/types/booking'

export const columns: ColumnDef<Booking>[] = [
  {
    accessorKey: 'clientName',
    header: 'Client Name',
  },
  {
    accessorKey: 'clientContact',
    header: 'Client Contact',
  },
  {
    accessorKey: 'course.title',
    header: 'Course',
    cell: ({ row }) => row.original.course?.title || '—',
  },
  {
    accessorKey: 'location',
    header: 'Location',
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
      new Date(row.original.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
  },
  {
    accessorKey: 'endTime',
    header: 'End Time',
    cell: ({ row }) =>
      new Date(row.original.endTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
  },
  {
    accessorKey: 'delegates',
    header: 'Delegates Count',
    cell: ({ row }) => row.original.delegates?.length ?? 0,
  },
]
