import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function GET(
    req: NextRequest,
    { params }: { params: { id: string } },
) {
    try {
        const delegates = await prisma.delegate.findMany({
            where: { sessionId: params.id }, orderBy: {
                createdAt: 'desc',
              },
        })

        return NextResponse.json(delegates)
    } catch (error) {
        console.error('Error fetching delegates:', error)

        return NextResponse.json(
            {
                error: 'Failed to fetch delegates',
                details: (error as Error).message,
            },
            { status: 500 },
        )
    }
}
