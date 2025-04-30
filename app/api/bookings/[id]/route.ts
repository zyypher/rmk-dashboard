import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
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

    const updated = await prisma.trainingSession.update({
      where: { id: params.id },
      data: {
        ...cleaned,
        date,
        startTime,
        endTime,
        participants: cleaned.selectedSeats?.length || 0,
        selectedSeats: cleaned.selectedSeats ?? [],
      },
    })

    return NextResponse.json(updated)
  } catch (error) {
    console.error('Error updating booking:', error)
    return NextResponse.json({ error: 'Failed to update booking' }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest, { params }: { params: { id: string } }) {
  try {
    await prisma.trainingSession.delete({
      where: { id: params.id },
    })

    return NextResponse.json({ success: true })
  } catch (error) {
    return NextResponse.json({ error: 'Failed to delete session' }, { status: 500 })
  }
}
