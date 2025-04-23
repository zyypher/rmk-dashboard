'use client'

import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Plus } from 'lucide-react'
import { Dialog } from '@/components/ui/dialog'
import { Skeleton } from '@/components/ui/skeleton'

type Category = {
  id: string
  name: string
}

const CategoriesPage = () => {
  const [categories, setCategories] = useState<Category[]>([])
  const [newCategory, setNewCategory] = useState('')
  const [loading, setLoading] = useState(true)
  const [dialogOpen, setDialogOpen] = useState(false)
  const [categoryToDelete, setCategoryToDelete] = useState<Category | null>(null)
  const [addLoading, setAddLoading] = useState(false)
  const [deleteLoading, setDeleteLoading] = useState(false)

  const fetchCategories = async () => {
    setLoading(true)
    try {
      const response = await axios.get('/api/categories')
      setCategories(response.data)
    } catch (error) {
      toast.error('Failed to fetch categories')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchCategories()
  }, [])

  const handleAddCategory = async () => {
    if (!newCategory.trim()) {
      toast.error('Category name cannot be empty')
      return
    }

    setAddLoading(true)
    try {
      await axios.post('/api/categories', { name: newCategory.trim() })
      toast.success('Category added successfully')
      setNewCategory('')
      fetchCategories()
    } catch (error) {
      toast.error('Failed to add category')
    } finally {
      setAddLoading(false)
    }
  }

  const confirmDeleteCategory = (category: Category) => {
    setCategoryToDelete(category)
    setDialogOpen(true)
  }

  const handleDeleteCategory = async () => {
    if (!categoryToDelete) return

    setDeleteLoading(true)
    try {
      await axios.delete(`/api/categories/${categoryToDelete.id}`)
      toast.success('Category deleted successfully')
      fetchCategories()
    } catch (error) {
      toast.error('Failed to delete category')
    } finally {
      setDeleteLoading(false)
      setDialogOpen(false)
      setCategoryToDelete(null)
    }
  }

  return (
    <div className="space-y-6 p-6">
      <h1 className="text-2xl font-bold">Categories</h1>

      <div className="flex items-center gap-4">
        <Input
          placeholder="Enter category name"
          value={newCategory}
          onChange={(e) => setNewCategory(e.target.value)}
        />
        <Button onClick={handleAddCategory} disabled={addLoading}>
          {addLoading ? (
            <div className="loader" />
          ) : (
            <>
              <Plus className="mr-2 h-4 w-4" />
              Add Category
            </>
          )}
        </Button>
      </div>

      {loading ? (
        <div className="mt-4 flex flex-wrap gap-2">
          {Array.from({ length: 4 }).map((_, i) => (
            <Skeleton key={i} className="h-8 w-28 rounded-full" />
          ))}
        </div>
      ) : (
        <div className="mt-4 flex flex-wrap gap-2">
          {categories.map((category) => (
            <div
              key={category.id}
              className="text-gray-800 flex items-center gap-2 rounded-full border border-gray-300 bg-white px-4 py-1 text-sm shadow-sm"
            >
              <span>{category.name}</span>
              <button
                onClick={() => confirmDeleteCategory(category)}
                className="text-red-500 hover:text-red-700 font-bold"
                title="Delete"
              >
                ✕
              </button>
            </div>
          ))}
        </div>
      )}

      <Dialog
        isOpen={dialogOpen}
        onClose={() => setDialogOpen(false)}
        title="Delete Category"
        onSubmit={handleDeleteCategory}
        buttonLoading={deleteLoading}
      >
        <div className="text-sm">
          Are you sure you want to delete{' '}
          <span className="text-red-600 font-semibold">{categoryToDelete?.name}</span>?
        </div>
      </Dialog>
    </div>
  )
}

export default CategoriesPage
