// Final polished Home.tsx combining real API data with your original beautiful layout

'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import PageHeading from '@/components/layout/page-heading'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover'
import {
  ArrowRight,
  CalendarCheck,
  ChevronDown,
  Download,
  Ellipsis,
  TrendingDown,
  TrendingUp,
} from 'lucide-react'
import Image from 'next/image'
import { format } from 'date-fns'
import { Calendar } from '@/components/ui/calendar'
import IconChart from '@/components/icons/icon-chart'
import IconGoalFlag from '@/components/icons/icon-goal-flag'
import IconTrophy from '@/components/icons/icon-trophy'
import IconFile from '@/components/icons/icon-file'
import { RadarAreaChart } from '@/components/custom/charts/radar-area-chart'
import { Skeleton } from '@/components/ui/skeleton'

export default function Home() {
  const [data, setData] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [date, setDate] = useState<Date>()
  const [mainDate, setMainDate] = useState<Date>()

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await axios.get('/api/dashboard/overview')
        setData(res.data)
      } catch {
        setData(null)
      } finally {
        setLoading(false)
      }
    }
    fetchData()
  }, [])

  return (
    <div className="relative space-y-4">
      <PageHeading heading={'Dashboard'} />
      <span className="absolute -left-4 -right-4 -top-8 -z-[1]">
        <Image
          src="/images/home-bg.png"
          width={1180}
          height={200}
          alt="home-bg"
          className="h-52 w-full xl:h-auto"
        />
      </span>

      <div className="min-h-[calc(100vh_-_160px)] w-full">
        <div className="flex flex-col gap-4 font-semibold xl:flex-row">
          <Card className="col-span-3 w-full grow shadow-none">
            <CardContent className="flex h-full grow flex-col">
              <div className="flex grow flex-col gap-5 p-5 sm:flex-row sm:justify-between">
                <div className="shrink-0 space-y-5 sm:space-y-12">
                  <div className="space-y-5">
                    <h2 className="text-base/5 text-black">Sales Overview</h2>
                    <p className="!mt-1.5 text-xs/tight font-medium">
                      10 March 2024 - 10 April 2024
                    </p>
                    <div className="inline-flex items-center gap-1 rounded-lg border border-gray-300 px-2.5 py-2 text-xs/tight text-black">
                      <CalendarCheck className="size-4 shrink-0" />
                      <Popover>
                        <PopoverTrigger>
                          {date ? format(date, 'PP') : <span>10 Mar, 2024</span>}
                        </PopoverTrigger>
                        <PopoverContent className="!w-auto p-0">
                          <Calendar mode="single" selected={date} onSelect={setDate} initialFocus />
                        </PopoverContent>
                      </Popover>
                      <span>-</span>
                      <Popover>
                        <PopoverTrigger>
                          {mainDate ? format(mainDate, 'PP') : <span>10 Apr, 2024</span>}
                        </PopoverTrigger>
                        <PopoverContent className="!w-auto p-0">
                          <Calendar mode="single" selected={mainDate} onSelect={setMainDate} initialFocus />
                        </PopoverContent>
                      </Popover>
                    </div>
                  </div>

                  <div className="space-y-4 rounded-lg bg-gray-200 p-5">
                    <h3 className="text-[26px]/8 text-black">
                      {loading ? '$...' : `$${data?.totalSessions * 250 || 0}`}
                    </h3>
                    <div className="flex items-center gap-2.5">
                      <Badge variant={'green'} size={'small'} className="rounded-lg font-semibold">
                        <TrendingUp /> 15.15%
                      </Badge>
                      <span className="text-xs/tight">+ $150.48 Increased</span>
                    </div>
                  </div>
                </div>
                <div className="m-auto grow">
                  <RadarAreaChart
                    cardContentClassName="max-h-[354px]"
                    isShowTitle={false}
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 divide-x divide-y divide-gray-300 border-t border-gray-300 sm:grid-cols-4 sm:divide-y-0">
                <div className="space-y-5 bg-gradient-to-b from-success/[2%] to-success/0 px-4 py-6 sm:px-[18px] sm:py-8">
                  <IconChart />
                  <p className="leading-tight">Total Sessions</p>
                  <p className="!mt-3 text-xl/6 text-black">{loading ? '...' : data?.totalSessions}</p>
                </div>
                <div className="space-y-5 !border-t-0 bg-gradient-to-b from-danger/[2%] to-danger/0 px-4 py-6 sm:px-[18px] sm:py-8">
                  <IconGoalFlag />
                  <p className="leading-tight">Upcoming Sessions</p>
                  <p className="!mt-3 text-xl/6 text-black">{loading ? '...' : data?.upcomingSessions}</p>
                </div>
                <div className="space-y-5 bg-gradient-to-b from-warning/[2%] to-warning/0 px-4 py-6 sm:px-[18px] sm:py-8">
                  <IconTrophy />
                  <p className="leading-tight">Certificates Issued</p>
                  <p className="!mt-3 text-xl/6 text-black">{loading ? '...' : data?.certificatesIssued}</p>
                </div>
                <div className="space-y-5 bg-gradient-to-b from-primary/[2%] to-primary/0 px-4 py-6 sm:px-[18px] sm:py-8">
                  <IconFile />
                  <p className="leading-tight">Clients</p>
                  <p className="!mt-3 text-xl/6 text-black">{loading ? '...' : data?.clientCount}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Top Courses Section */}
        {!loading && (
          <div className="mt-8">
            <Card>
              <CardHeader>
                <h2 className="text-lg font-semibold text-black">Top Courses</h2>
              </CardHeader>
              <CardContent className="space-y-2">
                {data?.topCourses?.map((course: any) => (
                  <div key={course.id} className="flex items-center justify-between">
                    <span>{course.title}</span>
                    <Badge size="small">{course.count}</Badge>
                  </div>
                ))}
                {data?.topCourses?.length === 0 && <p className="text-sm text-muted">No course data</p>}
              </CardContent>
            </Card>
          </div>
        )}
      </div>
    </div>
  )
}