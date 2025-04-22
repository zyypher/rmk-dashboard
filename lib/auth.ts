import api from '@/lib/api'
import routes from '@/lib/routes'

export const logout = async () => {
    try {
        await api.post(routes.logout)
        localStorage.removeItem('token')
    } catch (error) {}
}
