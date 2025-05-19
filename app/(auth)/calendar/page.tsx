'use client'

import React, { useEffect, useState } from 'react'
import FullCalendar from '@fullcalendar/react'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import dayjs from 'dayjs'
import { Skeleton } from '@/components/ui/skeleton'

interface Booking {
    id: string
    date: string
    startTime: string
    endTime: string
    language: string
    notes?: string
    course: { title: string; shortname?: string }
    trainer?: { name: string }
    location?: { name: string }
    room?: { name: string }
}

export default function CalendarPage() {
    const [bookings, setBookings] = useState<Booking[]>([])
    const [loading, setLoading] = useState(true)
    const [hoveredEvent, setHoveredEvent] = useState<any>(null)

    useEffect(() => {
        const fetchBookings = async () => {
            try {
                const res = await fetch('/api/bookings')
                const data = await res.json()
                setBookings(data)
            } catch (error) {
                console.error('Error fetching bookings:', error)
            } finally {
                setLoading(false)
            }
        }

        fetchBookings()
    }, [])

    const formatTime = (start: string, end: string) => {
        const formattedStart = dayjs(start).format('hh:mm A')
        const formattedEnd = dayjs(end).format('hh:mm A')
        return `${formattedStart} - ${formattedEnd}`
    }

    const events = bookings.map((b) => ({
        id: b.id,
        title: b.course?.shortname || b.course?.title || 'Training',
        start: b.date,
        extendedProps: {
            language: b.language,
            trainer: b.trainer?.name,
            location: b.location?.name,
            room: b.room?.name,
            timeRange: formatTime(b.startTime, b.endTime),
            fullTitle: b.course?.title,
        },
    }))

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

            <>
                <FullCalendar
                    plugins={[dayGridPlugin, interactionPlugin]}
                    initialView="dayGridMonth"
                    headerToolbar={{
                        left: 'prev,next today',
                        center: 'title',
                        right: '',
                    }}
                    events={events}
                    height="auto"
                    eventMouseEnter={(info) => {
                      const rect = info.el.getBoundingClientRect()
                      const tooltipHeight = 140
                      const tooltipWidth = 250
                    
                      const spaceBelow = window.innerHeight - rect.bottom
                      const spaceAbove = rect.top
                      const spaceRight = window.innerWidth - rect.right
                    
                      const preferAbove = spaceBelow < tooltipHeight && spaceAbove > tooltipHeight
                      const preferLeft = spaceRight < tooltipWidth
                    
                      const top = preferAbove
                        ? rect.top + window.scrollY - tooltipHeight - 6
                        : rect.bottom + window.scrollY + 6
                    
                      const left = preferLeft
                        ? rect.right + window.scrollX - tooltipWidth
                        : rect.left + window.scrollX
                    
                      setHoveredEvent({
                        title: info.event.title,
                        language: info.event.extendedProps.language,
                        trainer: info.event.extendedProps.trainer,
                        location: info.event.extendedProps.location,
                        room: info.event.extendedProps.room,
                        time: formatTime(
                          info.event.extendedProps.startTime,
                          info.event.extendedProps.endTime
                        ),
                        x: left,
                        y: top,
                      })
                    }}
                    eventMouseLeave={() => setHoveredEvent(null)}
                    eventContent={(arg) => (
                        <div className="rounded bg-blue-100 p-1 text-xs text-blue-900 shadow-sm">
                            <div className="font-semibold">
                                {arg.event.title}
                            </div>
                            {arg.event.extendedProps.language && (
                                <div>
                                    Lang: {arg.event.extendedProps.language}
                                </div>
                            )}
                            {arg.event.extendedProps.trainer && (
                                <div>
                                    Trainer: {arg.event.extendedProps.trainer}
                                </div>
                            )}
                            {arg.event.extendedProps.room && (
                                <div>Room: {arg.event.extendedProps.room}</div>
                            )}
                        </div>
                    )}
                />

                {hoveredEvent && (
                    <div
                        className="fixed z-[9999] rounded-md bg-white p-3 text-sm shadow-md"
                        style={{
                            top: hoveredEvent.y,
                            left: hoveredEvent.x,
                            maxWidth: '250px',
                        }}
                    >
                        <div className="font-bold">{hoveredEvent.title}</div>
                        <div>Language: {hoveredEvent.language}</div>
                        <div>Trainer: {hoveredEvent.trainer}</div>
                        <div>Location: {hoveredEvent.location}</div>
                        <div>Room: {hoveredEvent.room}</div>
                        <div>Time: {hoveredEvent.time}</div>
                    </div>
                )}
            </>
        </div>
    )
}
