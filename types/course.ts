export interface Course {
    id: string
    title: string
    duration: string
    languages: string[]
    isCertified: boolean
    isPublic: boolean
    trainerId: string
    categoryId: string
    trainer: { name: string }
    category: { name: string }
}
