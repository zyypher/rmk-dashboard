import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

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
      await prisma.location.delete({
        where: { id: locationId },
      })
  
      return NextResponse.json({ message: 'Location deleted successfully' }, { status: 200 })
    } catch (error) {
      console.error('Error deleting location:', error)
      return NextResponse.json({ error: 'Failed to delete location' }, { status: 500 })
    }
  }
