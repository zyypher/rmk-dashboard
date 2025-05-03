import { NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

export const dynamic = 'force-dynamic'

const prisma = new PrismaClient()

export async function GET() {
  try {
    const [
      totalSessions,
      upcomingSessions,
      certificatesIssued,
      trainerCount,
      clientCount,
      roomCount,
      courseCount,
      categoryCount,
      bookings,
    ] = await Promise.all([
      prisma.trainingSession.count(),
      prisma.trainingSession.count({ where: { date: { gt: new Date() } } }),
      prisma.certificate.count(),
      prisma.trainer.count(),
      prisma.client.count(),
      prisma.room.count(),
      prisma.course.count(),
      prisma.category.count(),
      prisma.trainingSession.findMany({
        select: { createdAt: true },
        orderBy: { createdAt: 'asc' },
      }),
    ])

    // Aggregate by createdAt date
    const bookingsPerDay = bookings.reduce((acc, session) => {
      const day = session.createdAt.toISOString().split('T')[0]
      acc[day] = (acc[day] || 0) + 1
      return acc
    }, {} as Record<string, number>)

    const bookingStats = Object.entries(bookingsPerDay).map(([date, count]) => ({
      date,
      count,
    }))

    return NextResponse.json({
      totalSessions,
      upcomingSessions,
      certificatesIssued,
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
