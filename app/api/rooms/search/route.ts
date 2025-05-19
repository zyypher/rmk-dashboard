import { prisma } from '@/lib/prisma'
import { NextRequest, NextResponse } from 'next/server'

export async function GET(req: NextRequest) {
    try {
        const { searchParams } = new URL(req.url)
        const q = searchParams.get('q') || ''

        const rooms = await prisma.room.findMany({
            where: {
                OR: [
                    { name: { contains: q, mode: 'insensitive' } },
                    { notes: { contains: q, mode: 'insensitive' } },
                    {
                        location: {
                            name: { contains: q, mode: 'insensitive' },
                        },
                    },
                ],
            },
            include: { location: true },
            orderBy: { createdAt: 'desc' },
        })

        return NextResponse.json(rooms)
    } catch (error) {
        return NextResponse.json({ error: 'Search failed' }, { status: 500 })
    }
}
