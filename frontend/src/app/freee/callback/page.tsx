'use client'

import { useEffect, useState, Suspense } from 'react'
import { useSearchParams, useRouter } from 'next/navigation'

function FreeeCallbackContent() {
  const [status, setStatus] = useState<'loading' | 'success' | 'error'>('loading')
  const [message, setMessage] = useState('')
  const searchParams = useSearchParams()
  const router = useRouter()

  useEffect(() => {
    const handleCallback = async () => {
      const code = searchParams.get('code')
      const state = searchParams.get('state')
      const error = searchParams.get('error')

      if (error) {
        setStatus('error')
        setMessage(`認証エラー: ${error}`)
        return
      }

      if (!code || !state) {
        setStatus('error')
        setMessage('認証パラメータが不正です')
        return
      }

      try {
        const response = await fetch('/api/freee/callback', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ code, state })
        })

        if (response.ok) {
          const data = await response.json()
          setStatus('success')
          setMessage(data.message)
          
          setTimeout(() => {
            router.push('/freee')
          }, 3000)
        } else {
          const error = await response.json()
          setStatus('error')
          setMessage(error.detail || '認証処理に失敗しました')
        }
      } catch (error) {
        setStatus('error')
        setMessage('認証処理中にエラーが発生しました')
      }
    }

    handleCallback()
  }, [searchParams, router])

  return (
    <div className="container mx-auto p-6 flex items-center justify-center min-h-screen">
      <div className="bg-white shadow rounded-lg p-6 w-full max-w-md text-center">
        <h1 className="text-2xl font-bold mb-4">freee認証処理</h1>
        
        {status === 'loading' && (
          <div>
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
            <p>freee認証を処理しています...</p>
          </div>
        )}
        
        {status === 'success' && (
          <div>
            <div className="text-green-500 text-4xl mb-4">✓</div>
            <h2 className="text-lg font-semibold mb-2">認証が完了しました</h2>
            <p className="text-gray-600 mb-4">{message}</p>
            <p className="text-sm text-gray-500">3秒後にfreee設定画面に移動します...</p>
          </div>
        )}
        
        {status === 'error' && (
          <div>
            <div className="text-red-500 text-4xl mb-4">✗</div>
            <h2 className="text-lg font-semibold mb-2">認証に失敗しました</h2>
            <p className="text-gray-600 mb-4">{message}</p>
            <button 
              onClick={() => router.push('/freee')}
              className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            >
              freee設定画面に戻る
            </button>
          </div>
        )}
      </div>
    </div>
  )
}

export default function FreeeCallbackPage() {
  return (
    <Suspense fallback={
      <div className="container mx-auto p-6 flex items-center justify-center min-h-screen">
        <div className="bg-white shadow rounded-lg p-6 w-full max-w-md text-center">
          <h1 className="text-2xl font-bold mb-4">読み込み中...</h1>
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto"></div>
        </div>
      </div>
    }>
      <FreeeCallbackContent />
    </Suspense>
  )
}