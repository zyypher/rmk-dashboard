import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: NextRequest) {
    try {
        const { searchParams } = new URL(req.url)
        const page = parseInt(searchParams.get('page') || '1', 10)
        const pageSize = parseInt(searchParams.get('pageSize') || '10', 10)

        const [locations, totalCount] = await Promise.all([
            prisma.location.findMany({
                skip: (page - 1) * pageSize,
                take: pageSize,
                orderBy: {
                    createdAt: 'desc',
                },
            }),
            prisma.location.count(),
        ])

        const totalPages = Math.ceil(totalCount / pageSize)

        return NextResponse.json({ locations, totalPages })
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to fetch locations' },
            { status: 500 },
        )
    }
}

export async function POST(req: NextRequest) {
    try {
        const data = await req.json()
        const { name, emirate, deliveryApproach, zoomLink, locationType, backgroundColor, textColor } = data

        const location = await prisma.location.create({
            data: {
                name,
                emirate,
                deliveryApproach,
                zoomLink,
                locationType,
                backgroundColor,
                textColor,
            },
        })
        return NextResponse.json(location, { status: 201 })
    } catch (error) {
        console.error(error)
        return NextResponse.json(
            { error: 'Failed to create location' },
            { status: 500 },
        )
    }
}
