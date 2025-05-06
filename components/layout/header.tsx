'use client'
import { useEffect, useState } from 'react'
import api from '@/lib/api'
import { Skeleton } from '@/components/ui/skeleton'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { ChevronDown, LogOut, Menu, UserCog } from 'lucide-react'
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { logout } from '@/lib/auth'

const Header = () => {
    const router = useRouter()

    const [user, setUser] = useState<{
        firstName: string
        lastName: string
        email: string
    } | null>(null)
    const [loading, setLoading] = useState(true)
    const [displayName, setDisplayName] = useState<string | null>(null)

    useEffect(() => {
        const fetchUser = async () => {
            try {
                const response = await api.get('/api/users/me')
                setUser(response.data)
            } catch (error) {
                console.error('Failed to fetch user data')
            } finally {
                setLoading(false)
            }
        }
        fetchUser()
    }, [])

    useEffect(() => {
        if (user?.firstName || user?.lastName) {
            setDisplayName(
                `${user.firstName ?? ''} ${user.lastName ?? ''}`.trim(),
            )
        } else if (user?.email === 'admin@gulbahartobacco.com') {
            setDisplayName('Admin')
        } else {
            setDisplayName('User')
        }
    }, [user])

    const handleLogout = async () => {
        await logout()
        router.push('/login')
    }

    const getUserInitials = () => {
        if (!user) return 'R'

        const first = user.firstName?.charAt(0) ?? ''
        const last = user.lastName?.charAt(0) ?? ''

        const initials = `${first}${last}`.toUpperCase()

        return initials || 'R'
    }

    const toggleSidebar = () => {
        document.getElementById('sidebar')?.classList.add('open')
        document.getElementById('overlay')?.classList.add('open')
    }

    return (
        <header className="fixed inset-x-0 top-0 z-30 bg-white px-4 py-[15px] shadow-sm lg:px-5">
            <div className="flex items-center justify-between gap-5">
                <Link href="/" className="inline-block shrink-0 lg:ml-2.5">
                    <img
                        src="/images/new/rmk-logo.png"
                        alt="Brand Logo"
                        className="h-10 w-auto"
                    />
                </Link>

                <div className="inline-flex items-center gap-3 sm:gap-5">
                    <div className="hidden lg:block">
                        <DropdownMenu>
                            <DropdownMenuTrigger asChild>
                                <div className="group flex cursor-pointer items-center gap-2.5 rounded-lg">
                                    {loading ? (
                                        <Skeleton className="h-8 w-8 rounded-full" />
                                    ) : (
                                        <div className="flex h-8 w-8 items-center justify-center rounded-full bg-black text-sm font-bold text-white">
                                            {getUserInitials()}
                                        </div>
                                    )}
                                    <div className="hidden space-y-1 lg:block">
                                        {loading ? (
                                            <>
                                                <Skeleton className="h-3 w-24 rounded" />
                                                <Skeleton className="h-4 w-28 rounded" />
                                            </>
                                        ) : (
                                            <>
                                                <h5 className="line-clamp-1 text-[10px]/3 font-semibold">
                                                    Welcome back 👋
                                                </h5>
                                                <h2 className="line-clamp-1 text-xs font-bold text-black">
                                                    {displayName}
                                                </h2>
                                            </>
                                        )}
                                    </div>

                                    <button
                                        type="button"
                                        className="-ml-1 mt-auto text-black transition group-hover:opacity-70"
                                    >
                                        <ChevronDown className="h-4 w-4 shrink-0 duration-300" />
                                    </button>
                                </div>
                            </DropdownMenuTrigger>
                            <DropdownMenuContent
                                align="end"
                                sideOffset={12}
                                className="min-w-[200px] space-y-1 rounded-lg p-1.5 text-sm font-medium"
                            >
                                <DropdownMenuItem className="p-0">
                                    <Link
                                        href="/setting"
                                        className="flex items-center gap-1.5 rounded-lg px-3 py-2"
                                    >
                                        <UserCog className="size-[18px] shrink-0" />
                                        Profile
                                    </Link>
                                </DropdownMenuItem>
                                <DropdownMenuItem className="p-0">
                                    <Link
                                        href="/login"
                                        onClick={handleLogout}
                                        className="flex items-center gap-1.5 rounded-lg px-3 py-2"
                                    >
                                        <LogOut className="size-[18px] shrink-0" />
                                        Sign out
                                    </Link>
                                </DropdownMenuItem>
                            </DropdownMenuContent>
                        </DropdownMenu>
                    </div>

                    <button
                        type="button"
                        className="lg:hidden"
                        onClick={toggleSidebar}
                    >
                        <Menu className="h-5 w-5" />
                    </button>
                </div>
            </div>
        </header>
    )
}

export default Header
