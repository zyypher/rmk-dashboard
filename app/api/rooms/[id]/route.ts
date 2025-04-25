import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()


export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
    try {
      const body = await req.json()
      const room = await prisma.room.update({
        where: { id: params.id },
        data: body,
      })
      return NextResponse.json(room)
    } catch (error) {
      console.error('PUT /api/rooms/[id] error:', error)
      return NextResponse.json({ error: 'Failed to update room' }, { status: 500 })
    }
  }
  
  export async function DELETE(req: NextRequest, { params }: { params: { id: string } }) {
    try {
      await prisma.room.delete({ where: { id: params.id } })
      return NextResponse.json({ message: 'Room deleted successfully' })
    } catch (error) {
      console.error('DELETE /api/rooms/[id] error:', error)
      return NextResponse.json({ error: 'Failed to delete room' }, { status: 500 })
    }
  }
  