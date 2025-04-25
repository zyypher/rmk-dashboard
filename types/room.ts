export interface Room {
    id: string
    name: string
    type: 'ONLINE' | 'OFFLINE'
    capacity?: number
    notes?: string
    locationId: string
    location: { name: string }
}
