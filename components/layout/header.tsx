'use client'
import { useEffect, useState } from 'react'
import api from '@/lib/api'
import { Skeleton } from '@/components/ui/skeleton'
import Link from 'next/link'
import { usePathname, useRouter } from 'next/navigation'
import { Bell, ChevronDown, Info, LogOut, Menu, UserCog } from 'lucide-react'
import {
    Popover,
    PopoverContent,
    PopoverTrigger,
} from '@/components/ui/popover'
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { Badge } from '@/components/ui/badge'
import { logout } from '@/lib/auth'

const Header = () => {
    const router = useRouter()
    const pathName = usePathname()

    const [user, setUser] = useState<{ firstName: string; lastName: string; email: string } | null>(null)
    const [loading, setLoading] = useState(true)
    const [notifications, setNotifications] = useState<{ id: string; message: string; createdAt: string; isRead: boolean }[]>([])
    const [unreadCount, setUnreadCount] = useState(0)
    const [loadingNotifications, setLoadingNotifications] = useState(true)
    const [displayName, setDisplayName] = useState<string | null>(null);

   
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

    // useEffect(() => {
    //     const fetchNotifications = async () => {
    //         try {
    //             const response = await api.get('/api/notifications')
    //             setNotifications(response.data.notifications)
    //             setUnreadCount(response.data.unreadCount)
    //         } catch (error) {
    //             console.error('Failed to fetch notifications:', error)
    //         } finally {
    //             setLoadingNotifications(false)
    //         }
    //     }
    //     fetchNotifications()
    // }, [])

    useEffect(() => {
        if (user?.firstName || user?.lastName) {
            setDisplayName(`${user.firstName ?? ''} ${user.lastName ?? ''}`.trim());
        } else if (user?.email === 'admin@gulbahartobacco.com') {
            setDisplayName('Admin');
        } else {
            setDisplayName('Sales User');
        }
    }, [user]);

    // const markNotificationsAsRead = async () => {
    //     if (unreadCount === 0) return

    //     try {
    //         await api.patch('/api/notifications')
    //         setUnreadCount(0)
    //         setNotifications((prev) =>
    //             prev.map((n) => ({ ...n, isRead: true })),
    //         )
    //     } catch (error) {
    //         console.error('Failed to mark notifications as read:', error)
    //     }
    // }

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
                        src="/images/gulbahar-logo.png"
                        alt="Brand Logo"
                        className="h-10 w-auto"
                    />
                </Link>

                <div className="inline-flex items-center gap-3 sm:gap-5">
                    {/* <div className="order-2 lg:order-none">
                        <Popover>
                            <PopoverTrigger asChild>
                                <button
                                    type="button"
                                    className="relative duration-300 hover:opacity-80"
                                >
                                    <Bell className="h-5 w-5" />
                                    {unreadCount > 0 && (
                                        <Badge
                                            variant={'primary'}
                                            size={'number'}
                                            className="absolute -right-0.5 -top-0.5 grid h-3 min-w-3 place-content-center px-1 text-[9px]"
                                        >
                                            {unreadCount}
                                        </Badge>
                                    )}
                                </button>
                            </PopoverTrigger>
                            <PopoverContent
                                sideOffset={12}
                                className="mr-4 w-full max-w-80 divide-y divide-gray-300 p-0"
                                onOpenAutoFocus={markNotificationsAsRead}
                            >
                                <div className="rounded-t-lg bg-gray-100 p-3 text-black">
                                    <h2 className="font-semibold leading-5">
                                        Notifications
                                    </h2>
                                </div>
                                <div className="p-4">
                                    {loadingNotifications ? (
                                        <Skeleton className="h-10 w-full rounded-md" />
                                    ) : notifications.length === 0 ? (
                                        <div className="text-center">
                                            <Info className="mx-auto mb-2 h-8 w-8 text-gray-500" />
                                            <p className="text-sm text-gray-500">No notifications</p>
                                        </div>
                                    ) : (
                                        <ul className="space-y-2">
                                            {notifications?.map((notification) => (
                                                <li key={notification.id} className={`p-2 rounded ${notification.isRead ? 'bg-gray-200' : 'bg-gray-100'}`}>
                                                    <p className="text-sm text-gray-800">{notification.message}</p>
                                                    <p className="text-xs text-gray-500">
                                                        {new Date(notification.createdAt).toLocaleString()}
                                                    </p>
                                                </li>
                                            ))}
                                        </ul>
                                    )}
                                </div>
                            </PopoverContent>
                        </Popover>
                    </div> */}

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
                            <DropdownMenuContent align="end" sideOffset={12} className="min-w-[200px] space-y-1 rounded-lg p-1.5 text-sm font-medium">
                                <DropdownMenuItem className="p-0">
                                    <Link href="/setting" className="flex items-center gap-1.5 rounded-lg px-3 py-2">
                                        <UserCog className="size-[18px] shrink-0" />
                                        Profile
                                    </Link>
                                </DropdownMenuItem>
                                <DropdownMenuItem className="p-0">
                                    <Link href="/login" onClick={handleLogout} className="flex items-center gap-1.5 rounded-lg px-3 py-2">
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
