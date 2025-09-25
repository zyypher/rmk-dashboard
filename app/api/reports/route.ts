import { NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

// ---- TZ helpers (format as date-only/time-only in Asia/Dubai) ----
const TZ = 'Asia/Dubai'

const fmtDate = (d: Date) =>
    new Intl.DateTimeFormat('en-CA', {
        timeZone: TZ,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
    }).format(d) // -> YYYY-MM-DD

const fmtTime = (d: Date) =>
    new Intl.DateTimeFormat('en-US', {
        timeZone: TZ,
        hour: '2-digit',
        minute: '2-digit',
        hour12: true,
    }).format(d) // -> 09:00 AM

export async function GET(req: Request) {
    const { searchParams } = new URL(req.url)

    const clientName = searchParams.get('clientName') || ''
    const delegateName = searchParams.get('delegateName') || ''
    const clientPhone = searchParams.get('clientPhone') || ''
    const dateFrom = searchParams.get('dateFrom') || '' // expected 'YYYY-MM-DD'
    const dateTo = searchParams.get('dateTo') || '' // expected 'YYYY-MM-DD'
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

    // string compare using YYYY-MM-DD in the business TZ
    const filtered = delegates.filter((d) => {
        const s = d.session
        if (!s) return false

        const sessionDate = fmtDate(s.date)

        const matchesDateRange =
            dateFrom && dateTo
                ? sessionDate >= dateFrom && sessionDate <= dateTo
                : dateFrom
                  ? sessionDate >= dateFrom
                  : dateTo
                    ? sessionDate <= dateTo
                    : true

        const matchesCourse = courseId ? s.courseId === courseId : true

        const locationIdsArray = locationIds ? locationIds.split(',') : []
        const matchesLocation =
            locationIdsArray.length > 0
                ? locationIdsArray.includes(s.locationId || '')
                : true

        return matchesDateRange && matchesCourse && matchesLocation
    })

    const result = filtered.map((d) => ({
        clientName: (d.client?.name ?? '-').trim(),
        clientPhone: (d.client?.phone ?? '-').trim(),
        delegateName: d.name,
        delegateEmail: d.email,
        delegatePhone: d.phone,
        companyName: d.companyName,
        courseTitle: d.session?.course?.title ?? '-',
        trainer: d.session?.trainer?.name ?? '-',
        location: d.session?.location?.name ?? '-',
        date: d.session ? fmtDate(d.session.date) : '-',
        time:
            d.session?.startTime && d.session?.endTime
                ? `${fmtTime(d.session.startTime)} - ${fmtTime(d.session.endTime)}`
                : '-',
    }))

    if (result.length === 0) {
        return new NextResponse(null, { status: 204 })
    }

    return NextResponse.json(result)
}
