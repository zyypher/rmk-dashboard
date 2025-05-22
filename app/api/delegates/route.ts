import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET() {
  try {
    const delegates = await prisma.delegate.findMany({
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
    })
    return NextResponse.json(delegates)
  } catch (error) {
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
    return NextResponse.json(
      { error: 'Failed to create delegate' },
      { status: 500 },
    )
  }
}