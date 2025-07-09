'use client';

import { useState, useEffect } from 'react';
import { api } from '@/lib/api';
import { CONFIG } from '@/lib/config';

export default function CSVManagementPage() {
  const [uploading, setUploading] = useState(false);
  const [downloading, setDownloading] = useState('');
  const [dateRange, setDateRange] = useState({
    startDate: CONFIG.DEFAULT_DATE_RANGE.START,
    endDate: CONFIG.DEFAULT_DATE_RANGE.END
  });

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
  }, []);

  const handleFileUpload = async (event: React.ChangeEvent<HTMLInputElement>, type: string) => {
    const file = event.target.files?.[0];
    if (!file) return;

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
              <div className="flex items-center justify-center w-full">
                <label 
                  htmlFor="allocations-upload" 
                  className="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors"
                >
                  <div className="flex flex-col items-center justify-center pt-5 pb-6">
                    <svg className="w-6 h-6 mb-2 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                    </svg>
                    <p className="text-sm text-gray-500">{uploading ? 'アップロード中...' : 'ファイルを選択'}</p>
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
      </div>
    </div>
  );
}