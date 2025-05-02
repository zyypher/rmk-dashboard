import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

export const dynamic = 'force-dynamic'

const prisma = new PrismaClient()

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
  const { id } = params
  const body = await req.json()

  try {
    const updated = await prisma.location.update({
      where: { id },
      data: body,
    })
    return NextResponse.json(updated)
  } catch (error) {
    console.error(error)
    return NextResponse.json({ error: 'Failed to update location' }, { status: 500 })
  }
}

export async function DELETE(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  const locationId = params.id

  try {
    const roomCount = await prisma.room.count({
      where: { locationId },
    })

    if (roomCount > 0) {
      return NextResponse.json(
        {
          error: 'Cannot delete location with rooms',
          rooms: roomCount,
        },
        { status: 409 }
      )
    }

    await prisma.location.delete({
      where: { id: locationId },
    })

    return NextResponse.json({ message: 'Location deleted' })
  } catch (error) {
    console.error('Error deleting location:', error)
    return NextResponse.json({ error: 'Failed to delete location' }, { status: 500 })
  }
}

