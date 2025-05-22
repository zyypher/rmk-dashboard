import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: NextRequest) {
    const { searchParams } = new URL(req.url)
    const q = searchParams.get('q')?.trim()

    try {
        const courses = await prisma.course.findMany({
            where: q
                ? {
                      OR: [
                          {
                              title: {
                                  contains: q,
                                  mode: 'insensitive',
                              },
                          },
                          {
                              shortname: {
                                  contains: q,
                                  mode: 'insensitive',
                              },
                          },
                          {
                              category: {
                                  name: {
                                      contains: q,
                                      mode: 'insensitive',
                                  },
                              },
                          },
                      ],
                  }
                : {}, // ← no filter when q is empty
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
        console.error('❌ Error searching courses:', error)
        return NextResponse.json(
            { error: 'Failed to search courses' },
            { status: 500 },
        )
    }
}
