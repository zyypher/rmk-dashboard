'use client'

import { Dialog } from '@/components/ui/dialog'
import { Delegate } from '@/types/delegate'
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from '@/components/ui/table'
import ExcelJS from 'exceljs'
import { saveAs } from 'file-saver'

interface AttendantSheetModalProps {
    isOpen: boolean
    onClose: () => void
    delegates: Record<string, Delegate>
    large?: boolean
    bookingInfo?: {
        course: string
        trainer: string
        date: string
        time: string
        venue: string
        language: string
    }
}

export default function AttendantSheetModal({
    isOpen,
    onClose,
    delegates,
    large,
    bookingInfo,
}: AttendantSheetModalProps) {
    const exportToExcel = async () => {
        const workbook = new ExcelJS.Workbook()
        const worksheet = workbook.addWorksheet('Attendant Sheet')

        const imageBuffer = await fetch('/images/new/rmk-logo.png').then(
            (res) => res.arrayBuffer(),
        )
        const imageId = workbook.addImage({
            buffer: imageBuffer,
            extension: 'png',
        })
        worksheet.addImage(imageId, {
            tl: { col: 0, row: 0 },
            ext: { width: 220, height: 55 },
        })

        for (let i = 0; i < 3; i++) worksheet.addRow([])

        worksheet.mergeCells('C4:H4')
        const titleCell = worksheet.getCell('C4')
        titleCell.value = 'ATTENDANCE LIST OF ATTENDEES'
        titleCell.font = {
            bold: true,
            size: 14,
            name: 'Arial',
            color: { argb: 'FF083464' },
        }
        titleCell.alignment = { horizontal: 'center', vertical: 'middle' }

        worksheet.addRow([])

        const infoRows = [
            [
                'Training Course:',
                bookingInfo?.course || '',
                '',
                '',
                '',
                'Tutor/Lecturer:',
                bookingInfo?.trainer || '',
            ],
            [
                'Training Date:',
                bookingInfo?.date || '',
                '',
                '',
                '',
                'Training Timings:',
                bookingInfo?.time || '',
            ],
            [
                'Training Venue:',
                bookingInfo?.venue || '',
                '',
                '',
                '',
                'Training Language:',
                bookingInfo?.language || '',
            ],
        ]

        infoRows.forEach((row) => {
            const r = worksheet.addRow(row)
            r.getCell(1).font = { bold: true }
            r.getCell(6).font = { bold: true }
            r.getCell(2).font = { bold: false }
            r.getCell(7).font = { bold: false }
        })

        worksheet.addRow([])

        const headerRow = worksheet.addRow([
            'No.',
            'Name of Trainee',
            'Emirates ID No.',
            'Contact No.',
            'Company Name',
            'Brand/StoreName',
            'Trade License',
            'Signature',
        ])

        headerRow.height = 25
        headerRow.eachCell((cell) => {
            cell.font = { bold: true, color: { argb: 'FFFFFFFF' } }
            cell.alignment = { horizontal: 'center', vertical: 'middle' }
            cell.fill = {
                type: 'pattern',
                pattern: 'solid',
                fgColor: { argb: 'FF083464' },
            }
            cell.border = {
                top: { style: 'thin' },
                bottom: { style: 'thin' },
                left: { style: 'thin' },
                right: { style: 'thin' },
            }
        })

        const tableData = Object.entries(delegates).map(([_, d], i) => [
            i + 1,
            d.name || '',
            d.emiratesId || '',
            d.phone || '',
            d.companyName || '',
            d.newClient?.name || '-',
            d.newClient?.tradeLicenseNumber || '-',
            '',
        ])

        tableData.forEach((row) => {
            const newRow = worksheet.addRow(row)
            newRow.eachCell((cell) => {
                cell.alignment = { horizontal: 'center', vertical: 'middle' }
                cell.border = {
                    top: { style: 'thin' },
                    bottom: { style: 'thin' },
                    left: { style: 'thin' },
                    right: { style: 'thin' },
                }
            })
        })

        worksheet.addRow([])
        const summaryRow = worksheet.addRow([
            `Total no of attendees: ${tableData.length}`,
            '',
            '',
            '',
            'Tutor/Lecturer Signature: ____________________',
            '',
            'Checked and received by: ____________________',
        ])
        summaryRow.height = 35
        summaryRow.eachCell((cell) => {
            cell.alignment = { vertical: 'middle' }
        })

        worksheet.columns.forEach((col) => (col.width = 20))

        const buffer = await workbook.xlsx.writeBuffer()

        const parsedDate = (() => {
            if (!bookingInfo?.date) return null
            const [day, month, year] = bookingInfo.date.split('/')
            if (!day || !month || !year) return null
            return new Date(`${year}-${month}-${day}`)
        })()

        const formattedDate = parsedDate
            ? parsedDate.toLocaleDateString('en-GB').replace(/\//g, '-')
            : 'Unknown-Date'

        const courseName =
            bookingInfo?.course
                ?.replace(/[^a-z0-9]/gi, ' ')
                ?.trim()
                .replace(/\s+/g, ' ') || 'Training'
        const location =
            bookingInfo?.venue
                ?.replace(/[^a-z0-9]/gi, ' ')
                ?.trim()
                .replace(/\s+/g, ' ') || 'Location'

        const fileName = `EFST ATTENDANCE SHEET ${location} - ${courseName} - ${formattedDate}.xlsx`

        saveAs(new Blob([buffer]), fileName)
    }

    return (
        <Dialog
            isOpen={isOpen}
            onClose={onClose}
            title="Attendant Sheet"
            submitLabel="Export to Excel"
            className={large ? 'max-w-6xl' : ''}
        >
            <div className="max-h-[60vh] overflow-x-auto">
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHead>Seat</TableHead>
                            <TableHead>Name</TableHead>
                            <TableHead>Emirates ID</TableHead>
                            <TableHead>Phone</TableHead>
                            <TableHead>Email</TableHead>
                            <TableHead>Company</TableHead>
                            <TableHead>Type</TableHead>
                            <TableHead>Status</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {Object.entries(delegates).map(([seatId, d]) => (
                            <TableRow key={seatId}>
                                <TableCell>{seatId}</TableCell>
                                <TableCell>{d.name}</TableCell>
                                <TableCell>{d.emiratesId}</TableCell>
                                <TableCell>{d.phone}</TableCell>
                                <TableCell>{d.email}</TableCell>
                                <TableCell>{d.companyName}</TableCell>
                                <TableCell>
                                    {d.isCorporate ? 'Corporate' : 'Public'}
                                </TableCell>
                                <TableCell>
                                    {d.status === 'CONFIRMED' ? '✅' : '⚠️'}
                                </TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
                <div className="mt-4 flex justify-end gap-4">
                    <button
                        className="rounded bg-blue-600 px-4 py-2 text-white hover:bg-blue-700"
                        onClick={exportToExcel}
                    >
                        Export Attendance Sheet
                    </button>
                </div>
            </div>
        </Dialog>
    )
}
