// /app/api/bookings/dropdowns/route.ts
import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: NextRequest) {
    try {
        const [courses, trainers, rooms, languages, categories, locations] = await Promise.all([
            prisma.course.findMany({
                orderBy: {
                    title: 'asc',
                },
            }),
            prisma.trainer.findMany({
                select: {
                    id: true,
                    name: true,
                },
                orderBy: {
                    name: 'asc',
                },
            }),
            prisma.room.findMany({
                include: {
                    location: true
                },
                orderBy: {
                    name: 'asc',
                },
            }),
            prisma.language.findMany({
                orderBy: {
                    name: 'asc',
                },
            }),
            prisma.category.findMany({
                orderBy: {
                    name: 'asc',
                },
            }),
            prisma.location.findMany({
                select: {
                    id: true,
                    name: true,
                    backgroundColor: true,
                    textColor: true,
                },
                orderBy: {
                    name: 'asc',
                },
            }),
        ])

        return NextResponse.json({
            courses,
            trainers,
            rooms,
            languages,
            categories,
            locations,
        })
    } catch (error) {
        return NextResponse.json({ error: 'Failed to fetch dropdown data' }, { status: 500 })
    }
}
