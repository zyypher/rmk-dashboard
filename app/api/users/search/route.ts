import { prisma } from '@/lib/prisma'
import { NextRequest, NextResponse } from 'next/server'

export async function GET(req: NextRequest) {
    try {
        const { searchParams } = new URL(req.url)
        const q = searchParams.get('q')?.trim().toLowerCase() || ''

        const results = await prisma.user.findMany({
            where: {
                OR: [
                    {
                        email: {
                            contains: q,
                            mode: 'insensitive',
                        },
                    },
                    // Role must match exactly, so check against valid enum values
                    ...(q === 'admin' || q === 'editor' || q === 'viewer'
                        ? [{ role: q.toUpperCase() as any }]
                        : []),
                ],
            },
            orderBy: {
                createdAt: 'desc',
            },
        })

        return NextResponse.json(results)
    } catch (error) {
        console.error('Search failed:', error)
        return NextResponse.json(
            { error: 'Failed to search users' },
            { status: 500 },
        )
    }
}
