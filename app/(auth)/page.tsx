'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import PageHeading from '@/components/layout/page-heading'
import { Card, CardContent } from '@/components/ui/card'
import IconChart from '@/components/icons/icon-chart'
import IconGoalFlag from '@/components/icons/icon-goal-flag'
import IconTrophy from '@/components/icons/icon-trophy'
import IconFile from '@/components/icons/icon-file'
import IconSolana from '@/components/icons/icon-solana'
import IconGreaterthan from '@/components/icons/icon-greaterthan'
import BookingsSplineAreaChart from '@/components/charts/BookingsSplineAreaChart'
import { format } from 'date-fns'
import { Skeleton } from '@/components/ui/skeleton'

export default function Home() {
    const [data, setData] = useState<any>(null)
    const [loading, setLoading] = useState(true)

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
            <PageHeading heading="Dashboard" />

            <div className="min-h-[calc(100vh_-_160px)] w-full">
                <Card className="shadow-none">
                    <CardContent className="p-5">
                        <h2 className="mb-4 text-base font-semibold text-black">
                            Bookings Overview
                        </h2>
                        {loading ? (
                            <div className="h-[300px] w-full rounded-md bg-gray-100">
                                <Skeleton className="h-full w-full" />
                            </div>
                        ) : (
                            <BookingsSplineAreaChart
                                data={{
                                    labels:
                                        data?.bookingStats?.map((item: any) =>
                                            format(
                                                new Date(item.date),
                                                'MMM d',
                                            ),
                                        ) || [],
                                    values:
                                        data?.bookingStats?.map(
                                            (item: any) => item.count,
                                        ) || [],
                                }}
                            />
                        )}
                    </CardContent>
                </Card>

                <div className="mt-6 grid grid-cols-2 gap-4 sm:grid-cols-4">
                    <SummaryCard
                        icon={<IconChart />}
                        label="Total Bookings"
                        value={data?.totalSessions}
                        loading={loading}
                        iconColor="text-green-600"
                    />
                    <SummaryCard
                        icon={<IconGoalFlag />}
                        label="Upcoming Bookings"
                        value={data?.upcomingSessions}
                        loading={loading}
                        iconColor="text-red-600"
                    />
                    <SummaryCard
                        icon={<IconTrophy />}
                        label="Certificates Issued"
                        value={data?.certificatesIssued}
                        loading={loading}
                        iconColor="text-yellow-500"
                    />
                    <SummaryCard
                        icon={<IconFile />}
                        label="Clients"
                        value={data?.clientCount}
                        loading={loading}
                        iconColor="text-blue-500"
                    />
                    <SummaryCard
                        icon={<IconTrophy />}
                        label="Courses"
                        value={data?.courseCount}
                        loading={loading}
                        iconColor="text-indigo-500"
                    />
                    <SummaryCard
                        icon={<IconGreaterthan />}
                        label="Categories"
                        value={data?.categoryCount}
                        loading={loading}
                        iconColor="text-pink-500"
                    />
                    <SummaryCard
                        icon={<IconSolana />}
                        label="Rooms"
                        value={data?.roomCount}
                        loading={loading}
                        iconColor="text-cyan-500"
                    />
                    <SummaryCard
                        icon={<IconGreaterthan />}
                        label="Trainers"
                        value={data?.trainerCount}
                        loading={loading}
                        iconColor="text-purple-500"
                    />
                </div>
            </div>
        </div>
    )
}

const SummaryCard = ({
    icon,
    label,
    value,
    loading,
    iconColor,
}: {
    icon: React.ReactNode
    label: string
    value: number
    loading: boolean
    iconColor: string
}) => (
    <div className="flex flex-col justify-between rounded-xl border border-gray-200 bg-white p-5 shadow-sm">
        <div className={`text-2xl ${iconColor}`}>{icon}</div>
        <p className="text-muted-foreground mt-2 text-sm">{label}</p>
        <p className="text-xl font-semibold text-black">
            {loading ? '...' : value}
        </p>
    </div>
)
