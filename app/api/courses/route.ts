import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function GET() {
  try {
    const courses = await prisma.course.findMany({
      include: {
        category: true,
        languages: true,
      },
      orderBy: {
        createdAt: 'desc',
      },
    })
    return NextResponse.json(courses)
  } catch (error) {
    console.error('Error fetching courses:', error)
    return NextResponse.json({ error: 'Failed to fetch courses' }, { status: 500 })
  }
}

// POST: Create a new course with proper relation to languages
export async function POST(req: NextRequest) {
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

    const course = await prisma.course.create({
      data: {
        title,
        duration,
        isCertified,
        isPublic,
        categoryId,
        languages: {
          connect: languages.map((name: string) => ({ name })),
        },
      },
    })

    return NextResponse.json(course, { status: 201 })
  } catch (error) {
    console.error('Error creating course:', error)
    return NextResponse.json({ error: 'Failed to create course' }, { status: 500 })
  }
}
