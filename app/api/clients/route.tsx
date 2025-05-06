import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function GET() {
    try {
        const clients = await prisma.client.findMany({
            orderBy: {
                createdAt: 'desc',
            },
        })
        return NextResponse.json(clients)
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to fetch clients' },
            { status: 500 },
        )
    }
}

export async function POST(req: NextRequest) {
    try {
        const data = await req.json()
        const client = await prisma.client.create({ data })
        return NextResponse.json(client, { status: 201 })
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to create client' },
            { status: 500 },
        )
    }
}
