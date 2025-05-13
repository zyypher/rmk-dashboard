import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET() {
    try {
        const rooms = await prisma.room.findMany({
            include: { location: true },
            orderBy: {
                createdAt: 'desc',
            },
        })
        return NextResponse.json(rooms)
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
