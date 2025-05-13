'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Plus } from 'lucide-react'
import { Dialog } from '@/components/ui/dialog'
import { Skeleton } from '@/components/ui/skeleton'
import { useUserRole } from '@/hooks/useUserRole'

type Language = {
    id: string
    name: string
}

const LanguagesPage = () => {
    const [languages, setLanguages] = useState<Language[]>([])
    const [newLanguage, setNewLanguage] = useState('')
    const [loading, setLoading] = useState(true)
    const [dialogOpen, setDialogOpen] = useState(false)
    const [languageToDelete, setLanguageToDelete] = useState<Language | null>(
        null,
    )
    const [addLoading, setAddLoading] = useState(false)
    const [deleteLoading, setDeleteLoading] = useState(false)
    const role = useUserRole()
    const isAllowed = role === 'ADMIN' || role === 'EDITOR'

    const fetchLanguages = async () => {
        setLoading(true)
        try {
            const response = await axios.get('/api/languages')
            setLanguages(response.data)
        } catch (error) {
            toast.error('Failed to fetch languages')
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        fetchLanguages()
    }, [])

    const handleAddLanguage = async () => {
        if (!newLanguage.trim()) {
            toast.error('Language name cannot be empty')
            return
        }

        setAddLoading(true)
        try {
            await axios.post('/api/languages', { name: newLanguage.trim() })
            toast.success('Language added successfully')
            setNewLanguage('')
            fetchLanguages()
        } catch (error) {
            toast.error('Failed to add language')
        } finally {
            setAddLoading(false)
        }
    }

    const confirmDeleteLanguage = (language: Language) => {
        setLanguageToDelete(language)
        setDialogOpen(true)
    }

    const handleDeleteLanguage = async () => {
        if (!languageToDelete) return

        setDeleteLoading(true)
        try {
            await axios.delete(`/api/languages/${languageToDelete.id}`)
            toast.success('Language deleted successfully')
            fetchLanguages()
        } catch (error) {
            toast.error('Failed to delete language')
        } finally {
            setDeleteLoading(false)
            setDialogOpen(false)
            setLanguageToDelete(null)
        }
    }

    return (
        <div className="space-y-6 p-6">
            <h1 className="text-2xl font-bold">Languages</h1>

            <div className="flex items-center gap-4">
                <Input
                    placeholder="Enter language name"
                    value={newLanguage}
                    onChange={(e) => setNewLanguage(e.target.value)}
                />

                {isAllowed && (
                    <Button onClick={handleAddLanguage} disabled={addLoading}>
                        {addLoading ? (
                            <div className="loader" />
                        ) : (
                            <>
                                <Plus className="mr-2 h-4 w-4" />
                                Add Language
                            </>
                        )}
                    </Button>
                )}
            </div>

            {loading ? (
                <div className="mt-4 flex flex-wrap gap-2">
                    {Array.from({ length: 4 }).map((_, i) => (
                        <Skeleton key={i} className="h-8 w-24 rounded-full" />
                    ))}
                </div>
            ) : (
                <div className="mt-4 flex flex-wrap gap-2">
                    {languages.map((language) => (
                        <div
                            key={language.id}
                            className="flex items-center gap-2 rounded-full border border-gray-300 bg-white px-4 py-1 text-sm text-gray-800 shadow-sm"
                        >
                            <span>{language.name}</span>
                            {isAllowed && (
                                <button
                                    onClick={() =>
                                        confirmDeleteLanguage(language)
                                    }
                                    className="font-bold text-red-500 hover:text-red-700"
                                    title="Delete"
                                    style={{ color: '#de4141' }}
                                >
                                    ✕
                                </button>
                            )}
                        </div>
                    ))}
                </div>
            )}

            <Dialog
                isOpen={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title="Delete Language"
                onSubmit={handleDeleteLanguage}
                buttonLoading={deleteLoading}
            >
                <div className="text-sm">
                    Are you sure you want to delete{' '}
                    <span className="font-semibold text-red-600">
                        {languageToDelete?.name}
                    </span>
                    ?
                </div>
            </Dialog>
        </div>
    )
}

export default LanguagesPage
