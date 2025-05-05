import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'
import { Upload } from '@aws-sdk/lib-storage'
import { S3Client } from '@aws-sdk/client-s3'
import { Readable } from 'stream'

const prisma = new PrismaClient()
const BUCKET_NAME = process.env.AWS_BUCKET_NAME!

const s3 = new S3Client({
    region: process.env.AWS_REGION!,
    credentials: {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID!,
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY!,
    },
})

function readableStreamToNodeStream(stream: ReadableStream) {
    const reader = stream.getReader()
    return new Readable({
        async read() {
            const { done, value } = await reader.read()
            if (done) {
                this.push(null)
            } else {
                this.push(value)
            }
        },
    })
}

async function uploadPhoto(photo: File, seatId: string) {
    const key = `delegates/${seatId}-${Date.now()}-${photo.name}`
    const nodeStream = readableStreamToNodeStream(photo.stream())

    const upload = new Upload({
        client: s3,
        params: {
            Bucket: BUCKET_NAME,
            Key: key,
            Body: nodeStream,
            ContentType: photo.type,
            // ACL: 'public-read',
        },
    })

    await upload.done()
    return `https://${BUCKET_NAME}.s3.amazonaws.com/${key}`
}

export async function GET() {
    try {
        const sessions = await prisma.trainingSession.findMany({
            include: {
                course: { include: { trainers: true } },
                room: true,
            },
        })

        return NextResponse.json(sessions)
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to fetch sessions' },
            { status: 500 },
        )
    }
}

export async function POST(req: NextRequest) {
    try {
        const formData = await req.formData()
        const body = JSON.parse(formData.get('data') as string)
        const date = new Date(body.date)
        const startTime = new Date(body.startTime)
        const endTime = new Date(body.endTime)

        if (!body.trainerId || !body.courseId || !body.roomId) {
            return NextResponse.json(
                { error: 'Missing required fields' },
                { status: 400 },
            )
        }

        if (
            isNaN(date.getTime()) ||
            isNaN(startTime.getTime()) ||
            isNaN(endTime.getTime())
        ) {
            return NextResponse.json(
                { error: 'Invalid date/time values' },
                { status: 400 },
            )
        }

             // Optional: Validation for time/location conflicts
        // const conflictReasons = await validateBookingConflicts({
        //     id: undefined,
        //     trainerId: body.trainerId,
        //     roomId: body.roomId,
        //     date,
        //     startTime,
        //     endTime,
        // })
        // if (conflictReasons.length > 0) {
        //     return NextResponse.json(
        //         { error: 'Booking conflict detected', reasons: conflictReasons },
        //         { status: 409 }
        //     )
        // }

        // 1. Create the session

        const session = await prisma.trainingSession.create({
            data: {
                courseId: body.courseId,
                trainerId: body.trainerId,
                roomId: body.roomId,
                locationId: body.locationId,
                language: body.language,
                notes: body.notes || '',
                date,
                startTime,
                endTime,
                selectedSeats: body.selectedSeats || [],
                participants: body.selectedSeats?.length || 0,
            },
        })

        if (body.delegates?.length) {
            const delegateData = await Promise.all(
                body.delegates.map(async (d: any) => {
                    let photoUrl = d.photoUrl
                    const photoFile = formData.get(d.seatId) as File | null
                    if (photoFile) {
                        photoUrl = await uploadPhoto(photoFile, d.seatId)
                    }

                    return {
                        sessionId: session.id,
                        seatId: d.seatId,
                        name: d.name,
                        emiratesId: d.emiratesId,
                        phone: d.phone,
                        email: d.email,
                        companyName: d.companyName,
                        isCorporate: d.isCorporate,
                        photoUrl,
                        status: d.status,
                        createdAt: new Date(),
                        updatedAt: new Date(),
                    }
                }),
            )

            await prisma.delegate.createMany({ data: delegateData })
        }

        return NextResponse.json(session, { status: 201 })
    } catch (error) {
        console.error('Error creating session:', error)
        return NextResponse.json(
            { error: 'Failed to create session' },
            { status: 500 },
        )
    }
}
