import { PrismaClient } from '@prisma/client'
import { NextRequest, NextResponse } from 'next/server'

const prisma = new PrismaClient()

export async function GET(_: NextRequest, { params }: { params: { id: string } }) {
  try {
    const courseId = params.id

    const [bookings, languages] = await Promise.all([
      prisma.trainingSession.count({ where: { courseId } }),
      prisma.language.count({
        where: { courses: { some: { id: courseId } } },
      }),
    ])

    return NextResponse.json({
      bookings,
      trainers: 0, // ❓ optional: include only if trainers are separately linked
      languages,
    })
  } catch (error) {
    console.error('Error checking course dependencies:', error)
    return NextResponse.json({ error: 'Failed to check dependencies' }, { status: 500 })
  }
}
