import { NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function GET(req: Request) {
    const { searchParams } = new URL(req.url)

    const clientName = searchParams.get('clientName') || ''
    const delegateName = searchParams.get('delegateName') || ''
    const clientPhone = searchParams.get('clientPhone') || ''
    const date = searchParams.get('date')
    const courseId = searchParams.get('courseId') || ''
    const locationId = searchParams.get('locationId') || ''

    const delegates = await prisma.delegate.findMany({
        where: {
            ...(delegateName && {
                name: {
                    contains: delegateName,
                    mode: 'insensitive',
                },
            }),
            ...(clientName && {
                client: {
                    name: {
                        contains: clientName,
                        mode: 'insensitive',
                    },
                },
            }),
            ...(clientPhone && {
                client: {
                    phone: {
                        contains: clientPhone,
                        mode: 'insensitive',
                    },
                },
            }),
        },
        include: {
            client: true,
            session: {
                include: {
                    course: true,
                    trainer: true,
                    room: true,
                    location: true,
                },
            },
        },
    })

    const filtered = delegates.filter((d) => {
        const s = d.session
        if (!s) return false

        const matchesDate = date
            ? new Date(s.date).toISOString().split('T')[0] === date
            : true

        const matchesCourse = courseId ? s.courseId === courseId : true
        const matchesLocation = locationId ? s.locationId === locationId : true

        return matchesDate && matchesCourse && matchesLocation
    })

    const result = filtered.map((d) => ({
        clientName: d.client?.name ?? '-',
        clientPhone: d.client?.phone ?? '-',
        delegateName: d.name,
        delegateEmail: d.email,
        delegatePhone: d.phone,
        companyName: d.companyName,
        courseTitle: d.session?.course?.title ?? '-',
        trainer: d.session?.trainer?.name ?? '-',
        location: d.session?.location?.name ?? '-',
        date: d.session?.date?.toISOString().split('T')[0] ?? '-',
        time:
            d.session?.startTime && d.session?.endTime
                ? `${new Date(d.session.startTime).toLocaleTimeString([], {
                      hour: '2-digit',
                      minute: '2-digit',
                  })} - ${new Date(d.session.endTime).toLocaleTimeString([], {
                      hour: '2-digit',
                      minute: '2-digit',
                  })}`
                : '-',
    }))

    return NextResponse.json(result)
}
