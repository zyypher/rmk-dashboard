import { prisma } from '@/lib/prisma'
import { NextRequest, NextResponse } from 'next/server'

export async function GET(req: NextRequest) {
    try {
        const { searchParams } = new URL(req.url)
        const q = searchParams.get('q') || ''

        const results = await prisma.trainingSession.findMany({
            where: {
                OR: [
                    {
                        course: {
                            title: { contains: q, mode: 'insensitive' },
                        },
                    },
                    {
                        trainer: {
                            name: { contains: q, mode: 'insensitive' },
                        },
                    },
                    {
                        room: {
                            name: { contains: q, mode: 'insensitive' },
                        },
                    },
                    {
                        language: {
                            contains: q,
                            mode: 'insensitive',
                        },
                    },
                    {
                        notes: {
                            contains: q,
                            mode: 'insensitive',
                        },
                    },
                    {
                        delegates: {
                            some: {
                                OR: [
                                    { name: { contains: q, mode: 'insensitive' } },
                                    { emiratesId: { contains: q, mode: 'insensitive' } },
                                    { phone: { contains: q, mode: 'insensitive' } },
                                    { email: { contains: q, mode: 'insensitive' } },
                                    { client: { name: { contains: q, mode: 'insensitive' } } },
                                    { client: { phone: { contains: q, mode: 'insensitive' } } },
                                    { client: { email: { contains: q, mode: 'insensitive' } } },
                                ],
                            },
                        },
                    },
                ],
            },
            include: {
                course: true,
                trainer: true,
                room: true,
                location: true,
                delegates: {
                    include: {
                        client: true,
                    },
                },
            },
            orderBy: { createdAt: 'desc' },
        })

        return NextResponse.json(results)
    } catch (error) {
        console.error('Search failed', error)
        return NextResponse.json(
            { error: 'Failed to search bookings' },
            { status: 500 },
        )
    }
}
