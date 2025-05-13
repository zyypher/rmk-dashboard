import { NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET() {
  try {
    const [
      totalSessions,
      upcomingSessions,
      trainerCount,
      clientCount,
      roomCount,
      courseCount,
      categoryCount,
      bookings,
    ] = await Promise.all([
      prisma.trainingSession.count(),
      prisma.trainingSession.count({ where: { date: { gt: new Date() } } }),
      prisma.trainer.count(),
      prisma.client.count(),
      prisma.room.count(),
      prisma.course.count(),
      prisma.category.count(),
      prisma.trainingSession.findMany({
        select: { createdAt: true },
        orderBy: { createdAt: 'desc' },
      }),
    ])

    const bookingsPerDay = bookings.reduce<Record<string, number>>((acc, session) => {
      const day = session.createdAt.toISOString().split('T')[0]
      acc[day] = (acc[day] || 0) + 1
      return acc
    }, {})

    const bookingStats = Object.entries(bookingsPerDay).map(([date, count]) => ({
      date,
      count,
    }))

    return NextResponse.json({
      totalSessions,
      upcomingSessions,
      trainerCount,
      clientCount,
      roomCount,
      courseCount,
      categoryCount,
      bookingStats,
    })
  } catch (error) {
    console.error('[DASHBOARD_OVERVIEW_ERROR]', error)
    return NextResponse.json({ error: 'Dashboard data fetch failed.' }, { status: 500 })
  }
}
