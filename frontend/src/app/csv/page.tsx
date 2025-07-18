'use client';

import { useState, useEffect } from 'react';
import { api } from '@/lib/api';
import { CONFIG } from '@/lib/config';

interface PreviewResult {
  preview: boolean;
  stats: {
    to_delete: number;
    to_update: number;
    to_create: number;
    errors: string[];
    delete_details?: any[];
    update_details?: any[];
    create_details?: any[];
  };
  message: string;
}

export default function CSVManagementPage() {
  const [uploading, setUploading] = useState(false);
  const [downloading, setDownloading] = useState('');
  const [dateRange, setDateRange] = useState({
    startDate: CONFIG.DEFAULT_DATE_RANGE.START,
    endDate: CONFIG.DEFAULT_DATE_RANGE.END
  });

  // 割当インポート関連の状態
  const [allocationImportMode, setAllocationImportMode] = useState<'add' | 'replace'>('add');
  const [previewResult, setPreviewResult] = useState<PreviewResult | null>(null);
  const [showPreview, setShowPreview] = useState(false);
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [backups, setBackups] = useState<any[]>([]);
  const [loadingBackups, setLoadingBackups] = useState(false);

  useEffect(() => {
    // 設定画面から保存された期間設定を取得
    const savedDateFilter = sessionStorage.getItem('transactionDateFilter');
    if (savedDateFilter) {
      try {
        const filterSettings = JSON.parse(savedDateFilter);
        if (filterSettings.startDate && filterSettings.endDate) {
          setDateRange({
            startDate: filterSettings.startDate,
            endDate: filterSettings.endDate
          });
        }
      } catch (error) {
        console.error('Failed to parse date filter settings:', error);
      }
    }
    
    // バックアップ一覧を読み込み
    loadBackups();
  }, []);

  const loadBackups = async () => {
    try {
      setLoadingBackups(true);
      const result = await api.getAllocationBackups();
      setBackups(result.backups || []);
    } catch (error) {
      console.error('Failed to load backups:', error);
    } finally {
      setLoadingBackups(false);
    }
  };

  const handleFileUpload = async (event: React.ChangeEvent<HTMLInputElement>, type: string) => {
    const file = event.target.files?.[0];
    if (!file) return;

    // 割当データで完全置換モードの場合は、まずプレビューを表示
    if (type === 'allocations' && allocationImportMode === 'replace') {
      setSelectedFile(file);
      await handlePreviewAllocations(file);
      return;
    }

    setUploading(true);
    try {
      let result;
      let message;
      
      switch (type) {
        case 'transactions':
          result = await api.importTransactions(file);
          message = `取引データのインポートが完了しました。インポート: ${result.imported_count}件`;
          if (result.updated_count > 0) {
            message += `, 更新: ${result.updated_count}件`;
          }
          if (result.created_count > 0) {
            message += `, 作成: ${result.created_count}件`;
          }
          break;
        case 'grants-budget':
          result = await api.importGrantsBudget(file);
          message = `助成金・予算項目データのインポートが完了しました。助成金: 作成${result.stats.grants_created}件/更新${result.stats.grants_updated}件, 予算項目: 作成${result.stats.budget_items_created}件/更新${result.stats.budget_items_updated}件`;
          break;
        case 'allocations':
          result = await api.importAllocations(file);
          message = `割当データのインポートが完了しました。作成: ${result.stats.allocations_created}件, 更新: ${result.stats.allocations_updated}件`;
          break;
        default:
          throw new Error('サポートされていないファイル形式です。');
      }

      if (result.stats && result.stats.errors && result.stats.errors.length > 0) {
        message += `\n注意: ${result.stats.errors.length}件のエラーがありました`;
        console.warn('Import errors:', result.stats.errors);
      }
      
      alert(message);
      
    } catch (error) {
      console.error('CSV import error:', error);
      alert('CSVインポートに失敗しました: ' + (error as Error).message);
    } finally {
      setUploading(false);
      // input要素をリセット
      if (event.target) {
        event.target.value = '';
      }
    }
  };

  const handlePreviewAllocations = async (file: File) => {
    try {
      setUploading(true);
      const result = await api.importAllocationsReplace(file, true, true);
      setPreviewResult(result);
      setShowPreview(true);
    } catch (error) {
      console.error('Preview error:', error);
      alert('プレビューに失敗しました: ' + (error as Error).message);
    } finally {
      setUploading(false);
    }
  };

  const handleConfirmImport = async () => {
    if (!selectedFile) return;

    try {
      setUploading(true);
      const result = await api.importAllocationsReplace(selectedFile, false, true);
      
      alert(`完全置換が完了しました。\n${result.message}\n${result.backup_id ? `バックアップID: ${result.backup_id}` : ''}`);
      
      // プレビューをクリア
      setShowPreview(false);
      setPreviewResult(null);
      setSelectedFile(null);
      
      // バックアップ一覧を更新
      await loadBackups();
      
    } catch (error) {
      console.error('Import error:', error);
      alert('インポートに失敗しました: ' + (error as Error).message);
    } finally {
      setUploading(false);
    }
  };

  const handleCancelPreview = () => {
    setShowPreview(false);
    setPreviewResult(null);
    setSelectedFile(null);
  };

  const handleRestoreBackup = async (backupId: string) => {
    if (!confirm(`バックアップ ${backupId} から復元しますか？現在のデータは失われます。`)) {
      return;
    }

    try {
      setUploading(true);
      const result = await api.restoreAllocationBackup(backupId);
      alert(`復元が完了しました。\n${result.message}`);
      await loadBackups();
    } catch (error) {
      console.error('Restore error:', error);
      alert('復元に失敗しました: ' + (error as Error).message);
    } finally {
      setUploading(false);
    }
  };

  const handleDownload = async (type: string) => {
    try {
      setDownloading(type);
      
      let blob;
      let filename;
      let description;

      switch (type) {
        case 'grants-budget':
          blob = await api.exportGrantsBudgetAllocations();
          filename = `grants_budget_${new Date().toISOString().split('T')[0]}.csv`;
          description = '助成金・予算項目データ';
          break;
        case 'allocations':
          blob = await api.exportAllocations(dateRange.startDate, dateRange.endDate);
          filename = `allocations_${new Date().toISOString().split('T')[0]}.csv`;
          description = '割当データ';
          break;
        case 'all-data':
          blob = await api.exportAllData(dateRange.startDate, dateRange.endDate);
          filename = `all_data_${new Date().toISOString().split('T')[0]}.csv`;
          description = '全データ';
          break;
        default:
          throw new Error('サポートされていないエクスポート形式です。');
      }

      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
      
      alert(`${description}のエクスポートが完了しました。`);
      
    } catch (error) {
      console.error('Export error:', error);
      alert('エクスポートに失敗しました: ' + (error as Error).message);
    } finally {
      setDownloading('');
    }
  };

  return (
    <div className="px-4 py-6 sm:px-0">
      <div className="border-b border-gray-200 pb-4 mb-8">
        <h1 className="text-2xl font-bold text-gray-900">CSV管理</h1>
        <p className="mt-2 text-sm text-gray-600">
          各種データのCSVファイルを取り込みます
        </p>
      </div>

      <div className="space-y-8">
        {/* インポートセクション */}
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">データインポート</h2>
          
          <div className="space-y-6">
            {/* freee取引データ */}
            <div className="border border-gray-200 rounded-lg p-4">
              <h3 className="font-medium text-gray-900 mb-2">freee取引データ</h3>
              <p className="text-sm text-gray-600 mb-2">freeeからダウンロードした取引データCSVファイル</p>
              
              {/* freeeダウンロード手順 */}
              <div className="bg-blue-50 border border-blue-200 rounded-md p-3 mb-4">
                <h4 className="text-sm font-semibold text-blue-900 mb-2">freeeからのダウンロード手順</h4>
                <ol className="text-xs text-blue-800 space-y-1 list-decimal list-inside">
                  <li>
                    <a 
                      href={`https://secure.freee.co.jp/reports/journals/export?page=1&per_page=50&order_by=txn_date&direction=asc&end_date=${dateRange.endDate}&start_date=${dateRange.startDate}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="underline hover:text-blue-900"
                    >
                      freeeの仕訳帳エクスポートページ
                    </a>
                    へアクセス
                  </li>
                  <li>テンプレートの選択: <span className="font-semibold">「予算用 分割無し」</span>を選択</li>
                  <li>文字コード: <span className="font-semibold">「UTF-8(BOMつき)」</span>を選択</li>
                  <li>「ダウンロード」ボタンをクリック</li>
                </ol>
                <p className="text-xs text-blue-700 mt-2">
                  ※ 期間: {dateRange.startDate} 〜 {dateRange.endDate}
                </p>
              </div>
              <div className="flex items-center justify-center w-full">
                <label 
                  htmlFor="transaction-upload" 
                  className="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors"
                >
                  <div className="flex flex-col items-center justify-center pt-5 pb-6">
                    <svg className="w-6 h-6 mb-2 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                    </svg>
                    <p className="text-sm text-gray-500">{uploading ? 'アップロード中...' : 'ファイルを選択'}</p>
                  </div>
                  <input 
                    id="transaction-upload" 
                    type="file" 
                    accept=".csv"
                    onChange={(e) => handleFileUpload(e, 'transactions')}
                    disabled={uploading}
                    className="hidden" 
                  />
                </label>
              </div>
            </div>

            {/* 助成金・予算項目データ */}
            <div className="border border-gray-200 rounded-lg p-4">
              <h3 className="font-medium text-gray-900 mb-2">助成金・予算項目データ</h3>
              <p className="text-sm text-gray-600 mb-4">助成金情報と予算項目データのCSVファイル</p>
              <div className="flex items-center justify-center w-full">
                <label 
                  htmlFor="grants-budget-upload" 
                  className="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors"
                >
                  <div className="flex flex-col items-center justify-center pt-5 pb-6">
                    <svg className="w-6 h-6 mb-2 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                    </svg>
                    <p className="text-sm text-gray-500">{uploading ? 'アップロード中...' : 'ファイルを選択'}</p>
                  </div>
                  <input 
                    id="grants-budget-upload" 
                    type="file" 
                    accept=".csv"
                    onChange={(e) => handleFileUpload(e, 'grants-budget')}
                    disabled={uploading}
                    className="hidden" 
                  />
                </label>
              </div>
            </div>

            {/* 割当データ */}
            <div className="border border-gray-200 rounded-lg p-4">
              <h3 className="font-medium text-gray-900 mb-2">割当データ</h3>
              <p className="text-sm text-gray-600 mb-4">取引と予算項目の割当データCSVファイル</p>
              
              {/* インポートモード選択 */}
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">インポートモード</label>
                <div className="space-y-2">
                  <label className="flex items-center">
                    <input
                      type="radio"
                      value="add"
                      checked={allocationImportMode === 'add'}
                      onChange={(e) => setAllocationImportMode(e.target.value as 'add' | 'replace')}
                      className="mr-2"
                    />
                    <span className="text-sm">追加モード（既存データを保持）</span>
                  </label>
                  <label className="flex items-center">
                    <input
                      type="radio"
                      value="replace"
                      checked={allocationImportMode === 'replace'}
                      onChange={(e) => setAllocationImportMode(e.target.value as 'add' | 'replace')}
                      className="mr-2"
                    />
                    <span className="text-sm text-orange-600">完全置換モード（削除機能付き）</span>
                  </label>
                </div>
                {allocationImportMode === 'replace' && (
                  <div className="mt-2 p-3 bg-orange-50 border border-orange-200 rounded-md">
                    <p className="text-xs text-orange-800">
                      ⚠️ <strong>完全置換モード：</strong>CSVにない割当データは自動削除されます。<br/>
                      事前にバックアップが作成され、プレビューで確認後に実行されます。
                    </p>
                  </div>
                )}
              </div>

              <div className="flex items-center justify-center w-full">
                <label 
                  htmlFor="allocations-upload" 
                  className="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors"
                >
                  <div className="flex flex-col items-center justify-center pt-5 pb-6">
                    <svg className="w-6 h-6 mb-2 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                    </svg>
                    <p className="text-sm text-gray-500">
                      {uploading ? 'アップロード中...' : 
                       allocationImportMode === 'replace' ? 'ファイルを選択（プレビュー表示）' : 'ファイルを選択'}
                    </p>
                  </div>
                  <input 
                    id="allocations-upload" 
                    type="file" 
                    accept=".csv"
                    onChange={(e) => handleFileUpload(e, 'allocations')}
                    disabled={uploading}
                    className="hidden" 
                  />
                </label>
              </div>
            </div>
          </div>
            
            <div className="bg-blue-50 border border-blue-200 rounded-md p-4">
              <div className="flex">
                <div className="flex-shrink-0">
                  <svg className="h-5 w-5 text-blue-400" viewBox="0 0 20 20" fill="currentColor">
                    <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd" />
                  </svg>
                </div>
                <div className="ml-3">
                  <h3 className="text-sm font-medium text-blue-800">対応ファイル形式</h3>
                  <div className="mt-2 text-sm text-blue-700">
                    <ul className="list-disc list-inside space-y-1">
                      <li>freee取引データ（仕訳番号、取引日、借方勘定科目など）</li>
                      <li>助成金・予算項目データ（[助成金データ] + [予算項目データ] セクション形式）</li>
                      <li>割当データ（ID,取引ID,予算項目ID,金額 形式）</li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
        </div>

        {/* エクスポートセクション */}
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">データエクスポート</h2>
          
          {/* 期間表示 */}
          <div className="mb-6 p-4 bg-gray-50 rounded-lg">
            <p className="text-sm text-gray-600">
              <span className="font-semibold">エクスポート期間:</span> 
              {dateRange.startDate} 〜 {dateRange.endDate}
            </p>
            <p className="text-xs text-gray-500 mt-1">
              ※ 割当データ・全データはこの期間のデータのみダウンロードされます
            </p>
            <p className="text-xs text-gray-500">
              ※ 助成金・予算項目は報告終了以外のデータがダウンロードされます
            </p>
            <p className="text-xs text-gray-500 mt-2">
              期間を変更するには、設定画面から行ってください
            </p>
          </div>
          
          <div className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <button
                onClick={() => handleDownload('grants-budget')}
                disabled={downloading === 'grants-budget'}
                className="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 disabled:opacity-50"
              >
                {downloading === 'grants-budget' ? 'ダウンロード中...' : '助成金・予算項目'}
              </button>
              
              <button
                onClick={() => handleDownload('allocations')}
                disabled={downloading === 'allocations'}
                className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50"
              >
                {downloading === 'allocations' ? 'ダウンロード中...' : '割当データ'}
              </button>
              
              <button
                onClick={() => handleDownload('all-data')}
                disabled={downloading === 'all-data'}
                className="px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700 disabled:opacity-50"
              >
                {downloading === 'all-data' ? 'ダウンロード中...' : '全データ'}
              </button>
            </div>
          </div>
        </div>

        {/* バックアップ管理セクション */}
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">割当データバックアップ管理</h2>
          
          {loadingBackups ? (
            <div className="text-center py-4">
              <p className="text-sm text-gray-500">読み込み中...</p>
            </div>
          ) : backups.length === 0 ? (
            <div className="text-center py-4">
              <p className="text-sm text-gray-500">バックアップはありません</p>
            </div>
          ) : (
            <div className="space-y-2">
              {backups.map((backup) => (
                <div key={backup.table_name} className="flex items-center justify-between p-3 border border-gray-200 rounded-lg">
                  <div>
                    <p className="text-sm font-medium text-gray-900">
                      {new Date(backup.created_at).toLocaleString('ja-JP')}
                    </p>
                    <p className="text-xs text-gray-500">
                      {backup.record_count}件のデータ
                    </p>
                  </div>
                  <button
                    onClick={() => handleRestoreBackup(backup.timestamp)}
                    disabled={uploading}
                    className="px-3 py-1 text-xs bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50"
                  >
                    復元
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* プレビューダイアログ */}
      {showPreview && previewResult && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-11/12 max-w-2xl shadow-lg rounded-md bg-white">
            <div className="mt-3">
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                完全置換プレビュー
              </h3>
              
              <div className="mb-6">
                <div className="grid grid-cols-3 gap-4 mb-4">
                  <div className="text-center p-3 bg-red-50 border border-red-200 rounded-lg">
                    <div className="text-2xl font-bold text-red-600">
                      {previewResult.stats.to_delete}
                    </div>
                    <div className="text-sm text-red-600">削除</div>
                  </div>
                  <div className="text-center p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
                    <div className="text-2xl font-bold text-yellow-600">
                      {previewResult.stats.to_update}
                    </div>
                    <div className="text-sm text-yellow-600">更新</div>
                  </div>
                  <div className="text-center p-3 bg-green-50 border border-green-200 rounded-lg">
                    <div className="text-2xl font-bold text-green-600">
                      {previewResult.stats.to_create}
                    </div>
                    <div className="text-sm text-green-600">作成</div>
                  </div>
                </div>
                
                <p className="text-sm text-gray-600 mb-4">
                  {previewResult.message}
                </p>
                
                {previewResult.stats.errors.length > 0 && (
                  <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-md">
                    <h4 className="text-sm font-medium text-red-800 mb-2">
                      エラー ({previewResult.stats.errors.length}件)
                    </h4>
                    <div className="max-h-32 overflow-y-auto">
                      {previewResult.stats.errors.map((error, index) => (
                        <p key={index} className="text-xs text-red-700 mb-1">
                          {error}
                        </p>
                      ))}
                    </div>
                  </div>
                )}
              </div>

              <div className="flex items-center justify-end space-x-3">
                <button
                  onClick={handleCancelPreview}
                  className="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-200 rounded-md hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500"
                >
                  キャンセル
                </button>
                <button
                  onClick={handleConfirmImport}
                  disabled={uploading || previewResult.stats.errors.length > 0}
                  className="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {uploading ? '実行中...' : '完全置換を実行'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}