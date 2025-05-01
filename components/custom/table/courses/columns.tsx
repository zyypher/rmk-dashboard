import { Course } from '@/types/course'
import { ColumnDef } from '@tanstack/react-table'
import { Pencil, Trash2 } from 'lucide-react'

export const columns = ({
    openEditDialog,
    confirmDelete,
}: {
    openEditDialog: (course: Course) => void
    confirmDelete: (course: Course) => void
}): ColumnDef<Course>[] => [
    {
        accessorKey: 'title',
        header: 'Title',
    },
    {
        accessorKey: 'category.name',
        header: 'Category',
        cell: ({ row }) => row.original.category.name,
    },
    {
        accessorKey: 'duration',
        header: 'Duration',
    },
    {
        accessorKey: 'languages',
        header: 'Languages',
        cell: ({ row }) => {
            const langs = row.original.languages

            return (
                <div className="flex flex-wrap gap-1">
                    {(langs ?? []).map((lang: any, i: number) => (
                        <span
                            key={i}
                            className="rounded-full border border-gray-300 bg-gray-100 px-2 py-0.5 text-xs text-gray-700"
                        >
                            {typeof lang === 'string' ? lang : lang.name}
                        </span>
                    ))}
                </div>
            )
        },
    },
    {
        accessorKey: 'isCertified',
        header: 'Certified',
        cell: ({ row }) => (row.original.isCertified ? '✅' : '❌'),
    },
    {
        accessorKey: 'isPublic',
        header: 'Public',
        cell: ({ row }) => (row.original.isPublic ? '🌐' : '🔒'),
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
