import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
  try {
    const data = await req.json()
    const { name, email, phone, languages, availableDays } = data

    const updated = await prisma.trainer.update({
      where: { id: params.id },
      data: {
        name,
        email,
        phone,
        availableDays,
        languages: {
          set: [],
          connect: languages.map((lang: string) => ({ name: lang })),
        },
      },
    })
    return NextResponse.json(updated)
  } catch (error) {
    return NextResponse.json({ error: 'Failed to update trainer' }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest, { params }: { params: { id: string } }) {
  try {
    await prisma.trainer.delete({ where: { id: params.id } })
    return NextResponse.json({ message: 'Trainer deleted' })
  } catch (error) {
    return NextResponse.json({ error: 'Failed to delete trainer' }, { status: 500 })
  }
}