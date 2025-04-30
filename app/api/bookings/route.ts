import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function GET() {
  try {
    const sessions = await prisma.trainingSession.findMany({
      include: {
        course: { include: { trainer: true } },
        room: true,
      },
    })

    return NextResponse.json(sessions)
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch sessions' }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()

    const date = new Date(body.date)
    const startTime = new Date(body.startTime)
    const endTime = new Date(body.endTime)

    if (
      isNaN(date.getTime()) ||
      isNaN(startTime.getTime()) ||
      isNaN(endTime.getTime())
    ) {
      return NextResponse.json({ error: 'Invalid date/time values' }, { status: 400 })
    }

    const { course, trainer, room, ...cleaned } = body

    const session = await prisma.trainingSession.create({
      data: {
        ...cleaned,
        date,
        startTime,
        endTime,
        participants: cleaned.selectedSeats?.length || 0,
        selectedSeats: cleaned.selectedSeats ?? [],
      },
    })

    return NextResponse.json(session, { status: 201 })
  } catch (error) {
    console.error('Error creating session:', error)
    return NextResponse.json({ error: 'Failed to create session' }, { status: 500 })
  }
}
