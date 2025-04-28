import type { Metadata } from 'next'
import '@/app/globals.css'
import { Toaster } from 'react-hot-toast'
import 'react-datepicker/dist/react-datepicker.css'

export const metadata: Metadata = {
    title: 'RMK Experts Dashboard',
    description:
        'Manage training sessions, trainers, clients, and operations — all in one place.',
}

export default async function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode
}>) {
    return (
        <html lang="en" className="scroll-smooth">
            <body className="bg-gray-400 font-plus-jakarta text-sm/[22px] font-normal text-gray antialiased">
                {children}
                <Toaster position="top-center" reverseOrder={false} />
            </body>
        </html>
    )
}
