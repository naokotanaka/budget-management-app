'use client'

import { useState, useEffect } from 'react'

interface FreeeStatus {
  connected: boolean
  company_id?: string
  expires_at?: string
  message: string
}

interface FreeeJournalEntry {
  id: string
  issue_date: string
  description: string
  total_amount: number
  details: Array<{
    account_item_name: string
    debit_credit: 'debit' | 'credit'
    amount: number
    description?: string
  }>
}

interface SyncResult {
  status: string
  message: string
  imported_count?: number
  journal_entries?: FreeeJournalEntry[]
  journals_data?: any[]
  csv_data?: string
  converted_transactions?: any[]
  needs_reauth?: boolean
}

export default function FreeePage() {
  const [status, setStatus] = useState<FreeeStatus | null>(null)
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState('')
  const [startDate, setStartDate] = useState('')
  const [endDate, setEndDate] = useState('')
  const [syncing, setSyncing] = useState(false)
  const [syncResult, setSyncResult] = useState<SyncResult | null>(null)
  const [journalEntries, setJournalEntries] = useState<FreeeJournalEntry[]>([])

  const fetchStatus = async () => {
    try {
      const apiUrl = process.env.NODE_ENV === 'production' 
        ? 'https://nagaiku.top/budget/api/freee/status'
        : 'http://160.251.170.97:8001/api/freee/status'
      const response = await fetch(apiUrl)
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
      const apiUrl = process.env.NODE_ENV === 'production' 
        ? 'https://nagaiku.top/budget/api/freee/auth'
        : 'http://160.251.170.97:8001/api/freee/auth'
      const response = await fetch(apiUrl)
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

  const handleSync = async () => {
    if (!startDate || !endDate) {
      setMessage('開始日と終了日を指定してください')
      return
    }

    setSyncing(true)
    setMessage('')
    setSyncResult(null)

    try {
      const apiUrl = process.env.NODE_ENV === 'production' 
        ? 'https://nagaiku.top/budget/api/freee/sync'
        : 'http://160.251.170.97:8001/api/freee/sync'
      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          start_date: startDate,
          end_date: endDate,
          preview: true  // 今回は表示のみなので、previewモード
        }),
      })

      const data = await response.json()
      
      if (response.ok) {
        console.log('Sync result data:', data)
        console.log('Journals data:', data.journals_data)
        console.log('CSV data:', data.csv_data)
        console.log('Converted transactions:', data.converted_transactions)
        setSyncResult(data)
        if (data.journal_entries) {
          setJournalEntries(data.journal_entries)
        }
        
        // 再認証が必要かチェック
        if (data.needs_reauth) {
          setMessage('権限が更新されました。新しい権限を有効にするため再認証が必要です。')
        }
      } else {
        setMessage(data.detail || '同期エラーが発生しました')
      }
    } catch (error) {
      setMessage('同期処理中にエラーが発生しました')
    } finally {
      setSyncing(false)
    }
  }

  useEffect(() => {
    fetchStatus()
    // デフォルトの日付範囲を設定（今月の1日から今日まで）
    const today = new Date()
    const firstDay = new Date(today.getFullYear(), today.getMonth(), 1)
    setStartDate(firstDay.toISOString().split('T')[0])
    setEndDate(today.toISOString().split('T')[0])
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
        <div className={`border px-4 py-3 rounded mb-4 ${
          message.includes('再認証が必要') 
            ? 'bg-yellow-100 border-yellow-400 text-yellow-700' 
            : 'bg-red-100 border-red-400 text-red-700'
        }`}>
          {message}
          {message.includes('再認証が必要') && (
            <div className="mt-2">
              <button
                onClick={handleConnect}
                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-1 px-3 rounded text-sm"
              >
                今すぐ再認証
              </button>
            </div>
          )}
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
        <div className="bg-white shadow rounded-lg p-6 mb-6">
          <h2 className="text-xl font-semibold mb-4">仕訳データ同期</h2>
          <p className="text-gray-600 mb-4">
            freee会計から仕訳データを取得して表示します。
          </p>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                開始日
              </label>
              <input
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                終了日
              </label>
              <input
                type="date"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>
          
          <button 
            onClick={handleSync}
            disabled={syncing}
            className={`${
              syncing 
                ? 'bg-gray-400 cursor-not-allowed' 
                : 'bg-green-500 hover:bg-green-700'
            } text-white font-bold py-2 px-4 rounded`}
          >
            {syncing ? 'データ取得中...' : 'データ取得'}
          </button>
        </div>
      )}

      {syncResult && (
        <div className="bg-white shadow rounded-lg p-6 mb-6">
          <h2 className="text-xl font-semibold mb-4">同期結果</h2>
          <p className="text-gray-600 mb-2">
            ステータス: {syncResult.status}
          </p>
          <p className="text-gray-600 mb-4">
            {syncResult.message}
          </p>
          {syncResult.imported_count !== undefined && (
            <p className="text-gray-600 mb-4">
              取得件数: {syncResult.imported_count}件
            </p>
          )}
        </div>
      )}


      {syncResult?.journals_data && syncResult.journals_data.length > 0 && (
        <div className="bg-white shadow rounded-lg p-6 mb-6">
          <h2 className="text-xl font-semibold mb-4">仕訳データ（Freee Journals API）</h2>
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">日付</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">摘要</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">仕訳明細</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">詳細</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {syncResult.journals_data.map((journal: any) => (
                  <tr key={journal.id}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{journal.id}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{journal.issue_date}</td>
                    <td className="px-6 py-4 text-sm text-gray-900">{journal.description || 'N/A'}</td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {journal.details && Array.isArray(journal.details) ? (
                        <div className="space-y-2">
                          {journal.details.map((detail: any, idx: number) => (
                            <div key={idx} className="border-l-2 border-gray-200 pl-2 text-xs">
                              <div className="flex flex-wrap gap-2">
                                <span className="bg-blue-100 px-2 py-1 rounded">
                                  {detail.account_item?.name || `ID:${detail.account_item_id}`}
                                </span>
                                <span className="bg-green-100 px-2 py-1 rounded">¥{detail.amount?.toLocaleString()}</span>
                                <span className={`px-2 py-1 rounded ${detail.entry_side === 'debit' ? 'bg-red-100' : 'bg-yellow-100'}`}>
                                  {detail.entry_side === 'debit' ? '借方' : '貸方'}
                                </span>
                                {detail.description && <span className="bg-gray-100 px-2 py-1 rounded">{detail.description}</span>}
                              </div>
                            </div>
                          ))}
                        </div>
                      ) : 'N/A'}
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      <details className="cursor-pointer">
                        <summary className="text-blue-600 hover:text-blue-800">JSON表示</summary>
                        <pre className="mt-2 bg-gray-100 p-2 rounded text-xs overflow-auto max-h-40">
                          {JSON.stringify(journal, null, 2)}
                        </pre>
                      </details>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {syncResult?.csv_data && (
        <div className="bg-white shadow rounded-lg p-6 mb-6">
          <h2 className="text-xl font-semibold mb-4">仕訳帳データ（CSV形式）</h2>
          <div className="overflow-x-auto">
            <pre className="bg-gray-100 p-4 rounded text-xs overflow-auto max-h-96 whitespace-pre-wrap">
              {syncResult.csv_data}
            </pre>
          </div>
        </div>
      )}

      {syncResult?.converted_transactions && syncResult.converted_transactions.length > 0 && (
        <div className="bg-white shadow rounded-lg p-6 mb-6">
          <h2 className="text-xl font-semibold mb-4">システム形式に変換後の取引データ</h2>
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">日付</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">取引内容</th>
                  <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">金額</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">勘定科目</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">取引先</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">品名</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">部門</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">備考</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">管理番号</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {syncResult.converted_transactions.map((transaction: any, index: number) => (
                  <tr key={index}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {transaction.date}
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {transaction.description || ''}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right">
                      ¥{transaction.amount.toLocaleString()}
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {transaction.account || ''}
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {transaction.supplier || ''}
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {transaction.item || ''}
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {transaction.department || ''}
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900 max-w-xs">
                      <div className="truncate" title={transaction.memo}>
                        {transaction.memo || ''}
                      </div>
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {transaction.management_number || ''}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  )
}