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
import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'

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

    console.log('##bookingInfo', bookingInfo)
    const exportToPDF = () => {
        const doc = new jsPDF({
            orientation: 'landscape',
            unit: 'mm',
            format: 'a4',
        })

        const logoUrl = '/images/new/rmk-logo.png'
        const img = new Image()
        img.src = logoUrl
        img.onload = () => {
            doc.addImage(img, 'PNG', 14, 10, 35, 20) // logo, no squeeze

            // Title
            doc.setFontSize(14)
            doc.setTextColor(4, 45, 84)
            doc.setFont('helvetica', 'bold')
            doc.text('ATTENDANCE LIST OF ATTENDEES', 148.5, 30, {
                align: 'center',
            })

            // Booking Info: Left aligned with grid padding
            doc.setFontSize(10)
            doc.setTextColor(0, 0, 0)
            doc.setFont('helvetica', 'normal')

            const leftInfo = [
                `Training Course: ${bookingInfo?.course || ''}`,
                `Training Date: ${bookingInfo?.date || ''}`,
                `Training Venue: ${bookingInfo?.venue || ''}`,
            ]
            const rightInfo = [
                `Tutor/Lecturer: ${bookingInfo?.trainer || ''}`,
                `Training Timings: ${bookingInfo?.time || ''}`,
                `Training Language: ${bookingInfo?.language || ''}`,
            ]

            leftInfo.forEach((line, i) => doc.text(line, 14, 42 + i * 6))
            rightInfo.forEach((line, i) => doc.text(line, 170, 42 + i * 6))

            // Table
            const tableData = Object.entries(delegates).map(
                ([seatId, d], i) => {
                    const clientName = d.newClient?.name || '-'
                    const tradeLicense = d.newClient?.tradeLicenseNumber || '-'

                    return [
                        i + 1,
                        d.name || '',
                        d.emiratesId || '',
                        d.phone || '',
                        d.companyName || '',
                        clientName,
                        tradeLicense,
                        '', // Signature
                    ]
                },
            )

            autoTable(doc, {
                head: [
                    [
                        'No.',
                        'Name of Trainee',
                        'Emirates ID No.',
                        'Contact No.',
                        'Company Name',
                        'Client Name',
                        'Trade License',
                        'Signature',
                    ],
                ],
                body: tableData,
                startY: 60,
                theme: 'grid',
                styles: {
                    fontSize: 9,
                    cellPadding: 2,
                },
                headStyles: {
                    fillColor: [4, 45, 84],
                    textColor: 255,
                    halign: 'center',
                },
                bodyStyles: {
                    halign: 'center',
                    lineColor: [50, 50, 50],
                    lineWidth: 0.5,
                },
            })

            const finalY = (doc as any).lastAutoTable?.finalY || 100

            // Footer content above bottom
            doc.setFontSize(10)
            doc.setTextColor(0, 0, 0)
            doc.text(
                `Total no of attendees: ${tableData.length}`,
                14,
                finalY + 10,
            )
            doc.text(
                'Tutor/Lecturer Signature: ____________________',
                90,
                finalY + 10,
            )
            doc.text(
                'Checked and received by: ____________________',
                170,
                finalY + 10,
            )

            // Footer block with padding
            doc.setFontSize(8)
            const footerLines = [
                'RMK Abu Dhabi: Al Salam St., Abdullah Bin Darwish Alketbi Tower, Intersection Hamdan St., 14th Floor, Office no. 1404',
                'Tel: +971-26738340    Mobile# 0588081972',
                'Email: ghada@rmkexperts.com / admin@rmkexperts.com | www.rmkexperts.com',
            ]
            footerLines.forEach((line, i) =>
                doc.text(line, 148.5, 205 + i * 5, { align: 'center' }),
            )

            doc.save('attendant_sheet.pdf')
        }
    }

    return (
        <Dialog
            isOpen={isOpen}
            onClose={onClose}
            title="Attendant Sheet"
            submitLabel="Export to PDF"
            onSubmit={exportToPDF}
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
            </div>
        </Dialog>
    )
}
