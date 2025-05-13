import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
  try {
    const data = await req.json()
    const { name, email, phone, languages, availableDays, courses, dailyTimeSlots } = data

    const updated = await prisma.trainer.update({
      where: { id: params.id },
      data: {
        name,
        email,
        phone,
        availableDays,
        dailyTimeSlots,
        languages: {
          set: [],
          connect: languages.map((lang: string) => ({ name: lang })),
        },
        courses: {
          set: [],
          connect: courses.map((id: string) => ({ id })),
        },
      },
    })

    return NextResponse.json(updated)
  } catch (error) {
    console.error('Failed to update trainer:', error)
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