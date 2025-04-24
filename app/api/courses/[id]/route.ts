import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function DELETE(
    _: NextRequest,
    { params }: { params: { id: string } },
) {
    try {
        await prisma.course.delete({ where: { id: params.id } })
        return NextResponse.json({ message: 'Course deleted' })
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to delete course' },
            { status: 500 },
        )
    }
}

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
  try {
    const {
      title,
      duration,
      isCertified,
      isPublic,
      categoryId,
      trainerId,
      languages,
    } = await req.json()

    const updated = await prisma.course.update({
      where: { id: params.id },
      data: {
        title,
        duration,
        isCertified,
        isPublic,
        categoryId,
        trainerId,
        languages: {
          set: [],
          connect: languages.map((name: string) => ({ name })),
        },
      },
    })

    return NextResponse.json(updated)
  } catch (error) {
    console.error('❌ PUT /courses/[id] error:', error)
    return NextResponse.json({ error: 'Failed to update course' }, { status: 500 })
  }
}
