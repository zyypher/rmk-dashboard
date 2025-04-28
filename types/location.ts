export interface Location {
    id: string
    name: string
    address: string
    type: 'ONLINE' | 'OFFLINE'
    capacity: number
    createdAt?: string
    updatedAt?: string
  }
  