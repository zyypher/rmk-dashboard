'use client'

import { useEffect, useState } from 'react'
import { useForm, Controller, SubmitHandler } from 'react-hook-form'
import { yupResolver } from '@hookform/resolvers/yup'
import * as yup from 'yup'

import { Dialog } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'
import { Checkbox } from '@/components/ui/checkbox'

export type DelegateForm = {
    name?: string
    emiratesId: string
    phone: string
    email: string
    photo: File | null
    companyName?: string
    isCorporate: boolean
    status: 'CONFIRMED' | 'NOT_CONFIRMED'
    quotation?: string
    paid?: boolean
    addNewClient: boolean
    clientId?: string
    newClient?: {
        name: string
        phone?: string
        landline?: string
        email?: string
        contactPersonName?: string
        contactPersonPosition?: string
        tradeLicenseNumber?: string
    }
    photoUrl?: string // for preview
}

const schema: yup.AnyObjectSchema = yup.object({
    name: yup.string().nullable().notRequired(),
    emiratesId: yup
        .string()
        .nullable()
        .notRequired()
        .test('is-valid-emirates-id', 'Invalid Emirates ID format', (val) => {
            if (!val) return true
            return /^784\d{12}$/.test(val)
        }),
    phone: yup
        .string()
        .nullable()
        .notRequired()
        .test('is-valid-phone', 'Invalid phone number', (val) => {
            if (!val) return true
            return /^\+?[0-9]{9,15}$/.test(val)
        }),
    email: yup
        .string()
        .nullable()
        .notRequired()
        .test('is-valid-email', 'Invalid email', (val) => {
            if (!val) return true
            return yup.string().email().isValidSync(val)
        }),
    photo: yup
        .mixed<File>()
        .nullable()
        .test('fileType', 'Invalid file type', (value) => {
            return value === null || value instanceof File
        }),
    companyName: yup.string().optional(),
    isCorporate: yup.boolean().required('Corporate type is required'),
    status: yup
        .mixed<'CONFIRMED' | 'NOT_CONFIRMED'>()
        .oneOf(['CONFIRMED', 'NOT_CONFIRMED'], 'Status is required')
        .required('Status is required'),
    quotation: yup.string().optional(),
    paid: yup.boolean().optional(),
    addNewClient: yup.boolean().required(),
    clientId: yup.string().when('addNewClient', {
        is: false,
        then: (schema) => schema.required('Client is required'),
        otherwise: (schema) => schema.optional(),
    }),
    newClient: yup.lazy((_, context) => {
        const { parent } = context
        if (parent?.addNewClient) {
            return yup.object({
                name: yup.string().required('Client name is required'),
                phone: yup
                    .string()
                    .required('Client phone is required')
                    .matches(/^\+?[0-9]{9,15}$/, 'Invalid phone format'),
                email: yup
                    .string()
                    .required('Client email is required')
                    .email('Invalid email format'),
                landline: yup.string().optional(),
                contactPersonName: yup.string().optional(),
                contactPersonPosition: yup.string().optional(),
                tradeLicenseNumber: yup.string().optional(),
            })
        }
        return yup.object().optional()
    }),
})

interface Props {
    isOpen: boolean
    onClose: () => void
    seatId: string
    initialData?: DelegateForm
    onSave: (data: DelegateForm) => void
    clientOptions: {
        id: string
        name: string
        tradeLicenseNumber?: string
        landline?: string
    }[]
}

