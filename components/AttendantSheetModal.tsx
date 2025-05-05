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
import { saveAs } from 'file-saver'
import * as XLSX from 'xlsx'

interface AttendantSheetModalProps {
  isOpen: boolean
  onClose: () => void
  delegates: Record<string, Delegate>
  large?: boolean
}

export default function AttendantSheetModal({
  isOpen,
  onClose,
  delegates,
  large,
}: AttendantSheetModalProps) {
  const delegateList = Object.entries(delegates).map(([seatId, d]) => ({
    Seat: seatId,
    Name: d.name,
    'Emirates ID': d.emiratesId,
    Phone: d.phone,
    Email: d.email,
    Company: d.companyName,
    Type: d.isCorporate ? 'Corporate' : 'Public',
    Status: d.status === 'CONFIRMED' ? 'Confirmed' : 'Not Confirmed',
  }))

  const exportToExcel = () => {
    const worksheet = XLSX.utils.json_to_sheet(delegateList)
    const workbook = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Attendants')
    const excelBuffer = XLSX.write(workbook, { bookType: 'xlsx', type: 'array' })
    const data = new Blob([excelBuffer], { type: 'application/octet-stream' })
    saveAs(data, 'attendant_sheet.xlsx')
  }

  return (
    <Dialog
      isOpen={isOpen}
      onClose={onClose}
      title="Attendant Sheet"
      submitLabel="Export to Excel"
      onSubmit={exportToExcel}
      className={large ? 'max-w-6xl' : ''}
    >
      <div className="overflow-x-auto max-h-[60vh]">
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
                <TableCell>{d.isCorporate ? 'Corporate' : 'Public'}</TableCell>
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
