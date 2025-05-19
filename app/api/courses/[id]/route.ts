import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function DELETE(
    _: NextRequest,
    { params }: { params: { id: string } },
) {
    const courseId = params.id

    try {
        const bookingsCount = await prisma.trainingSession.count({
            where: { courseId },
        })

        if (bookingsCount > 0) {
            return NextResponse.json(
                {
                    error: 'Cannot delete course with existing training sessions.',
                    dependencies: { bookings: bookingsCount },
                },
                { status: 409 },
            )
        }

        await prisma.$transaction([
            prisma.course.update({
                where: { id: courseId },
                data: {
                    languages: { set: [] }, // disconnect languages
                },
            }),
            prisma.course.delete({ where: { id: courseId } }),
        ])

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
            shortname,
            duration,
            isCertified,
            isPublic,
            categoryId,
            languages,
        } = await req.json()

        const languageNames = languages.map((lang: any) =>
            typeof lang === 'string' ? lang : lang.name,
        )

        const updated = await prisma.course.update({
            where: { id: params.id },
            data: {
                title,
                shortname: shortname || null,
                duration,
                isCertified,
                isPublic,
                categoryId,
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
