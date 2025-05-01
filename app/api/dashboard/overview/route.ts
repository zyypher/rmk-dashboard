import { NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'
import { subMonths, startOfMonth } from 'date-fns'

const prisma = new PrismaClient()

export async function GET() {
    try {
        const [
            totalSessions,
            upcomingSessions,
            certificatesIssued,
            trainerCount,
            clientCount,
            sessionsByStatus,
            topCourses,
            monthlyTrends,
        ] = await Promise.all([
            prisma.trainingSession.count(),
            prisma.trainingSession.count({
                where: { date: { gt: new Date() } },
            }),
            prisma.certificate.count(),
            prisma.trainer.count(),
            prisma.client.count(),
            prisma.trainingSession.groupBy({
                by: ['status'],
                _count: true,
            }),
            prisma.trainingSession.groupBy({
                by: ['courseId'],
                _count: true,
                orderBy: { _count: { courseId: 'desc' } },
                take: 5,
            }),
            prisma.trainingSession.findMany({
                where: {
                    date: {
                        gte: subMonths(startOfMonth(new Date()), 6),
                        lte: new Date(),
                    },
                },
                select: {
                    date: true,
                },
            }),
        ])

        const courseTitles: Record<string, string> = {}
        const courses = await prisma.course.findMany({
            where: {
                id: { in: topCourses.map((c) => c.courseId) },
            },
        })
        courses.forEach((c) => (courseTitles[c.id] = c.title))

        return NextResponse.json({
            totalSessions,
            upcomingSessions,
            certificatesIssued,
            trainerCount,
            clientCount,
            sessionsByStatus,
            topCourses: topCourses.map((c) => ({
                id: c.courseId,
                title: courseTitles[c.courseId],
                count: c._count,
            })),
            monthlyTrends,
        })
    } catch (error) {
        console.error('[DASHBOARD_OVERVIEW_ERROR]', error)
        return NextResponse.json(
            { error: 'Dashboard data fetch failed.' },
            { status: 500 },
        )
    }
}
