'use client';

import React, { useState } from 'react';
import { api } from '@/lib/api';
import { CONFIG } from '@/lib/config';

const SettingsPage: React.FC = () => {
  const [resetting, setResetting] = useState(false);
  const [showResetConfirm, setShowResetConfirm] = useState(false);
  const [confirmText, setConfirmText] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  
  // 期間フィルター設定
  const [defaultStartDate, setDefaultStartDate] = useState(CONFIG.DEFAULT_DATE_RANGE.START);
  const [defaultEndDate, setDefaultEndDate] = useState(CONFIG.DEFAULT_DATE_RANGE.END);
  const [filterSuccess, setFilterSuccess] = useState<string | null>(null);

  const handleResetAllData = async () => {
    if (confirmText !== '全削除') {
      setError('確認テキストが正しくありません');
      return;
    }

    setResetting(true);
    setError(null);
    
    try {
      await api.resetAllData();
      
      // LocalStorageキャッシュをクリア
      // localStorageは使用しない
      sessionStorage.clear();
      
      setSuccess('全データが正常に削除されました（キャッシュもクリアしました）');
      setShowResetConfirm(false);
      setConfirmText('');
    } catch (err) {
      console.error('Reset failed:', err);
      setError(err instanceof Error ? err.message : 'データのリセットに失敗しました');
    } finally {
      setResetting(false);
    }
  };

  const applyDateRangeToTransactions = () => {
    // localStorage に設定を保存して、取引一覧画面で参照できるようにする
    const filterSettings = {
      startDate: defaultStartDate,
      endDate: defaultEndDate,
      appliedAt: new Date().toISOString()
    };
    
    sessionStorage.setItem('transactionDateFilter', JSON.stringify(filterSettings));
    setFilterSuccess('期間フィルターが適用されました。取引一覧ページを更新してください。');
    
    // 成功メッセージを3秒後に消す
    setTimeout(() => setFilterSuccess(null), 3000);
  };

  const clearDateFilter = () => {
    sessionStorage.removeItem('transactionDateFilter');
    setFilterSuccess('期間フィルターがクリアされました。');
    setTimeout(() => setFilterSuccess(null), 3000);
  };

  const setCurrentFiscalYear = () => {
    const now = new Date();
    const currentYear = now.getFullYear();
    const currentMonth = now.getMonth() + 1;
    
    // 4月始まりの年度計算
    const fiscalYear = currentMonth >= 4 ? currentYear : currentYear - 1;
    const fiscalStart = `${fiscalYear}-04-01`;
    const fiscalEnd = `${fiscalYear + 1}-03-31`;
    
    setDefaultStartDate(fiscalStart);
    setDefaultEndDate(fiscalEnd);
  };

  const downloadSpecification = () => {
    // フロントエンドのpublicディレクトリから直接ダウンロード
    const link = document.createElement('a');
    link.href = '/SYSTEM_SPECIFICATION.md';
    link.download = 'NPO予算管理システム_仕様書.md';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="px-4 py-6 sm:px-0">
      <div className="border-b border-gray-200 pb-4 mb-6">
        <h1 className="text-2xl font-bold text-gray-900">システム設定</h1>
        <p className="mt-2 text-sm text-gray-600">
          システムの設定と管理機能
        </p>
      </div>

      {/* 成功メッセージ */}
      {(success || filterSuccess) && (
        <div className="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
          <div className="flex items-center">
            <div className="text-green-500 text-xl mr-3">✓</div>
            <p className="text-green-800 font-medium">{success || filterSuccess}</p>
          </div>
        </div>
      )}

      {/* エラーメッセージ */}
      {error && (
        <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
          <div className="flex items-center">
            <div className="text-red-500 text-xl mr-3">⚠️</div>
            <p className="text-red-800 font-medium">{error}</p>
          </div>
        </div>
      )}

      {/* 期間フィルター設定セクション */}
      <div className="bg-white rounded-lg shadow mb-6">
        <div className="px-6 py-4 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900">期間フィルター設定</h2>
        </div>
        <div className="p-6">
          <div className="mb-6">
            <h3 className="text-lg font-medium text-gray-900 mb-2">取引一覧の表示期間</h3>
            <p className="text-sm text-gray-600 mb-4">
              取引一覧画面で表示する期間を設定します。設定後、取引一覧ページを更新してください。
            </p>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  開始日
                </label>
                <input
                  type="date"
                  value={defaultStartDate}
                  onChange={(e) => setDefaultStartDate(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  終了日
                </label>
                <input
                  type="date"
                  value={defaultEndDate}
                  onChange={(e) => setDefaultEndDate(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
            </div>
            
            <div className="flex flex-wrap gap-2 mb-4">
              <button
                onClick={() => {
                  setDefaultStartDate(CONFIG.DEFAULT_DATE_RANGE.START);
                  setDefaultEndDate(CONFIG.DEFAULT_DATE_RANGE.END);
                }}
                className="px-3 py-1 text-xs bg-blue-100 text-blue-700 rounded hover:bg-blue-200"
              >
                デフォルト期間 (2025/4-2026/3)
              </button>
              <button
                onClick={setCurrentFiscalYear}
                className="px-3 py-1 text-xs bg-green-100 text-green-700 rounded hover:bg-green-200"
              >
                今年度
              </button>
            </div>
            
            <div className="flex space-x-3">
              <button
                onClick={applyDateRangeToTransactions}
                disabled={!defaultStartDate || !defaultEndDate}
                className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium disabled:opacity-50 disabled:cursor-not-allowed"
              >
                期間フィルターを適用
              </button>
              <button
                onClick={clearDateFilter}
                className="bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg text-sm font-medium"
              >
                フィルターをクリア
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* データ管理セクション */}
      <div className="bg-white rounded-lg shadow mb-6">
        <div className="px-6 py-4 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900">データ管理</h2>
        </div>
        <div className="p-6">
          <div className="mb-6">
            <h3 className="text-lg font-medium text-gray-900 mb-2">LocalStorageキャッシュクリア</h3>
            <p className="text-sm text-gray-600 mb-4">
              フロントエンドのLocalStorageに保存されている割当データをクリアします。<br/>
              データベースをリセットした後に古いデータが表示される場合に使用してください。
            </p>
            <button
              onClick={() => {
                // localStorageは使用しない
      sessionStorage.clear();
                setSuccess('LocalStorageキャッシュをクリアしました。ページを更新してください。');
                setTimeout(() => window.location.reload(), 1000);
              }}
              className="bg-orange-600 hover:bg-orange-700 text-white px-4 py-2 rounded-lg text-sm font-medium mr-3"
            >
              キャッシュクリア
            </button>
          </div>
          
          <div className="mb-6">
            <h3 className="text-lg font-medium text-gray-900 mb-2">全データリセット</h3>
            <p className="text-sm text-gray-600 mb-4">
              すべての取引、助成金、予算項目、割当データを削除します。<br/>
              <strong className="text-red-600">この操作は取り消せません。</strong>
            </p>
            <button
              onClick={() => setShowResetConfirm(true)}
              className="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg text-sm font-medium"
            >
              全データリセット
            </button>
          </div>
        </div>
      </div>

      {/* その他の設定セクション */}
      <div className="bg-white rounded-lg shadow">
        <div className="px-6 py-4 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900">システム情報</h2>
        </div>
        <div className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
            <div>
              <h4 className="font-medium text-gray-900">デフォルト表示期間</h4>
              <p className="text-sm text-gray-600">2025年4月1日 ～ 2026年3月31日</p>
            </div>
            <div>
              <h4 className="font-medium text-gray-900">バージョン</h4>
              <p className="text-sm text-gray-600">1.0.0</p>
            </div>
          </div>
          
          <div className="border-t border-gray-200 pt-6">
            <h3 className="text-lg font-medium text-gray-900 mb-2">システム仕様書</h3>
            <p className="text-sm text-gray-600 mb-4">
              システムの詳細仕様書をダウンロードできます。技術仕様、API仕様、運用方法などが記載されています。
            </p>
            <button
              onClick={downloadSpecification}
              className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg text-sm font-medium inline-flex items-center"
            >
              <svg className="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              システム仕様書をダウンロード
            </button>
          </div>
        </div>
      </div>

      {/* リセット確認ダイアログ */}
      {showResetConfirm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 max-w-md w-full mx-4">
            <h3 className="text-lg font-semibold text-red-900 mb-4">
              ⚠️ 危険操作：全データリセット
            </h3>
            <div className="mb-6">
              <p className="text-gray-700 mb-4">
                本当にすべてのデータを削除しますか？<br/>
                この操作は<strong className="text-red-600">絶対に取り消せません</strong>。
              </p>
              <p className="text-sm text-gray-600 mb-4">
                続行するには、下のテキストボックスに「<strong>全削除</strong>」と入力してください：
              </p>
              <input
                type="text"
                value={confirmText}
                onChange={(e) => setConfirmText(e.target.value)}
                placeholder="全削除"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500"
                disabled={resetting}
              />
            </div>
            <div className="flex justify-end space-x-3">
              <button
                onClick={() => {
                  setShowResetConfirm(false);
                  setConfirmText('');
                  setError(null);
                }}
                className="px-4 py-2 text-gray-600 hover:text-gray-800"
                disabled={resetting}
              >
                キャンセル
              </button>
              <button
                onClick={handleResetAllData}
                disabled={resetting || confirmText !== '全削除'}
                className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {resetting ? '削除中...' : '削除実行'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default SettingsPage;