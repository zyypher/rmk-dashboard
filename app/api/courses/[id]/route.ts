import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function DELETE(
    _: NextRequest,
    { params }: { params: { id: string } },
) {
    const prisma = new PrismaClient()
    const courseId = params.id

    try {
        const [bookingsCount, languageLinks] = await Promise.all([
            prisma.trainingSession.count({ where: { courseId } }),
            prisma.language.count({
                where: { courses: { some: { id: courseId } } },
            }),
        ])

        if (bookingsCount > 0 || languageLinks > 0) {
            return NextResponse.json(
                {
                    error: 'Cannot delete course with existing dependencies.',
                    dependencies: {
                        bookings: bookingsCount,
                        languages: languageLinks,
                    },
                },
                { status: 409 },
            )
        }

        await prisma.course.delete({ where: { id: courseId } })

        return NextResponse.json({ message: 'Course deleted' })
    } catch (error) {
        console.error('Failed to delete course:', error)
        return NextResponse.json(
            { error: 'Failed to delete course' },
            { status: 500 },
        )
    }
}

export async function PUT(
    req: NextRequest,
    { params }: { params: { id: string } },
) {
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

        const languageNames = languages.map((lang: any) =>
            typeof lang === 'string' ? lang : lang.name,
        )

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
                    connect: languageNames.map((name: string) => ({ name })),
                },
            },
        })

        return NextResponse.json(updated)
    } catch (error) {
        console.error('❌ PUT /courses/[id] error:', error)
        return NextResponse.json(
            { error: 'Failed to update course' },
            { status: 500 },
        )
    }
}
