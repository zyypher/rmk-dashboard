'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { saveAs } from 'file-saver'
import * as XLSX from 'xlsx'
import { Course } from '@/types/course'
import { Location } from '@/types/location'
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select'
import { DatePicker } from '@/components/ui/DatePicker'
import { RefreshCw } from 'lucide-react'
import toast from 'react-hot-toast'

function Skeleton({ className }: { className?: string }) {
    return <div className={`animate-pulse rounded bg-gray-500 ${className}`} />
}

// ---- helper: send Y-M-D in business TZ to avoid UTC shifting ----
const toYMD = (d: Date | null) =>
    d
        ? new Intl.DateTimeFormat('en-CA', {
              timeZone: 'Asia/Dubai',
              year: 'numeric',
              month: '2-digit',
              day: '2-digit',
          }).format(d)
        : ''

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
    const [clients, setClients] = useState<{ id: string; name: string }[]>([])

    useEffect(() => {
        const fetchDropdowns = async () => {
            setDropdownLoading(true)
            try {
                const [courseRes, locationRes, clientRes] = await Promise.all([
                    axios.get('/api/courses'),
                    axios.get('/api/locations'),
                    axios.get('/api/clients?paginated=false'),
                ])
                setCourses(courseRes.data.courses)
                setLocations(locationRes.data.locations)
                setClients(clientRes.data.clients)
            } catch (e) {
                console.error(e)
                toast.error('Failed to load filters')
            } finally {
                setDropdownLoading(false)
            }
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
                    dateFrom: toYMD(filters.dateFrom),
                    dateTo: toYMD(filters.dateTo),
                    locationIds: filters.locationIds.join(','),
                },
                validateStatus: (status) =>
                    (status >= 200 && status < 300) || status === 204,
            })

            if (res.status === 204 || !res.data || res.data.length === 0) {
                toast.error('No data found for the selected filters.')
                return
            }

            const worksheet = XLSX.utils.json_to_sheet(res.data)
            const workbook = XLSX.utils.book_new()
            XLSX.utils.book_append_sheet(workbook, worksheet, 'Monthly Report')
            const excelBuffer = XLSX.write(workbook, {
                bookType: 'xlsx',
                type: 'array',
            })
            const data = new Blob([excelBuffer], {
                type: 'application/octet-stream',
            })
            saveAs(data, 'monthly_report.xlsx')
        } catch (err) {
            console.error('Failed to generate report:', err)
            toast.error('Failed to generate report')
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
            <div className="mb-2 flex items-center justify-between">
                <div />
                <Button
                    variant="outline"
                    onClick={handleClearFilters}
                    title="Clear Filters"
                >
                    <RefreshCw className="h-5 w-5" />
                </Button>
            </div>

            {dropdownLoading ? (
                <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
                    {[...Array(6)].map((_, i) => (
                        <div key={i}>
                            <Skeleton className="mb-2 h-5 w-32" />
                            <Skeleton className="h-10 w-full" />
                        </div>
                    ))}
                    <div className="md:col-span-3">
                        <Skeleton className="mb-2 h-5 w-32" />
                        <div className="flex min-h-[40px] w-full flex-wrap gap-2">
                            {[...Array(10)].map((_, i) => (
                                <Skeleton key={i} className="h-8 w-40" />
                            ))}
                        </div>
                    </div>
                </div>
            ) : (
                <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
                    <div>
                        <div className="mb-1 text-sm font-medium text-gray-700">
                            Client Name
                        </div>
                        <Select
                            onValueChange={(val) =>
                                setFilters((prev) => ({
                                    ...prev,
                                    clientName: val,
                                }))
                            }
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
                        <div className="mb-1 text-sm font-medium text-gray-700">
                            Delegate Name
                        </div>
                        <Input
                            placeholder="Delegate Name"
                            name="delegateName"
                            onChange={handleChange}
                            value={filters.delegateName}
                        />
                    </div>

                    <div>
                        <div className="mb-1 text-sm font-medium text-gray-700">
                            Client Phone
                        </div>
                        <Input
                            placeholder="Client Phone"
                            name="clientPhone"
                            onChange={handleChange}
                            value={filters.clientPhone}
                        />
                    </div>

                    <div>
                        <div className="mb-1 text-sm font-medium text-gray-700">
                            Date From
                        </div>
                        <DatePicker
                            date={filters.dateFrom}
                            onChange={(val) =>
                                setFilters((prev) => ({
                                    ...prev,
                                    dateFrom: val,
                                }))
                            }
                            placeholderText="Date From"
                        />
                    </div>

                    <div>
                        <div className="mb-1 text-sm font-medium text-gray-700">
                            Date To
                        </div>
                        <DatePicker
                            date={filters.dateTo}
                            onChange={(val) =>
                                setFilters((prev) => ({ ...prev, dateTo: val }))
                            }
                            placeholderText="Date To"
                        />
                    </div>

                    <div>
                        <div className="mb-1 text-sm font-medium text-gray-700">
                            Course
                        </div>
                        <Select
                            onValueChange={(val) =>
                                setFilters((prev) => ({
                                    ...prev,
                                    courseId: val,
                                }))
                            }
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
                        <div className="mb-1 text-sm font-medium text-gray-700">
                            Locations
                        </div>
                        <div className="flex min-h-[40px] w-full flex-wrap gap-2 rounded-md border p-2">
                            {locations.map((l) => (
                                <button
                                    key={l.id}
                                    type="button"
                                    className={`rounded border border-gray-300 px-2 py-1 ${
                                        filters.locationIds.includes(l.id)
                                            ? 'border-blue-500 bg-blue-500 text-white'
                                            : 'bg-gray-100 text-gray-800'
                                    }`}
                                    onClick={() => handleLocationSelect(l.id)}
                                >
                                    {l.name}
                                </button>
                            ))}
                        </div>
                    </div>
                </div>
            )}

            <Button
                onClick={handleGenerateReport}
                disabled={loading || dropdownLoading}
            >
                {loading ? 'Generating...' : 'Download Report'}
            </Button>
        </div>
    )
}
