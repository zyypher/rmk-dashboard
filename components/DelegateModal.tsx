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

export type DelegateForm = {
    name: string
    emiratesId: string
    phone: string
    email: string
    photo: File | null
    companyName: string
    isCorporate: boolean
    status: 'CONFIRMED' | 'NOT_CONFIRMED'
    photoUrl?: string // for preview
}

const delegateSchema: yup.AnyObjectSchema = yup.object({
    name: yup.string().nullable().notRequired(),
  
    emiratesId: yup
      .string()
      .nullable()
      .notRequired()
      .test('is-valid-emirates-id', 'Invalid Emirates ID format', (val) => {
        if (!val) return true // allow empty
        return /^784\d{12}$/.test(val)
      }),
  
    phone: yup
      .string()
      .nullable()
      .notRequired()
      .test('is-valid-phone', 'Invalid phone number', (val) => {
        if (!val) return true
        return /^[0-9]{9,15}$/.test(val)
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
  
    companyName: yup.string().required('Company name is required'),
  
    isCorporate: yup.boolean().required('Corporate type is required'),
  
    status: yup
      .mixed<'CONFIRMED' | 'NOT_CONFIRMED'>()
      .oneOf(['CONFIRMED', 'NOT_CONFIRMED'], 'Status is required')
      .required('Status is required'),
  })
  

interface DelegateModalProps {
    isOpen: boolean
    onClose: () => void
    seatId: string
    initialData?: DelegateForm & { photoUrl?: string }
    onSave: (data: DelegateForm) => void
}

export default function DelegateModal({
    isOpen,
    onClose,
    onSave,
    initialData,
    seatId,
}: DelegateModalProps) {
    const [photoPreviewUrl, setPhotoPreviewUrl] = useState<string | null>(null)
    const [isSubmitting, setIsSubmitting] = useState(false)

    console.log('##photoPreviewUrl', photoPreviewUrl)

    const {
        register,
        handleSubmit,
        control,
        setValue,
        reset,
        formState: { errors },
    } = useForm<DelegateForm>({
        resolver: yupResolver(delegateSchema),
        defaultValues: {
            name: '',
            emiratesId: '',
            phone: '',
            email: '',
            photo: null,
            companyName: '',
            isCorporate: false,
            status: 'NOT_CONFIRMED',
        },
    })

    useEffect(() => {
        if (initialData) {
            reset({ ...initialData, photo: null })
            setPhotoPreviewUrl(initialData.photoUrl ?? null)
        } else {
            reset()
            setPhotoPreviewUrl(null)
        }
    }, [initialData, reset])

    useEffect(() => {
        console.log('##photoPreviewUrl 👉', photoPreviewUrl)
    }, [photoPreviewUrl])

    const handleFormSubmit: SubmitHandler<DelegateForm> = async (data) => {
        setIsSubmitting(true)
        try {
            await onSave(data)
        } finally {
            setIsSubmitting(false)
        }
    }

    return (
        <Dialog isOpen={isOpen} onClose={onClose} title="Add Delegate">
            <form
                onSubmit={handleSubmit(handleFormSubmit)}
                className="space-y-4"
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
                        onError={(err) =>
                            console.error(
                                '❌ Image failed to load:',
                                err,
                                photoPreviewUrl,
                            )
                        }
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

                <div className="flex justify-end gap-4 pt-4">
                    <Button
                        variant="outline-black"
                        onClick={onClose}
                        type="button"
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
