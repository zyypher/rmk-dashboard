import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: NextRequest) {
    try {
        const { searchParams } = new URL(req.url)
        const page = parseInt(searchParams.get('page') || '1', 10)
        const pageSize = parseInt(searchParams.get('pageSize') || '10', 10)

        const [delegates, totalCount] = await Promise.all([
            prisma.delegate.findMany({
                skip: (page - 1) * pageSize,
                take: pageSize,
                orderBy: { createdAt: 'desc' },
                include: {
                    client: true,
                    session: {
                        include: {
                            course: true,
                            trainer: true,
                            room: true,
                            location: true,
                        },
                    },
                },
            }),
            prisma.delegate.count(),
        ])

        const totalPages = Math.ceil(totalCount / pageSize)

        return NextResponse.json({ delegates, totalPages })
    } catch (error) {
        console.error('GET /api/delegates error:', error)
        return NextResponse.json(
            { error: 'Failed to fetch delegates' },
            { status: 500 },
        )
    }
}

export async function POST(req: NextRequest) {
    try {
        const data = await req.json()
        const delegate = await prisma.delegate.create({ data })
        return NextResponse.json(delegate, { status: 201 })
    } catch (error) {
        console.error('POST /api/delegates error:', error)
        return NextResponse.json(
            { error: 'Failed to create delegate' },
            { status: 500 },
        )
    }
}
