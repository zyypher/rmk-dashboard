'use client'

import {
    ColumnDef,
    ColumnFiltersState,
    flexRender,
    getCoreRowModel,
    getFilteredRowModel,
    getSortedRowModel,
    SortingState,
    useReactTable,
    VisibilityState,
    RowSelectionState,
} from '@tanstack/react-table'

import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from '@/components/ui/table'
import React, { useEffect } from 'react'
import { InputSearch } from '@/components/ui/input-search'
import { createPortal } from 'react-dom'
import { Skeleton } from '@/components/ui/skeleton'
import { Button } from '@/components/ui/button'

interface DataTableProps<TData extends { id: string; status?: string }> {
    columns: ColumnDef<TData>[]
    data: TData[]
    filterField: string
    isFilterRowBasedOnValue?: string
    isRemovePagination?: boolean
    isFilterRow?: boolean
    isAllRowKey?: string
    loading?: boolean
    rowSelectionCallback?: (selectedIds: string[]) => void
    manualPagination?: boolean
    currentPage?: number
    totalPages?: number
    onPageChange?: (page: number) => void
}

export function DataTable<TData extends { id: string; status?: string }>({
    columns,
    data,
    filterField,
    isFilterRow = false,
    isFilterRowBasedOnValue,
    isRemovePagination = true,
    isAllRowKey,
    loading = false,
    rowSelectionCallback,
    manualPagination = false,
    currentPage = 1,
    totalPages = 1,
    onPageChange,
}: DataTableProps<TData>) {
    const [sorting, setSorting] = React.useState<SortingState>([])
    const [columnFilters, setColumnFilters] =
        React.useState<ColumnFiltersState>([])
    const [columnVisibility, setColumnVisibility] =
        React.useState<VisibilityState>({})
    const [rowSelection, setRowSelection] = React.useState<RowSelectionState>(
        {},
    )

    const table = useReactTable({
        data,
        columns,
        onSortingChange: setSorting,
        onColumnFiltersChange: setColumnFilters,
        getCoreRowModel: getCoreRowModel(),
        getSortedRowModel: getSortedRowModel(),
        getFilteredRowModel: getFilteredRowModel(),
        onColumnVisibilityChange: setColumnVisibility,
        onRowSelectionChange: setRowSelection,
        state: {
            sorting,
            columnFilters,
            columnVisibility,
            rowSelection,
        },
        enableRowSelection: true,
    })

    const TableData = isFilterRow
        ? table
              .getRowModel()
              .rows.filter((rowItems) =>
                  isFilterRowBasedOnValue === isAllRowKey
                      ? rowItems
                      : rowItems.original.status === isFilterRowBasedOnValue,
              )
        : table.getRowModel().rows

    const [mounted, setMounted] = React.useState<boolean>(false)

    useEffect(() => {
        setMounted(true)
        return () => setMounted(false)
    }, [])

    useEffect(() => {
        const selectedIds = Object.keys(rowSelection)
            .map((key) => table.getRow(key)?.original.id)
            .filter(Boolean)
        if (rowSelectionCallback) rowSelectionCallback(selectedIds as string[])
    }, [rowSelection, table])

    return (
        <div>
            <div className="w-full overflow-hidden rounded-b-lg bg-white shadow-sm">
                <div>
                    {mounted &&
                        document.getElementById('search-table') &&
                        createPortal(
                            <InputSearch
                                placeholder={`Search ${filterField || ''}`}
                                value={
                                    (table
                                        .getColumn(filterField)
                                        ?.getFilterValue() as string) ?? ''
                                }
                                onChange={(event) =>
                                    table
                                        .getColumn(filterField)
                                        ?.setFilterValue(event.target.value)
                                }
                            />,
                            document.getElementById('search-table')!,
                        )}
                </div>
                <Table>
                    <TableHeader>
                        {table.getHeaderGroups().map((headerGroup) => (
                            <TableRow key={headerGroup.id}>
                                {headerGroup.headers.map((header) => (
                                    <TableHead
                                        key={header.id}
                                        className="last:w-0"
                                    >
                                        {header.isPlaceholder
                                            ? null
                                            : flexRender(
                                                  header.column.columnDef
                                                      .header,
                                                  header.getContext(),
                                              )}
                                    </TableHead>
                                ))}
                            </TableRow>
                        ))}
                    </TableHeader>
                    <TableBody>
                        {loading ? (
                            Array.from({ length: 5 }).map((_, rowIdx) => (
                                <TableRow key={`skeleton-row-${rowIdx}`}>
                                    {table
                                        .getAllColumns()
                                        .filter((col) => col.getIsVisible())
                                        .map((col, colIdx) => (
                                            <TableCell
                                                key={`skeleton-cell-${rowIdx}-${colIdx}`}
                                            >
                                                <Skeleton className="h-4 w-[80%]" />
                                            </TableCell>
                                        ))}
                                </TableRow>
                            ))
                        ) : table.getRowModel().rows?.length ? (
                            TableData.map((row) => (
                                <TableRow
                                    key={row.id}
                                    data-state={
                                        row.getIsSelected() && 'selected'
                                    }
                                >
                                    {row.getVisibleCells().map((cell) => (
                                        <TableCell key={cell.id}>
                                            {flexRender(
                                                cell.column.columnDef.cell,
                                                cell.getContext(),
                                            )}
                                        </TableCell>
                                    ))}
                                </TableRow>
                            ))
                        ) : (
                            <TableRow>
                                <TableCell
                                    colSpan={columns.length}
                                    className="h-24 !text-center text-lg font-semibold"
                                >
                                    No results.
                                </TableCell>
                            </TableRow>
                        )}
                    </TableBody>
                </Table>
            </div>

            {manualPagination && totalPages > 1 && (
                <div className="mt-4 flex justify-end gap-2 text-sm">
                    <Button
                        variant="outline"
                        disabled={currentPage === 1}
                        onClick={() => onPageChange?.(currentPage - 1)}
                    >
                        Previous
                    </Button>
                    <span className="px-2 pt-2">
                        Page {currentPage} of {totalPages}
                    </span>
                    <Button
                        variant="outline"
                        disabled={currentPage === totalPages}
                        onClick={() => onPageChange?.(currentPage + 1)}
                    >
                        Next
                    </Button>
                </div>
            )}
        </div>
    )
}
