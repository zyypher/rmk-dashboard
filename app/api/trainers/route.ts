import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: NextRequest) {
    try {
        const { searchParams } = new URL(req.url)
        const page = parseInt(searchParams.get('page') || '1', 10)
        const pageSize = parseInt(searchParams.get('pageSize') || '10', 10)

        const [trainers, totalCount] = await Promise.all([
            prisma.trainer.findMany({
                skip: (page - 1) * pageSize,
                take: pageSize,
                include: {
                    languages: true,
                    courses: true,
                },
                orderBy: {
                    createdAt: 'desc',
                },
            }),
            prisma.trainer.count(),
        ])

        const formatted = trainers.map((trainer) => ({
            ...trainer,
            languages: trainer.languages.map((lang) => lang.name),
        }))

        const totalPages = Math.ceil(totalCount / pageSize)
        return NextResponse.json({ trainers: formatted, totalPages })
    } catch (error) {
        console.error('Failed to fetch trainers:', error)
        return NextResponse.json(
            { error: 'Failed to fetch trainers' },
            { status: 500 },
        )
    }
}

export async function POST(req: NextRequest) {
    try {
        const data = await req.json()

        const {
            name,
            email,
            phone,
            languages = [], // ✅ default to empty array
            availableDays = [],
            courses = [],
            dailyTimeSlots = null,
        } = data

        if (!name || !Array.isArray(languages) || !Array.isArray(courses)) {
            return NextResponse.json(
                { error: 'Invalid input' },
                { status: 400 },
            )
        }

        const created = await prisma.trainer.create({
            data: {
                name,
                email,
                phone,
                availableDays,
                dailyTimeSlots,
                languages: {
                    connect: languages.map((lang: string) => ({ name: lang })),
                },
                courses: {
                    connect: courses.map((id: string) => ({ id })),
                },
            },
        })

        return NextResponse.json(created, { status: 201 })
    } catch (error) {
        console.error('Failed to create trainer:', error)
        return NextResponse.json(
            { error: 'Failed to create trainer' },
            { status: 500 },
        )
    }
}
