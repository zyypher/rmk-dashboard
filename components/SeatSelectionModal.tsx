'use client'

import { useEffect, useState } from 'react'
import { Dialog } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Armchair, Users } from 'lucide-react'
import clsx from 'clsx'
import { Room } from '@/types/room'
import { Delegate } from '@/types/delegate'
import AttendantSheetModal from './AttendantSheetModal'
import DelegateModal from './DelegateModal'
import { uploadToS3 } from '@/lib/s3'
import axios from 'axios'
import { Booking } from '@/types/booking'
import { toast } from 'react-hot-toast'

interface SeatSelectionModalProps {
    isOpen: boolean
    onClose: () => void
    onBack: () => void
    room?: Room
    selectedSeats: string[]
    setSelectedSeats: React.Dispatch<React.SetStateAction<string[]>>
    onFinalSubmit: (seats: string[]) => Promise<void>
    delegates: Record<string, Delegate>
    setDelegates: React.Dispatch<React.SetStateAction<Record<string, Delegate>>>
    bookingData: Booking
    loading?: boolean
}

interface ClientOption {
    id: string
    name: string
    tradeLicenseNumber?: string
    landline?: string
}

export default function SeatSelectionModal({
    isOpen,
    onClose,
    onBack,
    room,
    selectedSeats,
    setSelectedSeats,
    onFinalSubmit,
    delegates,
    setDelegates,
    bookingData,
    loading,
}: SeatSelectionModalProps) {
    const [capacity, setCapacity] = useState(0)
    const [isSubmitting, setIsSubmitting] = useState(false)
    const [showSheet, setShowSheet] = useState(false)
    const [delegateModalOpen, setDelegateModalOpen] = useState(false)
    const [activeSeat, setActiveSeat] = useState<string | null>(null)
    const [clientOptions, setClientOptions] = useState<ClientOption[]>([])

    console.log('## 🪑 activeSeat:', activeSeat)
    console.log('## 🎯 selectedSeats before:', selectedSeats)

    useEffect(() => {
        if (room?.capacity) setCapacity(room.capacity)
    }, [room])

    useEffect(() => {
        async function fetchClients() {
            const res = await axios.get('/api/clients?paginated=false')
            setClientOptions(res.data.clients)
        }
        fetchClients()
    }, [])

    const toggleSeat = (seat: string) => {
        if (selectedSeats.includes(seat)) {
            setSelectedSeats(selectedSeats.filter((s) => s !== seat))
        } else {
            setSelectedSeats([...selectedSeats, seat])
        }

        setActiveSeat(seat)
        setDelegateModalOpen(false)
        setTimeout(() => {
            setActiveSeat(seat)
            setDelegateModalOpen(true)
        }, 0)
    }

    const handleConfirm = async () => {
        setIsSubmitting(true)
        try {
            await onFinalSubmit(selectedSeats)
        } finally {
            setIsSubmitting(false)
        }
    }

    const getStatus = (seatId: string) => {
        if (!delegates[seatId]) return 'EMPTY'
        return delegates[seatId].status === 'CONFIRMED'
            ? 'CONFIRMED'
            : 'NOT_CONFIRMED'
    }

    const getRows = () => {
        const perRow = 6
        const rows = []
        for (let i = 0; i < capacity; i += perRow) {
            rows.push(
                <div key={i} className="flex justify-center gap-2">
                    {Array.from({ length: Math.min(perRow, capacity - i) }).map(
                        (_, j) => {
                            const seatId = `S${i + j + 1}`
                            const isSelected = selectedSeats.includes(seatId)
                            const status = getStatus(seatId)

                            const color =
                                status === 'CONFIRMED'
                                    ? 'text-green-600 border-green-600'
                                    : status === 'NOT_CONFIRMED'
                                      ? 'text-yellow-500 border-yellow-500'
                                      : 'text-gray-600 border-gray-400'

                            return (
                                <button
                                    key={seatId}
                                    onClick={() => toggleSeat(seatId)}
                                    className={clsx(
                                        'rounded border p-1 transition',
                                        color,
                                        isSelected
                                            ? 'bg-muted'
                                            : 'hover:scale-105',
                                    )}
                                >
                                    <Armchair
                                        className="h-6 w-6"
                                        style={{ transform: 'scaleX(-1)' }}
                                    />
                                </button>
                            )
                        },
                    )}
                </div>,
            )
        }
        return rows
    }

    // Handle delegate deletion
    const handleDeleteDelegate = async (delegateId: string) => {
        try {
            await axios.delete(`/api/delegates/${delegateId}`);
            toast.success('Delegate deleted successfully');
            // Remove from selectedSeats if it was a selected seat
            setSelectedSeats((prev) => prev.filter((seat) => delegates[seat]?.id !== delegateId));
            // Remove from delegates map
            setDelegates((prev) => {
                const newDelegates = { ...prev };
                // Find the seatId associated with the deleted delegate
                const seatIdToRemove = Object.keys(newDelegates).find(key => newDelegates[key].id === delegateId);
                if (seatIdToRemove) {
                    delete newDelegates[seatIdToRemove];
                }
                return newDelegates;
            });
        } catch (error) {
            console.error('Error deleting delegate:', error);
            toast.error('Failed to delete delegate');
        }
    };

    return (
        <Dialog
            isOpen={isOpen}
            onClose={onClose}
            title="Select Seats"
            submitLabel="Confirm"
        >
            <div className="space-y-6">
                <div className="space-y-3">{getRows()}</div>

                <div className="mt-6 flex items-center justify-between gap-4">
                    <Button variant="outline-black" onClick={onBack}>
                        Back
                    </Button>

                    <div className="flex gap-2">
                        <Button
                            variant="outline"
                            onClick={() => setShowSheet(true)}
                            className="text-sm"
                        >
                            <Users className="mr-2 h-4 w-4" /> Attendant Sheet
                        </Button>

                        <Button
                            variant="black"
                            onClick={handleConfirm}
                            disabled={isSubmitting || loading}
                        >
                            {isSubmitting ? 'Saving...' : 'Confirm'}
                        </Button>
                    </div>
                </div>

                <DelegateModal
                    key={activeSeat}
                    isOpen={delegateModalOpen}
                    onClose={() => {
                        setDelegateModalOpen(false)
                        setActiveSeat(null)
                    }}
                    seatId={activeSeat || ''}
                    initialData={
                        activeSeat && delegates[activeSeat]
                            ? {
                                  id: delegates[activeSeat].id, // Pass the delegate ID
                                  name: delegates[activeSeat].name || '',
                                  emiratesId: delegates[activeSeat].emiratesId || '',
                                  phone: delegates[activeSeat].phone || '',
                                  email: delegates[activeSeat].email || '',
                                  photo: null,
                                  companyName:
                                      delegates[activeSeat].companyName || '',
                                  isCorporate:
                                      delegates[activeSeat].isCorporate ?? false,
                                  status: delegates[activeSeat].status || 'NOT_CONFIRMED',
                                  photoUrl: delegates[activeSeat].photoUrl || '',
                                  quotation: delegates[activeSeat].quotation || '',
                                  paid: delegates[activeSeat].paid ?? false,
                                  addNewClient:
                                      delegates[activeSeat].addNewClient ?? false,
                                  clientId: delegates[activeSeat].clientId || '',
                                  newClient: delegates[activeSeat].newClient ? { 
                                    name: delegates[activeSeat].newClient?.name || '',
                                    phone: delegates[activeSeat].newClient?.phone || '',
                                    landline: delegates[activeSeat].newClient?.landline || '',
                                    email: delegates[activeSeat].newClient?.email || '',
                                    contactPersonName: delegates[activeSeat].newClient?.contactPersonName || '',
                                    contactPersonPosition: delegates[activeSeat].newClient?.contactPersonPosition || '',
                                    tradeLicenseNumber: delegates[activeSeat].newClient?.tradeLicenseNumber || '',
                                  } : undefined,
                              }
                            : undefined
                    }
                    onSave={async (delegateData) => {
                        if (activeSeat) {
                            let newPhotoUrl = delegateData.photoUrl

                            if (
                                delegateData.photo &&
                                typeof delegateData.photo !== 'string'
                            ) {
                                newPhotoUrl = await uploadToS3(delegateData.photo)
                            }

                            let clientIdToUse = delegateData.clientId; // Default to existing clientId

                            if (delegateData.addNewClient && delegateData.newClient) {
                                try {
                                    const res = await axios.post(
                                        '/api/clients',
                                        delegateData.newClient,
                                    );
                                    clientIdToUse = res.data.id; // Use the newly created client's ID
                                    // Update client options if necessary (assuming clientOptions is in scope)
                                    // setClientOptions((prev) => [...prev, res.data]);
                                } catch (error) {
                                    console.error('Error creating new client:', error);
                                    toast.error('Failed to create new client.');
                                    // Optionally, handle this error more gracefully, e.g., prevent delegate save
                                }
                            }

                            const newDelegate: Delegate = {
                                id: delegates[activeSeat]?.id || '',
                                sessionId: delegates[activeSeat]?.sessionId || '',
                                seatId: activeSeat,
                                name: delegateData.name || '',
                                emiratesId: delegateData.emiratesId || '',
                                phone: delegateData.phone || '',
                                email: delegateData.email || '',
                                companyName: delegateData.companyName || '',
                                isCorporate: delegateData.isCorporate,
                                status: delegateData.status,
                                photoUrl: newPhotoUrl || '',
                                quotation: delegateData.quotation || '',
                                paid: delegateData.paid ?? false,
                                createdAt: delegates[activeSeat]?.createdAt || new Date(),
                                updatedAt: new Date(),
                                session: delegates[activeSeat]?.session || {} as any,
                                photo: '',
                                clientId: clientIdToUse || '',
                                newClient: delegateData.newClient ? {
                                    name: delegateData.newClient.name || '',
                                    phone: delegateData.newClient.phone || '',
                                    landline: delegateData.newClient.landline || '',
                                    email: delegateData.newClient.email || '',
                                    contactPersonName: delegateData.newClient.contactPersonName || '',
                                    contactPersonPosition: delegateData.newClient.contactPersonPosition || '',
                                    tradeLicenseNumber: delegateData.newClient.tradeLicenseNumber || '',
                                } : undefined,
                            };

                            setDelegates((prev) => ({
                                ...prev,
                                [activeSeat]: newDelegate,
                            }))
                        }
                        setDelegateModalOpen(false)
                    }}
                    clientOptions={clientOptions}
                    onDeleteDelegate={handleDeleteDelegate}
                />

                <AttendantSheetModal
                    isOpen={showSheet}
                    onClose={() => setShowSheet(false)}
                    delegates={delegates}
                    large
                    bookingInfo={{
                        course: bookingData?.course?.title || '—',
                        trainer: bookingData?.trainer?.name || '—',
                        date: bookingData?.date
                            ? new Date(bookingData.date).toLocaleDateString('en-GB')
                            : '—',
                        time:
                            bookingData?.startTime && bookingData?.endTime
                                ? `${new Date(bookingData.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })} - ${new Date(bookingData.endTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}`
                                : '—',
                        venue: bookingData?.location?.name || '—',
                        language: bookingData?.language || '—',
                    }}
                />
            </div>
        </Dialog>
    )
}
