import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET(req: NextRequest) {
    try {
        const { searchParams } = new URL(req.url)
        const id = searchParams.get('id')
        const paginatedParam = searchParams.get('paginated')
        const paginated = paginatedParam === 'true'

        if (id) {
            // Fetch a single client by ID
            const client = await prisma.client.findUnique({
                where: { id: id },
            });
            if (client) {
                return NextResponse.json(client, { status: 200 });
            } else {
                return NextResponse.json({ error: 'Client not found' }, { status: 404 });
            }
        }

        if (!paginated) {
            // Return all clients if pagination is explicitly false, sorted alphabetically by name (case-insensitive)
            const allClients = await prisma.client.findMany({
                orderBy: { name: 'asc' },
            });

            // Sort in application layer for case-insensitivity
            allClients.sort((a, b) => a.name.localeCompare(b.name, undefined, { sensitivity: 'base' }));

            return NextResponse.json({ clients: allClients, totalPages: 1 });
        }

        const page = parseInt(searchParams.get('page') || '1', 10)
        const pageSize = parseInt(searchParams.get('pageSize') || '10', 10)

        const [clients, totalCount] = await Promise.all([
            prisma.client.findMany({
                skip: (page - 1) * pageSize,
                take: pageSize,
                orderBy: { createdAt: 'desc' },
            }),
            prisma.client.count(),
        ])

        const totalPages = Math.ceil(totalCount / pageSize)

        return NextResponse.json({ clients, totalPages })
    } catch (error) {
        console.error('Error in GET /api/clients:', error)
        return NextResponse.json(
            { error: 'Failed to fetch clients' },
            { status: 500 },
        )
    }
}

export async function POST(req: NextRequest) {
    try {
        const data = await req.json()

        // Check if a client with the same email already exists
        let existingClient = null;
        if (data.email) {
            existingClient = await prisma.client.findFirst({
                where: { email: data.email },
            });
        }

        if (existingClient) {
            return NextResponse.json(
                { error: 'Client with this email already exists' },
                { status: 409 },
            )
        }

        const client = await prisma.client.create({ data })
        return NextResponse.json(client, { status: 201 })
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to create client' },
            { status: 500 },
        )
    }
}
