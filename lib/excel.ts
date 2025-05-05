import * as XLSX from 'xlsx'
import { Delegate } from '@/types/delegate'

export function downloadExcel(delegates: Record<string, Delegate>) {
  const data = Object.entries(delegates).map(([seat, delegate]) => ({
    Seat: seat,
    Name: delegate.name,
    'Emirates ID': delegate.emiratesId,
    Phone: delegate.phone,
    Email: delegate.email,
    'Company Name': delegate.companyName,
    Type: delegate.isCorporate ? 'Corporate' : 'Public',
    Status: delegate.status,
  }))

  const worksheet = XLSX.utils.json_to_sheet(data)
  const workbook = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(workbook, worksheet, 'Delegates')
  XLSX.writeFile(workbook, 'attendant_sheet.xlsx')
}
