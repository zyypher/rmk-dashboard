import { NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: Request) {
    const { searchParams } = new URL(req.url)

    const clientName = searchParams.get('clientName') || ''
    const delegateName = searchParams.get('delegateName') || ''
    const clientPhone = searchParams.get('clientPhone') || ''
    const dateFrom = searchParams.get('dateFrom') || ''
    const dateTo = searchParams.get('dateTo') || ''
    const courseId = searchParams.get('courseId') || ''
    const locationIds = searchParams.get('locationIds') || ''

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
        orderBy: {
            createdAt: 'desc',
        },
    })

    const filtered = delegates.filter((d) => {
        const s = d.session
        if (!s) return false

        // Date range filtering
        const sessionDate = new Date(s.date).toISOString().split('T')[0]
        const matchesDateRange = dateFrom && dateTo
            ? sessionDate >= dateFrom && sessionDate <= dateTo
            : dateFrom
            ? sessionDate >= dateFrom
            : dateTo
            ? sessionDate <= dateTo
            : true

        const matchesCourse = courseId ? s.courseId === courseId : true
        
        // Multi-location filtering
        const locationIdsArray = locationIds ? locationIds.split(',') : []
        const matchesLocation = locationIdsArray.length > 0 
            ? locationIdsArray.includes(s.locationId || '')
            : true

        return matchesDateRange && matchesCourse && matchesLocation
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

    if (result.length === 0) {
        return new NextResponse(null, { status: 204 })
    }

    return NextResponse.json(result)
}
