import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: NextRequest) {
    try {
        const { searchParams } = new URL(req.url)
        const page = parseInt(searchParams.get('page') || '1', 10)
        const pageSize = parseInt(searchParams.get('pageSize') || '10', 10)

        const [rooms, totalCount] = await Promise.all([
            prisma.room.findMany({
                skip: (page - 1) * pageSize,
                take: pageSize,
                include: { location: true },
                orderBy: {
                    createdAt: 'desc',
                },
            }),
            prisma.room.count(),
        ])

        const totalPages = Math.ceil(totalCount / pageSize)

        return NextResponse.json({ rooms, totalPages })
    } catch (error) {
        console.error('GET /api/rooms error:', error)
        return NextResponse.json(
            { error: 'Failed to fetch rooms' },
            { status: 500 },
        )
    }
}

export async function POST(req: NextRequest) {
    try {
        const body = await req.json()
        const room = await prisma.room.create({
            data: body,
        })
        return NextResponse.json(room, { status: 201 })
    } catch (error) {
        console.error('POST /api/rooms error:', error)
        return NextResponse.json(
            { error: 'Failed to create room' },
            { status: 500 },
        )
    }
}
