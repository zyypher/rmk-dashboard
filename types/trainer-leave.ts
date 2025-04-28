export interface TrainerLeave {
    id: string
    trainerId: string
    date: string
    reason?: string
    trainer: {
        name: string
    }
}
