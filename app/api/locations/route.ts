import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET() {
    try {
        const locations = await prisma.location.findMany({
            orderBy: {
                createdAt: 'desc',
            },
        })
        return NextResponse.json(locations)
    } catch {
        return NextResponse.json(
            { error: 'Failed to fetch locations' },
            { status: 500 },
        )
    }
}

export async function POST(req: NextRequest) {
    try {
        const data = await req.json()
        const location = await prisma.location.create({ data })
        return NextResponse.json(location, { status: 201 })
    } catch (error) {
        console.error(error)
        return NextResponse.json(
            { error: 'Failed to create location' },
            { status: 500 },
        )
    }
}
