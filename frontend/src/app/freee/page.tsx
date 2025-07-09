'use client'

import { useState, useEffect } from 'react'

interface FreeeStatus {
  connected: boolean
  company_id?: string
  expires_at?: string
  message: string
}

export default function FreeePage() {
  const [status, setStatus] = useState<FreeeStatus | null>(null)
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState('')

  const fetchStatus = async () => {
    try {
      const response = await fetch('/api/freee/status')
      if (response.ok) {
        const data = await response.json()
        setStatus(data)
      } else {
        setMessage('freee APIエラーが発生しました')
      }
    } catch (error) {
      setMessage('接続エラーが発生しました')
    } finally {
      setLoading(false)
    }
  }

  const handleConnect = async () => {
    try {
      const response = await fetch('/api/freee/auth')
      if (response.ok) {
        const data = await response.json()
        window.location.href = data.auth_url
      } else {
        setMessage('認証URL取得に失敗しました')
      }
    } catch (error) {
      setMessage('認証エラーが発生しました')
    }
  }

  useEffect(() => {
    fetchStatus()
  }, [])

  if (loading) {
    return (
      <div className="container mx-auto p-6">
        <h1 className="text-3xl font-bold mb-6">freee連携設定</h1>
        <p>読み込み中...</p>
      </div>
    )
  }

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-3xl font-bold mb-6">freee連携設定</h1>
      
      {message && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
          {message}
        </div>
      )}

      <div className="bg-white shadow rounded-lg p-6 mb-6">
        <h2 className="text-xl font-semibold mb-4">接続状況</h2>
        
        {status ? (
          <div>
            <div className="mb-4">
              <span className="inline-block px-3 py-1 rounded-full text-sm font-medium">
                {status.connected ? (
                  <span className="bg-green-100 text-green-800">✓ 接続済み</span>
                ) : (
                  <span className="bg-red-100 text-red-800">✗ 未接続</span>
                )}
              </span>
            </div>
            
            <p className="text-gray-600 mb-4">{status.message}</p>
            
            {status.company_id && (
              <p className="text-sm text-gray-500 mb-2">
                会社ID: {status.company_id}
              </p>
            )}
            
            {status.expires_at && (
              <p className="text-sm text-gray-500 mb-4">
                有効期限: {new Date(status.expires_at).toLocaleString('ja-JP')}
              </p>
            )}

            {!status.connected && (
              <button
                onClick={handleConnect}
                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
              >
                freeeに接続
              </button>
            )}
          </div>
        ) : (
          <p className="text-gray-500">状況を取得できませんでした</p>
        )}
      </div>

      {status?.connected && (
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-xl font-semibold mb-4">仕訳データ同期</h2>
          <p className="text-gray-600 mb-4">
            freee会計から仕訳データを取得して同期します。
          </p>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                開始日
              </label>
              <input
                type="date"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                終了日
              </label>
              <input
                type="date"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>
          
          <button className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">
            同期実行
          </button>
        </div>
      )}
    </div>
  )
}