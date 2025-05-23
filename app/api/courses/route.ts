import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const page = parseInt(searchParams.get('page') || '1', 10)
    const pageSize = parseInt(searchParams.get('pageSize') || '10', 10)

    const [courses, totalCount] = await Promise.all([
      prisma.course.findMany({
        skip: (page - 1) * pageSize,
        take: pageSize,
        include: {
          category: true,
          languages: true,
        },
        orderBy: {
          createdAt: 'desc',
        },
      }),
      prisma.course.count(),
    ])

    const totalPages = Math.ceil(totalCount / pageSize)

    return NextResponse.json({ courses, totalPages })
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
      shortname,
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
        shortname: shortname || null,
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
