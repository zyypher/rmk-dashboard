'use client'

import {
    Settings,
    Home,
    X,
    GraduationCap,
    Users2,
    BookOpenCheck,
    Building2,
    CalendarClock,
    ScrollText,
    Bell,
    LogOut,
    CircleUserRound,
    AlarmClock,
    Languages,
    Tags,
    MonitorSmartphone,
    CalendarDays,
} from 'lucide-react'
import { useEffect } from 'react'
import { Card } from '@/components/ui/card'
import Link from 'next/link'
import { usePathname, useRouter } from 'next/navigation'
import NavLink from '@/components/layout/nav-link'
import { logout } from '@/lib/auth'

const Sidebar = () => {
    const pathName = usePathname()
    const router = useRouter()

    const toggleSidebarResponsive = () => {
        document.getElementById('sidebar')?.classList.remove('open')
        document.getElementById('overlay')?.classList.toggle('open')
    }

    useEffect(() => {
        if (document?.getElementById('overlay')?.classList?.contains('open')) {
            toggleSidebarResponsive()
        }
    }, [pathName])

    return (
        <>
            <div
                id="overlay"
                className="fixed inset-0 z-30 hidden bg-black/50"
                onClick={toggleSidebarResponsive}
            ></div>
            <Card
                id="sidebar"
                className="sidebar fixed -left-[260px] top-0 z-40 flex h-screen w-[260px] flex-col rounded-none transition-all duration-300 lg:left-0 lg:top-16 lg:h-[calc(100vh_-_64px)]"
            >
                <div className="flex items-start justify-between border-b border-gray-300 px-4 py-5 lg:hidden">
                    <Link href="/" className="inline-block">
                        <img
                            src="/images/rmk-logo-dark.png"
                            alt="RMK Logo"
                            className="h-auto w-auto"
                        />
                    </Link>
                    <button type="button" onClick={toggleSidebarResponsive}>
                        <X className="-mr-2 -mt-2 ml-auto size-4 hover:text-black" />
                    </button>
                </div>

                {/* SIDEBAR NAVIGATION */}
                <div className="grow overflow-y-auto overflow-x-hidden px-2.5 pb-10 pt-2.5 transition-all">
                    <NavLink href="/" className={`nav-link`}>
                        <Home className="size-[18px] shrink-0" />
                        <span>Dashboard</span>
                    </NavLink>

                    <h3 className="mt-2.5 whitespace-nowrap rounded-lg bg-gray-400 px-5 py-2.5 text-xs font-semibold uppercase text-black">
                        Training
                    </h3>
                    <NavLink href="/courses" className="nav-link">
                        <BookOpenCheck className="size-[18px]" />
                        <span>Courses</span>
                    </NavLink>
                    <NavLink href="/categories" className="nav-link">
                        <Tags className="size-[18px]" />
                        <span>Categories</span>
                    </NavLink>
                    <NavLink href="/trainers" className="nav-link">
                        <GraduationCap className="size-[18px]" />
                        <span>Trainers</span>
                    </NavLink>
                    <NavLink href="/scheduling-rules" className="nav-link">
                        <CalendarClock className="size-[18px]" />
                        <span>Scheduling Rules</span>
                    </NavLink>
                    <NavLink href="/trainer-leaves" className="nav-link">
                        <CalendarDays className="size-[18px]" />{' '}
                        <span>Trainer Leaves</span>
                    </NavLink>
                    <NavLink href="/rooms" className="nav-link">
                        <MonitorSmartphone className="size-[18px]" />
                        <span>Rooms</span>
                    </NavLink>
                    <NavLink href="/bookings" className="nav-link">
                        <CalendarClock className="size-[18px]" />{' '}
                        <span>Bookings</span>
                    </NavLink>
                    {/* <NavLink href="/certificates" className="nav-link">
                        <ScrollText className="size-[18px]" />
                        <span>Certificates</span>
                    </NavLink> */}

                    <h3 className="mt-2.5 whitespace-nowrap rounded-lg bg-gray-400 px-5 py-2.5 text-xs font-semibold uppercase text-black">
                        Management
                    </h3>
                    <NavLink href="/clients" className="nav-link">
                        <Users2 className="size-[18px]" />
                        <span>Clients</span>
                    </NavLink>
                    <NavLink href="/locations" className="nav-link">
                        <Building2 className="size-[18px]" />
                        <span>Locations</span>
                    </NavLink>
                    {/* <NavLink href="/reminders" className="nav-link">
                        <AlarmClock className="size-[18px]" />
                        <span>Reminders</span>
                    </NavLink>
                    <NavLink href="/notifications" className="nav-link">
                        <Bell className="size-[18px]" />
                        <span>Notifications</span>
                    </NavLink> */}

                    <h3 className="mt-2.5 whitespace-nowrap rounded-lg bg-gray-400 px-5 py-2.5 text-xs font-semibold uppercase text-black">
                        Admin Tools
                    </h3>
                    <NavLink href="/users" className="nav-link">
                        <CircleUserRound className="size-[18px]" />
                        <span>Users</span>
                    </NavLink>
                    <NavLink href="/languages" className="nav-link">
                        <Languages className="size-[18px]" />
                        <span>Languages</span>
                    </NavLink>
                    <NavLink href="/settings" className="nav-link">
                        <Settings className="size-[18px]" />
                        <span>Settings</span>
                    </NavLink>
                </div>

                {/* MOBILE ONLY PROFILE & LOGOUT */}
                <div className="border-t border-gray-300 px-4 py-5 lg:hidden">
                    <Link
                        href="/settings"
                        className="flex items-center gap-2 py-2 text-sm font-medium text-gray-700 hover:text-black"
                    >
                        <CircleUserRound className="size-[18px]" />
                        Profile
                    </Link>
                    <button
                        type="button"
                        onClick={async () => {
                            await logout()
                            router.push('/login')
                        }}
                        className="flex w-full items-center gap-2 py-2 text-sm font-medium text-gray-700 hover:text-black"
                    >
                        <LogOut className="size-[18px]" />
                        Sign Out
                    </button>
                </div>
            </Card>
        </>
    )
}

export default Sidebar
