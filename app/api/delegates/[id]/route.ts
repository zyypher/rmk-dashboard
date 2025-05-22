import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } },
) {
  try {
    const delegate = await prisma.delegate.findUnique({
      where: { id: params.id },
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
    return NextResponse.json(delegate)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch delegate' },
      { status: 500 },
    )
  }
}

export async function PUT(
  req: NextRequest,
  { params }: { params: { id: string } },
) {
  try {
    const data = await req.json()
    const delegate = await prisma.delegate.update({ where: { id: params.id }, data })
    return NextResponse.json(delegate)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to update delegate' },
      { status: 500 },
    )
  }
}

export async function DELETE(
  req: NextRequest,
  { params }: { params: { id: string } },
) {
  try {
    await prisma.delegate.delete({ where: { id: params.id } })
    return NextResponse.json({ message: 'Delegate deleted successfully' })
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to delete delegate' },
      { status: 500 },
    )
  }
}