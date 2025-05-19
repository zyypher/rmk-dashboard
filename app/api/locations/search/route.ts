import { prisma } from '@/lib/prisma'
import { NextRequest, NextResponse } from 'next/server'

export async function GET(req: NextRequest) {
    try {
        const { searchParams } = new URL(req.url)
        const q = searchParams.get('q') || ''

        const results = await prisma.location.findMany({
            where: {
                OR: [
                    {
                        name: {
                            contains: q,
                            mode: 'insensitive',
                        },
                    },
                    {
                        emirate: {
                            contains: q,
                            mode: 'insensitive',
                        },
                    },
                ],
            },
            orderBy: {
                createdAt: 'desc',
            },
        })

        return NextResponse.json(results)
    } catch (error) {
        console.error('Search failed', error)
        return NextResponse.json(
            { error: 'Failed to search locations' },
            { status: 500 },
        )
    }
}
