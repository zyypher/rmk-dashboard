import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
  try {
    const data = await req.json()
    const updated = await prisma.trainerSchedulingRule.update({
      where: { id: params.id },
      data: {
        trainerId: data.trainerId,
        maxSessionsPerDay: Number(data.maxSessionsPerDay),
        daysOff: data.daysOff,
        allowOverlap: data.allowOverlap,
      },
    })
    return NextResponse.json(updated)
  } catch (error) {
    console.error('PUT error:', error)
    return NextResponse.json({ error: 'Failed to update rule' }, { status: 500 })
  }
}

export async function DELETE(_: NextRequest, { params }: { params: { id: string } }) {
  try {
    await prisma.trainerSchedulingRule.delete({
      where: { id: params.id },
    })
    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('DELETE error:', error)
    return NextResponse.json({ error: 'Failed to delete rule' }, { status: 500 })
  }
}
