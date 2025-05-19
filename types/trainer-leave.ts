export interface TrainerLeave {
    id: string
    trainerId: string
    trainer: { name: string }
    startDate: string
    endDate: string
    reason?: string
}
