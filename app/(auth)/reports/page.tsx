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
import { DatePicker } from '@/components/ui/DatePicker'
import { RefreshCw } from 'lucide-react'
import toast from 'react-hot-toast'

function Skeleton({ className }: { className?: string }) {
  return <div className={`animate-pulse bg-gray-500 rounded ${className}`} />
}

export default function MonthlyReportPage() {
  const [filters, setFilters] = useState({
    clientName: '',
    delegateName: '',
    clientPhone: '',
    dateFrom: null as Date | null,
    dateTo: null as Date | null,
    courseId: '',
    locationIds: [] as string[],
  })

  const [loading, setLoading] = useState(false)
  const [dropdownLoading, setDropdownLoading] = useState(true)
  const [courses, setCourses] = useState<Course[]>([])
  const [locations, setLocations] = useState<Location[]>([])
  const [clients, setClients] = useState<{ id: string, name: string }[]>([])

  useEffect(() => {
    const fetchDropdowns = async () => {
      setDropdownLoading(true)
      const [courseRes, locationRes, clientRes] = await Promise.all([
        axios.get('/api/courses'),
        axios.get('/api/locations'),
        axios.get('/api/clients?paginated=false'),
      ])
      setCourses(courseRes.data.courses)
      setLocations(locationRes.data.locations)
      setClients(clientRes.data.clients)
      setDropdownLoading(false)
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
        params: {
          ...filters,
          dateFrom: filters.dateFrom ? filters.dateFrom.toISOString().split('T')[0] : '',
          dateTo: filters.dateTo ? filters.dateTo.toISOString().split('T')[0] : '',
          locationIds: filters.locationIds.join(','),
        },
        validateStatus: (status) => status >= 200 && status < 300 || status === 204,
      })
      if (res.status === 204 || !res.data || res.data.length === 0) {
        toast.error('No data found for the selected filters.')
        return
      }
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

  const handleLocationSelect = (val: string) => {
    setFilters((prev) => {
      const alreadySelected = prev.locationIds.includes(val)
      return {
        ...prev,
        locationIds: alreadySelected
          ? prev.locationIds.filter((id) => id !== val)
          : [...prev.locationIds, val],
      }
    })
  }

  const handleClearFilters = () => {
    setFilters({
      clientName: '',
      delegateName: '',
      clientPhone: '',
      dateFrom: null,
      dateTo: null,
      courseId: '',
      locationIds: [],
    })
  }

  return (
    <div className="space-y-6 p-6">
      <h1 className="text-2xl font-semibold">Monthly Report</h1>
      <div className="flex justify-between items-center mb-2">
        <div />
        <Button variant="outline" size="small" onClick={handleClearFilters} title="Clear Filters">
          <RefreshCw className="w-5 h-5" />
        </Button>
      </div>
      {dropdownLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {[...Array(6)].map((_, i) => (
            <div key={i}>
              <Skeleton className="h-5 w-32 mb-2" />
              <Skeleton className="h-10 w-full" />
            </div>
          ))}
          <div className="md:col-span-3">
            <Skeleton className="h-5 w-32 mb-2" />
            <div className="flex flex-wrap gap-2 min-h-[40px] w-full">
              {[...Array(10)].map((_, i) => (
                <Skeleton key={i} className="h-8 w-40" />
              ))}
            </div>
          </div>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <div className="mb-1 text-sm font-medium text-gray-700">Client Name</div>
            <Select
              onValueChange={(val) => setFilters((prev) => ({ ...prev, clientName: val }))}
              value={filters.clientName}
            >
              <SelectTrigger>
                <SelectValue placeholder="Select Client" />
              </SelectTrigger>
              <SelectContent>
                {clients.map((c) => (
                  <SelectItem key={c.id} value={c.name}>
                    {c.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div>
            <div className="mb-1 text-sm font-medium text-gray-700">Delegate Name</div>
            <Input placeholder="Delegate Name" name="delegateName" onChange={handleChange} value={filters.delegateName} />
          </div>
          <div>
            <div className="mb-1 text-sm font-medium text-gray-700">Client Phone</div>
            <Input placeholder="Client Phone" name="clientPhone" onChange={handleChange} value={filters.clientPhone} />
          </div>
          <div>
            <div className="mb-1 text-sm font-medium text-gray-700">Date From</div>
            <DatePicker
              date={filters.dateFrom}
              onChange={(val) => setFilters((prev) => ({ ...prev, dateFrom: val }))}
              placeholderText="Date From"
            />
          </div>
          <div>
            <div className="mb-1 text-sm font-medium text-gray-700">Date To</div>
            <DatePicker
              date={filters.dateTo}
              onChange={(val) => setFilters((prev) => ({ ...prev, dateTo: val }))}
              placeholderText="Date To"
            />
          </div>
          <div>
            <div className="mb-1 text-sm font-medium text-gray-700">Course</div>
            <Select
              onValueChange={(val) => setFilters((prev) => ({ ...prev, courseId: val }))}
              value={filters.courseId}
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
          </div>
          <div className="md:col-span-3">
            <div className="mb-1 text-sm font-medium text-gray-700">Locations</div>
            <div className="border rounded-md p-2 flex flex-wrap gap-2 min-h-[40px] w-full">
              {locations.map((l) => (
                <button
                  key={l.id}
                  type="button"
                  className={`px-2 py-1 rounded border border-gray-300 ${filters.locationIds.includes(l.id) ? 'bg-blue-500 text-white border-blue-500' : 'bg-gray-100 text-gray-800'}`}
                  onClick={() => handleLocationSelect(l.id)}
                >
                  {l.name}
                </button>
              ))}
            </div>
          </div>
        </div>
      )}
      <Button onClick={handleGenerateReport} disabled={loading || dropdownLoading}>
        {loading ? 'Generating...' : 'Download Report'}
      </Button>
    </div>
  )
}
