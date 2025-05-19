import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: NextRequest) {
    const { searchParams } = new URL(req.url)
    const q = searchParams.get('q')?.trim() || ''

    if (!q) {
        return NextResponse.json([], { status: 200 })
    }

    try {
        const trainers = await prisma.trainer.findMany({
            where: {
                OR: [
                    { name: { contains: q, mode: 'insensitive' } },
                    { email: { contains: q, mode: 'insensitive' } },
                    { phone: { contains: q, mode: 'insensitive' } },
                ],
            },
            include: {
                languages: true,
                courses: true,
            },
            orderBy: { createdAt: 'desc' },
        })

        return NextResponse.json(trainers)
    } catch (error) {
        console.error('❌ Error searching trainers:', error)
        return NextResponse.json(
            { error: 'Failed to search trainers' },
            { status: 500 }
        )
    }
}
