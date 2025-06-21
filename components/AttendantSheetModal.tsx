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
import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'
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
    const getFileName = (extension: string) => {
        const parsedDate = (() => {
            if (!bookingInfo?.date) return null
            const [day, month, year] = bookingInfo.date.split('/')
            if (!day || !month || !year) return null
            return `${year}-${month}-${day}`
        })()

        const formattedDate = parsedDate || 'Unknown-Date'

        const courseName =
            bookingInfo?.course
                ?.replace(/[^a-z0-9]/gi, ' ')
                .trim()
                .replace(/\s+/g, ' ') || 'Training'
        const location =
            bookingInfo?.venue
                ?.replace(/[^a-z0-9]/gi, ' ')
                .trim()
                .replace(/\s+/g, ' ') || 'Location'

        return `EFST ATTENDANCE SHEET ${location} - ${courseName} - ${formattedDate}.${extension}`
    }

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
        saveAs(new Blob([buffer]), getFileName('xlsx'))
    }

    const exportSimpleExcel = () => {
        const simpleWorkbook = new ExcelJS.Workbook()
        const ws = simpleWorkbook.addWorksheet('Simple Sheet')
        ws.addRow([
            'Seat',
            'Name',
            'Emirates ID',
            'Phone',
            'Email',
            'Company',
            'Type',
            'Status',
        ])
        Object.entries(delegates).forEach(([seat, d]) => {
            ws.addRow([
                seat,
                d.name,
                d.emiratesId,
                d.phone,
                d.email,
                d.companyName,
                d.isCorporate ? 'Corporate' : 'Public',
                d.status,
            ])
        })
        simpleWorkbook.xlsx.writeBuffer().then((buffer) => {
            saveAs(new Blob([buffer]), getFileName('simple.xlsx'))
        })
    }

    const exportToPDF = async () => {
        const doc = new jsPDF()
        doc.setFontSize(12)

        doc.addImage('/images/new/rmk-logo.png', 'PNG', 15, 10, 50, 20)
        doc.text('ATTENDANCE LIST OF ATTENDEES', 105, 40, { align: 'center' })

        doc.setFontSize(10)
        doc.text(`Training Course: ${bookingInfo?.course || ''}`, 15, 50)
        doc.text(`Tutor/Lecturer: ${bookingInfo?.trainer || ''}`, 115, 50)
        doc.text(`Training Date: ${bookingInfo?.date || ''}`, 15, 57)
        doc.text(`Training Timings: ${bookingInfo?.time || ''}`, 115, 57)
        doc.text(`Training Venue: ${bookingInfo?.venue || ''}`, 15, 64)
        doc.text(`Training Language: ${bookingInfo?.language || ''}`, 115, 64)

        autoTable(doc, {
            startY: 72,
            head: [
                [
                    'No.',
                    'Name of Trainee',
                    'Emirates ID No.',
                    'Contact No.',
                    'Company Name',
                    'Brand/StoreName',
                    'Trade License',
                    'Signature',
                ],
            ],
            body: Object.entries(delegates).map(([_, d], i) => [
                i + 1,
                d.name || '',
                d.emiratesId || '',
                d.phone || '',
                d.companyName || '',
                d.newClient?.name || '-',
                d.newClient?.tradeLicenseNumber || '-',
                '',
            ]),
            styles: { fontSize: 8, cellPadding: 2 },
            headStyles: { fillColor: [8, 52, 100], textColor: 255 },
        })

        const finalY = (doc as any).lastAutoTable.finalY || 100
        doc.text(
            `Total no of attendees: ${Object.keys(delegates).length}`,
            15,
            finalY + 10,
        )
        doc.text(
            'Tutor/Lecturer Signature: ____________________',
            60,
            finalY + 10,
        )
        doc.text(
            'Checked and received by: ____________________',
            135,
            finalY + 10,
        )

        doc.save(getFileName('pdf'))
    }

    return (
        <Dialog
            isOpen={isOpen}
            onClose={onClose}
            title="Attendant Sheet"
            submitLabel="Close"
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
                        onClick={exportSimpleExcel}
                        className="rounded bg-gray-500 px-4 py-2 text-white hover:bg-gray-600"
                    >
                        Export Simple Excel
                    </button>
                    <button
                        onClick={exportToPDF}
                        className="rounded bg-red-600 px-4 py-2 text-white hover:bg-red-700"
                    >
                        Export as PDF
                    </button>
                    <button
                        onClick={exportToExcel}
                        className="rounded bg-blue-600 px-4 py-2 text-white hover:bg-blue-700"
                    >
                        Export Attendance Sheet
                    </button>
                </div>
            </div>
        </Dialog>
    )
}