export default function AddDelegateModal({
    isOpen,
    onClose,
    onSave,
    seatId,
    initialData,
    clientOptions,
}: Props) {
    const [photoPreviewUrl, setPhotoPreviewUrl] = useState<string | null>(null)
    const [selectedClient, setSelectedClient] = useState<any>(null)
    const [isSubmitting, setIsSubmitting] = useState(false)

    const {
        register,
        control,
        handleSubmit,
        setValue,
        reset,
        watch,
        formState: { errors },
    } = useForm<DelegateForm>({
        resolver: yupResolver(schema),
        defaultValues: {
            name: '',
            emiratesId: '',
            phone: '',
            email: '',
            photo: null,
            companyName: '',
            isCorporate: false,
            status: 'NOT_CONFIRMED',
            quotation: '',
            paid: false,
            addNewClient: false,
        },
    })

    const addNewClient = watch('addNewClient')
    const clientId = watch('clientId')

    useEffect(() => {
        if (!addNewClient && clientId) {
            const selected =
                clientOptions.find((c) => c.id === clientId) || null
            setSelectedClient(selected)
        } else {
            setSelectedClient(null)
        }
    }, [addNewClient, clientId])

    useEffect(() => {
        if (initialData) {
            reset({
                ...initialData,
                photo: null,
                addNewClient: initialData.addNewClient ?? false,
                clientId: initialData.clientId ?? '',
                newClient: initialData.newClient ?? undefined,
            })
            setPhotoPreviewUrl(initialData.photoUrl ?? null)
        } else {
            reset({
                name: '',
                emiratesId: '',
                phone: '',
                email: '',
                photo: null,
                companyName: '',
                isCorporate: false,
                status: 'NOT_CONFIRMED',
                quotation: '',
                paid: false,
                addNewClient: false,
                clientId: '',
                newClient: undefined,
            })
            setPhotoPreviewUrl(null)
        }
    }, [initialData, seatId, reset]) // <-- Include seatId in deps

    console.log('##👀 clientOptions:', clientOptions)
    console.log('##📌 initialData.clientId:', initialData?.clientId)

    const handleFormSubmit: SubmitHandler<DelegateForm> = async (data) => {
        setIsSubmitting(true)
        try {
            await onSave(data)
        } finally {
            setIsSubmitting(false)
        }
    }

    useEffect(() => {
        register('addNewClient')
    }, [register])

    return (
        <Dialog
            isOpen={isOpen}
            onClose={onClose}
            title="Add Delegate"
            key={seatId}
        >
            <form
                key={seatId}
                onSubmit={handleSubmit(handleFormSubmit)}
                className="max-h-[90vh] space-y-4 overflow-y-auto p-4"
            >
                <Input {...register('name')} placeholder="Name" />
                {errors.name && (
                    <p className="text-sm text-red-600">
                        {errors.name.message}
                    </p>
                )}

                <Input
                    {...register('emiratesId')}
                    placeholder="Emirates ID (e.g. 784XXXXXXXXXXXXX)"
                />
                {errors.emiratesId && (
                    <p className="text-sm text-red-600">
                        {errors.emiratesId.message}
                    </p>
                )}

                <Input {...register('phone')} placeholder="Phone" />
                {errors.phone && (
                    <p className="text-sm text-red-600">
                        {errors.phone.message}
                    </p>
                )}

                <Input {...register('email')} placeholder="Email" />
                {errors.email && (
                    <p className="text-sm text-red-600">
                        {errors.email.message}
                    </p>
                )}

                <Label>Photo</Label>
                <input
                    type="file"
                    accept="image/*"
                    onChange={(e) => {
                        const file = e.target.files?.[0] || null
                        setValue('photo', file, { shouldValidate: true })
                        if (file) {
                            const reader = new FileReader()
                            reader.onloadend = () => {
                                setPhotoPreviewUrl(reader.result as string)
                            }
                            reader.readAsDataURL(file)
                        } else {
                            setPhotoPreviewUrl(null)
                        }
                    }}
                />
                {photoPreviewUrl && (
                    <img
                        src={photoPreviewUrl}
                        alt="Preview"
                        className="mt-2 h-24 w-24 rounded border object-cover"
                    />
                )}
                {errors.photo && (
                    <p className="text-sm text-red-600">
                        {errors.photo.message}
                    </p>
                )}

                <Input
                    {...register('companyName')}
                    placeholder="Company Name"
                />
                {errors.companyName && (
                    <p className="text-sm text-red-600">
                        {errors.companyName.message}
                    </p>
                )}

                <Input {...register('quotation')} placeholder="Quotation" />
                <div className="flex items-center space-x-2">
                    <Checkbox id="paid" {...register('paid')} />
                    <Label htmlFor="paid">Paid</Label>
                </div>

                <div>
                    <Label>Is Corporate?</Label>
                    <Controller
                        name="isCorporate"
                        control={control}
                        render={({ field }) => (
                            <Select
                                value={field.value ? 'yes' : 'no'}
                                onValueChange={(val) =>
                                    field.onChange(val === 'yes')
                                }
                            >
                                <SelectTrigger>
                                    <SelectValue placeholder="Select type" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="yes">
                                        Corporate
                                    </SelectItem>
                                    <SelectItem value="no">Public</SelectItem>
                                </SelectContent>
                            </Select>
                        )}
                    />
                    {errors.isCorporate && (
                        <p className="text-sm text-red-600">
                            {errors.isCorporate.message}
                        </p>
                    )}
                </div>

                <div>
                    <Label>Status</Label>
                    <Controller
                        name="status"
                        control={control}
                        render={({ field }) => (
                            <Select
                                value={field.value}
                                onValueChange={field.onChange}
                            >
                                <SelectTrigger>
                                    <SelectValue placeholder="Select status" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="CONFIRMED">
                                        Confirmed
                                    </SelectItem>
                                    <SelectItem value="NOT_CONFIRMED">
                                        Not Confirmed
                                    </SelectItem>
                                </SelectContent>
                            </Select>
                        )}
                    />
                    {errors.status && (
                        <p className="text-sm text-red-600">
                            {errors.status.message}
                        </p>
                    )}
                </div>

                <div className="flex items-center space-x-2 pt-4">
                    <Checkbox
                        id="addNewClient"
                        checked={addNewClient}
                        onCheckedChange={(val) => {
                            setValue('addNewClient', val === true, {
                                shouldValidate: true,
                            })
                            if (val === true) {
                                setValue('clientId', '', {
                                    shouldValidate: true,
                                })
                            }
                            if (val === false) {
                                setValue('newClient', undefined, {
                                    shouldValidate: true,
                                })
                            }
                        }}
                    />
                    <Label htmlFor="addNewClient">Add New Client</Label>
                </div>

                {!addNewClient ? (
                    <div>
                        <Controller
                            name="clientId"
                            control={control}
                            render={({ field }) => (
                                <Select
                                    disabled={addNewClient}
                                    value={field.value}
                                    onValueChange={(val) => {
                                        field.onChange(val)
                                        const client = clientOptions.find(
                                            (c) => c.id === val,
                                        )
                                        setSelectedClient(client ?? null)
                                    }}
                                >
                                    <SelectTrigger>
                                        <SelectValue placeholder="Select Client" />
                                    </SelectTrigger>
                                    <SelectContent>
                                        {clientOptions.map((client) => (
                                            <SelectItem
                                                key={client.id}
                                                value={client.id}
                                            >
                                                {client.name}
                                            </SelectItem>
                                        ))}
                                    </SelectContent>
                                </Select>
                            )}
                        />
                        {errors.clientId && (
                            <p className="text-sm text-red-600">
                                {errors.clientId.message}
                            </p>
                        )}

                        {selectedClient && (
                            <p className="mt-1 text-xs text-gray-500">
                                {selectedClient.tradeLicenseNumber && (
                                    <>
                                        License:{' '}
                                        {selectedClient.tradeLicenseNumber}
                                        <br />
                                    </>
                                )}
                                {selectedClient.landline && (
                                    <>Landline: {selectedClient.landline}</>
                                )}
                            </p>
                        )}
                    </div>
                ) : (
                    <div className="flex flex-col gap-3 rounded-md border bg-gray-50 p-3">
                        <Input
                            {...register('newClient.name')}
                            placeholder="Client Name"
                        />
                        {errors.newClient?.name && (
                            <p className="text-sm text-red-600">
                                {errors.newClient.name.message}
                            </p>
                        )}

                        <Input
                            {...register('newClient.phone')}
                            placeholder="Phone"
                        />
                        {errors.newClient?.phone && (
                            <p className="text-sm text-red-600">
                                {errors.newClient.phone.message}
                            </p>
                        )}

                        <Input
                            {...register('newClient.landline')}
                            placeholder="Landline"
                        />
                        <Input
                            {...register('newClient.email')}
                            placeholder="Email"
                        />
                        {errors.newClient?.email && (
                            <p className="text-sm text-red-600">
                                {errors.newClient.email.message}
                            </p>
                        )}
                        <Input
                            {...register('newClient.contactPersonName')}
                            placeholder="Contact Person Name"
                        />
                        <Input
                            {...register('newClient.contactPersonPosition')}
                            placeholder="Contact Person Position"
                        />
                        <Input
                            {...register('newClient.tradeLicenseNumber')}
                            placeholder="Trade License Number"
                        />
                    </div>
                )}

                <div className="flex justify-end gap-4 pt-4">
                    <Button
                        variant="outline-black"
                        type="button"
                        onClick={onClose}
                    >
                        Cancel
                    </Button>
                    <Button
                        variant="black"
                        type="submit"
                        disabled={isSubmitting}
                    >
                        {isSubmitting ? 'Saving...' : 'Submit'}
                    </Button>
                </div>
            </form>
        </Dialog>
    )
}
