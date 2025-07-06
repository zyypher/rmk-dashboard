import axios from 'axios'

/**
 * Makes an API call with cache-busting headers and parameters
 * @param url - The API endpoint URL
 * @param options - Additional axios options
 * @returns Promise with the API response
 */
export const apiCall = async (url: string, options: any = {}) => {
    const timestamp = Date.now()
    const separator = url.includes('?') ? '&' : '?'
    const cacheBustedUrl = `${url}${separator}t=${timestamp}`
    
    return axios.get(cacheBustedUrl, {
        headers: {
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
            ...options.headers,
        },
        ...options,
    })
}

/**
 * Makes a POST API call with cache-busting headers
 * @param url - The API endpoint URL
 * @param data - The data to send
 * @param options - Additional axios options
 * @returns Promise with the API response
 */
export const apiPost = async (url: string, data: any, options: any = {}) => {
    return axios.post(url, data, {
        headers: {
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
            ...options.headers,
        },
        ...options,
    })
}

/**
 * Makes a PUT API call with cache-busting headers
 * @param url - The API endpoint URL
 * @param data - The data to send
 * @param options - Additional axios options
 * @returns Promise with the API response
 */
export const apiPut = async (url: string, data: any, options: any = {}) => {
    return axios.put(url, data, {
        headers: {
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
            ...options.headers,
        },
        ...options,
    })
}

/**
 * Makes a DELETE API call with cache-busting headers
 * @param url - The API endpoint URL
 * @param options - Additional axios options
 * @returns Promise with the API response
 */
export const apiDelete = async (url: string, options: any = {}) => {
    return axios.delete(url, {
        headers: {
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
            ...options.headers,
        },
        ...options,
    })
} 