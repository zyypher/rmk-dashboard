import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: NextRequest) {
    try {
        const { searchParams } = new URL(req.url)
        const page = parseInt(searchParams.get('page') || '1', 10)
        const pageSize = parseInt(searchParams.get('pageSize') || '10', 10)

        const [leaves, totalCount] = await Promise.all([
            prisma.trainerLeave.findMany({
                skip: (page - 1) * pageSize,
                take: pageSize,
                include: { trainer: true },
                orderBy: { startDate: 'desc' },
            }),
            prisma.trainerLeave.count(),
        ])

        const totalPages = Math.ceil(totalCount / pageSize)

        return NextResponse.json({ leaves, totalPages })
    } catch {
        return NextResponse.json(
            { error: 'Failed to fetch leaves' },
            { status: 500 },
        )
    }
}

export async function POST(req: NextRequest) {
    try {
        const { trainerId, startDate, endDate, reason } = await req.json()

        if (!trainerId || !startDate || !endDate) {
            return NextResponse.json(
                { error: 'Trainer ID and Date are required' },
                { status: 400 },
            )
        }

        const leave = await prisma.trainerLeave.create({
            data: {
                trainerId,
                startDate: new Date(startDate),
                endDate: new Date(endDate),
                reason,
            },
        })

        return NextResponse.json(leave, { status: 201 })
    } catch (error) {
        console.error('POST /api/trainer-leaves error:', error)
        return NextResponse.json(
            { error: 'Failed to create trainer leave' },
            { status: 500 },
        )
    }
}
