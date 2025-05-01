'use client'

import React, { Suspense } from 'react'
import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { zodResolver } from '@hookform/resolvers/zod'
import { Button } from '../../../components/ui/button'
import { Card, CardContent, CardHeader } from '../../../components/ui/card'
import { Input } from '../../../components/ui/input'
import { Lock } from 'lucide-react'
import { useRouter, useSearchParams } from 'next/navigation'
import Image from 'next/image'
import { useState } from 'react'
import api from '../../../lib/api'
import { toast } from 'react-hot-toast'

export const dynamic = 'force-dynamic'

const setPasswordSchema = z.object({
    password: z.string().min(6, 'Password must be at least 6 characters long'),
})

type SetPasswordFormData = z.infer<typeof setPasswordSchema>

function SetPasswordForm() {
    const router = useRouter()
    const searchParams = useSearchParams()
    const token = searchParams.get('token')

    const {
        register,
        handleSubmit,
        formState: { errors },
    } = useForm<SetPasswordFormData>({
        resolver: zodResolver(setPasswordSchema),
    })

    const [loading, setLoading] = useState(false)

    const onSubmit = async (data: SetPasswordFormData) => {
        if (!token) {
            toast.error('Invalid or expired reset link.')
            return
        }

        setLoading(true)
        try {
            await api.post('/api/auth/set-password', { token, password: data.password })
            toast.success('Password set successfully!')
            router.push('/login')
        } catch (error) {
            toast.error('Failed to set password. Please try again.')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="grid h-screen w-full gap-5 p-4 md:grid-cols-2">
            {/* Left Section - Branding */}
            <div className="relative hidden overflow-hidden rounded-[20px] bg-[#3B06D2] p-4 md:block md:h-full">
                <Image
                    src="/images/login-cover-step.svg"
                    width={240}
                    height={240}
                    alt="Logo Cover Step"
                    className="absolute left-0 top-0.5 size-40 md:h-auto md:w-auto"
                />
                <Image
                    src="/images/login-cover-cartoon.svg"
                    width={145}
                    height={34}
                    alt="Logo Cover Cartoon"
                    className="absolute bottom-0 left-0 right-0 h-52 w-full md:h-96"
                />
                <div className="absolute left-1/2 top-1/4 w-full max-w-md -translate-x-1/2 space-y-3 px-3 text-center text-white">
                    <h2 className="text-lg font-bold sm:text-2xl lg:text-[30px]/9">
                        Secure Your Account.
                    </h2>
                    <p className="text-sm lg:text-xl/[30px]">
                        Create a new password to regain access to your account.
                    </p>
                </div>
            </div>

            {/* Right Section - Set Password Form */}
            <div className="flex flex-col justify-center items-center h-full">
                <Image
                    src="/images/new/rmk-logo.png"
                    width={145}
                    height={34}
                    alt="Logo"
                    className="mb-4"
                />

                <Card className="w-full max-w-[400px] space-y-[30px] p-5 shadow-sm">
                    <CardHeader className="space-y-2">
                        <h2 className="text-lg font-semibold text-black lg:text-xl/tight">
                            Set New Password
                        </h2>
                        <p className="font-medium leading-tight">
                            Enter a new password to secure your account.
                        </p>
                    </CardHeader>
                    <CardContent>
                        <form
                            className="space-y-[20px]"
                            onSubmit={handleSubmit(onSubmit)}
                        >
                            <div className="space-y-2">
                                <label className="block font-semibold text-black">
                                    New Password
                                </label>
                                <Input
                                    type="password"
                                    placeholder="********"
                                    iconRight={<Lock className="size-[18px]" />}
                                    {...register('password')}
                                />
                                {errors.password && (
                                    <p className="text-red-500 text-sm">
                                        {errors.password.message}
                                    </p>
                                )}
                            </div>

                            <Button
                                type="submit"
                                variant="black"
                                size="large"
                                className="w-full"
                                disabled={loading}
                            >
                                {loading ? (
                                    <span className="loader" />
                                ) : (
                                    'Set Password'
                                )}
                            </Button>
                        </form>
                    </CardContent>
                </Card>
            </div>
        </div>
    )
}

export default function SetPasswordPage() {
    return (
        <Suspense fallback={<div>Loading...</div>}>
            <SetPasswordForm />
        </Suspense>
    )
}
