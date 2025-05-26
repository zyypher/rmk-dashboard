'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { saveAs } from 'file-saver'
import * as XLSX from 'xlsx'
import { Course } from '@/types/course'
import { Location } from '@/types/location'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'

export default function MonthlyReportPage() {
  const [filters, setFilters] = useState({
    clientName: '',
    delegateName: '',
    clientPhone: '',
    date: '',
    courseId: '',
    locationId: '',
  })

  const [loading, setLoading] = useState(false)
  const [courses, setCourses] = useState<Course[]>([])
  const [locations, setLocations] = useState<Location[]>([])

  useEffect(() => {
    const fetchDropdowns = async () => {
      const [courseRes, locationRes] = await Promise.all([
        axios.get('/api/courses'),
        axios.get('/api/locations'),
      ])
      setCourses(courseRes.data.courses)
      setLocations(locationRes.data.locations)
    }

    fetchDropdowns()
  }, [])

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFilters({ ...filters, [e.target.name]: e.target.value })
  }

  const handleGenerateReport = async () => {
    setLoading(true)
    try {
      const res = await axios.get('/api/reports', {
        params: filters,
      })

      const worksheet = XLSX.utils.json_to_sheet(res.data)
      const workbook = XLSX.utils.book_new()
      XLSX.utils.book_append_sheet(workbook, worksheet, 'Monthly Report')
      const excelBuffer = XLSX.write(workbook, { bookType: 'xlsx', type: 'array' })
      const data = new Blob([excelBuffer], { type: 'application/octet-stream' })
      saveAs(data, 'monthly_report.xlsx')
    } catch (err) {
      console.error('Failed to generate report:', err)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6 p-6">
      <h1 className="text-2xl font-semibold">Monthly Report</h1>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Input placeholder="Client Name" name="clientName" onChange={handleChange} />
        <Input placeholder="Delegate Name" name="delegateName" onChange={handleChange} />
        <Input placeholder="Client Phone" name="clientPhone" onChange={handleChange} />
        <Input type="date" name="date" onChange={handleChange} />
        <Select
          onValueChange={(val) => setFilters((prev) => ({ ...prev, courseId: val }))}
        >
          <SelectTrigger>
            <SelectValue placeholder="Select Course" />
          </SelectTrigger>
          <SelectContent>
            {courses.map((c) => (
              <SelectItem key={c.id} value={c.id}>
                {c.title}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select
          onValueChange={(val) => setFilters((prev) => ({ ...prev, locationId: val }))}
        >
          <SelectTrigger>
            <SelectValue placeholder="Select Location" />
          </SelectTrigger>
          <SelectContent>
            {locations.map((l) => (
              <SelectItem key={l.id} value={l.id}>
                {l.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <Button onClick={handleGenerateReport} disabled={loading}>
        {loading ? 'Generating...' : 'Download Report'}
      </Button>
    </div>
  )
}
