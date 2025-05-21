'use client'

import React, { useEffect, useState } from 'react'
import FullCalendar from '@fullcalendar/react'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import dayjs from 'dayjs'
import { Skeleton } from '@/components/ui/skeleton'
import { Booking } from '@/types/booking'
import { Tooltip as ReactTooltip } from 'react-tooltip'
import 'react-tooltip/dist/react-tooltip.css'
import timeGridPlugin from '@fullcalendar/timegrid'

export default function CalendarPage() {
    const [bookings, setBookings] = useState<Booking[]>([])
    const [loading, setLoading] = useState(true)

    useEffect(() => {
        const fetchBookings = async () => {
            try {
                const res = await fetch('/api/bookings')
                const data = await res.json()
                setBookings(Array.isArray(data) ? data : [])
            } catch (error) {
                console.error('Error fetching bookings:', error)
            } finally {
                setLoading(false)
            }
        }

        fetchBookings()
    }, [])

    const formatTime = (start: string, end: string) => {
        if (!start || !end) return 'N/A'
        const formattedStart = dayjs(start).format('hh:mm A')
        const formattedEnd = dayjs(end).format('hh:mm A')
        return `${formattedStart} - ${formattedEnd}`
    }

    if (!Array.isArray(bookings)) return null

    const events = bookings.map((b) => {
        const confirmed =
            b.delegates?.filter((d) => d.status === 'CONFIRMED')?.length || 0
        const notConfirmed =
            b.delegates?.filter((d) => d.status === 'NOT_CONFIRMED')?.length ||
            0
        const capacity = (b.room as any)?.capacity || 0
        const free = capacity - (confirmed + notConfirmed)

        const tooltipId = `tooltip-${b.id}`
        const tooltipHTML = `
      <div style='font-weight: bold;'>${b.course?.shortname || b.course?.title} - ${(b.room as any)?.name || ''}</div>
      <div><span style='color:#4B5563;'>Language:</span> ${b.language}</div>
      <div><span style='color:#4B5563;'>Trainer:</span> ${b.trainer?.name}</div>
      <div><span style='color:#4B5563;'>Location:</span> ${b.location?.name}</div>
      <div><span style='color:#4B5563;'>Room:</span> ${(b.room as any)?.name}</div>
      <div><span style='color:#4B5563;'>Category:</span> ${b.course?.category?.name}</div>
      <div><span style='color:#4B5563;'>Time:</span> ${formatTime(b.startTime, b.endTime)}</div>
      <div style='margin-top:5px;'>
        <span style='background:#D1FAE5;color:#065F46;padding:2px 5px;border-radius:4px;'>Confirmed: ${confirmed}</span>
        <span style='background:#FEE2E2;color:#991B1B;padding:2px 5px;border-radius:4px;margin-left:4px;'>Not Confirmed: ${notConfirmed}</span>
        <span style='background:#DBEAFE;color:#1E40AF;padding:2px 5px;border-radius:4px;margin-left:4px;'>Free: ${free}</span>
      </div>
    `

        return {
            id: b.id,
            title: `${b.course?.shortname || b.course?.title} - ${(b.room as any)?.name || ''}`,
            start: dayjs(b.date)
                .hour(dayjs(b.startTime).hour())
                .minute(dayjs(b.startTime).minute())
                .toISOString(),
            end: dayjs(b.date)
                .hour(dayjs(b.endTime).hour())
                .minute(dayjs(b.endTime).minute())
                .toISOString(),
            extendedProps: {
                tooltipId,
                tooltipHTML,
            },
        }
    })

    if (loading) {
        return (
            <div className="animate-pulse p-6">
                <h1 className="mb-4 text-2xl font-bold">
                    Training Calendar Overview
                </h1>
                <div className="grid grid-cols-7 gap-2">
                    {[...Array(35)].map((_, i) => (
                        <Skeleton key={i} className="h-28 w-full rounded-md" />
                    ))}
                </div>
            </div>
        )
    }

    return (
        <div className="relative p-6">
            <h1 className="mb-4 text-2xl font-bold">
                Training Calendar Overview
            </h1>

            <FullCalendar
                plugins={[dayGridPlugin, timeGridPlugin, interactionPlugin]}
                initialView="dayGridMonth"
                headerToolbar={{
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay',
                }}
                events={events}
                height="auto"
                dayMaxEvents={4} // 👈 show up to 4 items per day
                eventContent={(arg) => (
                    <div
                        data-tooltip-id={arg.event.extendedProps.tooltipId}
                        data-tooltip-html={arg.event.extendedProps.tooltipHTML}
                    >
                        <div className="rounded bg-blue-100 p-1 text-xs text-blue-900 shadow-sm">
                            <div className="font-semibold">
                                {arg.event.title}
                            </div>
                        </div>
                        <ReactTooltip
                            id={arg.event.extendedProps.tooltipId}
                            place="top"
                            className="z-[9999] !border !border-gray-200 !bg-white !text-gray-900 !shadow-lg"
                            style={{
                                padding: '10px',
                                maxWidth: '280px',
                                fontSize: '12px',
                                lineHeight: '1.5',
                            }}
                        />
                    </div>
                )}
            />
        </div>
    )
}
