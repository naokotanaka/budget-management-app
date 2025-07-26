'use client';

import React, { useState, useEffect } from 'react';
import { api, FreeeSync, GitHubCommit, GitHubRelease } from '@/lib/api';
import { CONFIG } from '@/lib/config';

const SettingsPage: React.FC = () => {
  const [resetting, setResetting] = useState(false);
  const [showResetConfirm, setShowResetConfirm] = useState(false);
  const [confirmText, setConfirmText] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  
  // 期間フィルター設定
  const [defaultStartDate, setDefaultStartDate] = useState<string>("2025-04-01");
  const [defaultEndDate, setDefaultEndDate] = useState<string>("2026-03-31");
  const [filterSuccess, setFilterSuccess] = useState<string | null>(null);

  // freee同期履歴
  const [freeSyncs, setFreeSyncs] = useState<FreeeSync[]>([]);
  const [syncLoading, setSyncLoading] = useState(false);

  // GitHub履歴とバージョン情報
  const [githubCommits, setGithubCommits] = useState<GitHubCommit[]>([]);
  const [githubReleases, setGithubReleases] = useState<GitHubRelease[]>([]);
  const [currentVersion, setCurrentVersion] = useState<any>(null);
  const [githubLoading, setGithubLoading] = useState(false);

  // システム情報
  const [systemInfo, setSystemInfo] = useState<any>(null);

  useEffect(() => {
    fetchFreeSyncs();
    fetchGitHubData();
    fetchCurrentVersion();
    fetchSystemInfo();
  }, []);

  const fetchFreeSyncs = async () => {
    try {
      setSyncLoading(true);
      const syncs = await api.getFreeSyncs();
      setFreeSyncs(syncs);
    } catch (err) {
      console.error('Failed to fetch freee syncs:', err);
    } finally {
      setSyncLoading(false);
    }
  };

  const fetchGitHubData = async () => {
    try {
      setGithubLoading(true);
      const [commits, releases] = await Promise.all([
        api.getGitHubCommits(10),
        api.getGitHubReleases(5)
      ]);
      setGithubCommits(commits);
      setGithubReleases(releases);
    } catch (err) {
      console.error('Failed to fetch GitHub data:', err);
    } finally {
      setGithubLoading(false);
    }
  };

  const fetchCurrentVersion = async () => {
    try {
      const version = await api.getCurrentCommit();
      setCurrentVersion(version);
    } catch (err) {
      console.error('Failed to fetch current version:', err);
    }
  };

  const fetchSystemInfo = async () => {
    try {
      const response = await fetch('/api/system-info');
      if (response.ok) {
        const info = await response.json();
        setSystemInfo(info);
      }
    } catch (err) {
      console.error('Failed to fetch system info:', err);
    }
  };

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

      {/* WAM報告書機能設定セクション */}
      <div className="bg-white rounded-lg shadow mb-6">
        <div className="px-6 py-4 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900">機能設定</h2>
        </div>
        <div className="p-6">
          <div className="mb-6">
            <h3 className="text-lg font-medium text-gray-900 mb-2">WAM報告書機能</h3>
            <p className="text-sm text-gray-600 mb-4">
              WAM助成金報告書作成機能の表示/非表示を切り替えます。<br/>
              助成金終了後は非表示にして運用を継続できます。
            </p>
            <label className="flex items-center">
              <input 
                type="checkbox" 
                checked={true}
                onChange={() => {
                  // 将来的に実装: ローカルストレージやAPIで管理
                  alert('この機能は将来実装予定です');
                }}
                className="mr-2"
              />
              <span className="text-sm">WAM報告書作成機能を表示</span>
            </label>
          </div>
        </div>
      </div>

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

      {/* バックアップ履歴セクション */}
      <div className="bg-white rounded-lg shadow mb-6">
        <div className="px-6 py-4 border-b border-gray-200">
          <div className="flex items-center justify-between">
            <h2 className="text-xl font-semibold text-gray-900">バックアップ履歴</h2>
            <button
              onClick={fetchFreeSyncs}
              disabled={syncLoading}
              className="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm font-medium disabled:opacity-50"
            >
              {syncLoading ? '読み込み中...' : '更新'}
            </button>
          </div>
        </div>
        <div className="p-6">
          <p className="text-sm text-gray-600 mb-4">
            freee会計との同期履歴を表示します。最新20件まで表示されます。
          </p>
          
          {syncLoading ? (
            <div className="text-center py-8">
              <div className="text-gray-500">読み込み中...</div>
            </div>
          ) : freeSyncs.length === 0 ? (
            <div className="text-center py-8">
              <div className="text-gray-500">同期履歴がありません</div>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      同期日時
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      期間
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      ステータス
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      処理件数
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      完了日時
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {freeSyncs.map((sync) => (
                    <tr key={sync.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {new Date(sync.created_at).toLocaleString('ja-JP')}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {sync.start_date} ～ {sync.end_date}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          sync.status === 'completed' ? 'bg-green-100 text-green-800' :
                          sync.status === 'failed' ? 'bg-red-100 text-red-800' :
                          sync.status === 'processing' ? 'bg-yellow-100 text-yellow-800' :
                          'bg-gray-100 text-gray-800'
                        }`}>
                          {sync.status === 'completed' ? '完了' :
                           sync.status === 'failed' ? '失敗' :
                           sync.status === 'processing' ? '処理中' : '待機中'}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {sync.status === 'completed' ? (
                          <div>
                            <div>総件数: {sync.total_records}</div>
                            <div className="text-xs text-gray-500">
                              新規: {sync.created_records}, 更新: {sync.updated_records}
                            </div>
                          </div>
                        ) : (
                          `${sync.processed_records} / ${sync.total_records}`
                        )}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {sync.completed_at ? new Date(sync.completed_at).toLocaleString('ja-JP') : '-'}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
          
          {freeSyncs.some(sync => sync.error_message) && (
            <div className="mt-4">
              <h4 className="text-sm font-medium text-red-900 mb-2">エラー詳細</h4>
              <div className="space-y-2">
                {freeSyncs.filter(sync => sync.error_message).map((sync) => (
                  <div key={sync.id} className="bg-red-50 border border-red-200 rounded p-3">
                    <div className="text-sm font-medium text-red-800">
                      {new Date(sync.created_at).toLocaleString('ja-JP')} の同期でエラー:
                    </div>
                    <div className="text-sm text-red-700 mt-1">{sync.error_message}</div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* その他の設定セクション */}
      <div className="bg-white rounded-lg shadow">
        <div className="px-6 py-4 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900">システム情報</h2>
        </div>
        <div className="p-6">
          {/* システム情報 */}
          <div className="mb-6">
            <h3 className="text-lg font-medium text-gray-900 mb-4">システム構成</h3>
            {systemInfo ? (
              <div className="bg-blue-50 rounded-lg p-4 mb-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <h4 className="font-medium text-gray-900">データベース</h4>
                    <p className="text-sm text-blue-800 font-mono">{systemInfo.database_name}</p>
                  </div>
                  <div>
                    <h4 className="font-medium text-gray-900">環境</h4>
                    <p className="text-sm text-gray-600">{systemInfo.environment}</p>
                  </div>
                  <div>
                    <h4 className="font-medium text-gray-900">ポート</h4>
                    <p className="text-sm text-gray-600">{systemInfo.port}</p>
                  </div>
                  <div>
                    <h4 className="font-medium text-gray-900">設定ファイル</h4>
                    <p className="text-sm text-gray-600 font-mono">{systemInfo.env_file || 'デフォルト'}</p>
                  </div>
                </div>
              </div>
            ) : (
              <div className="text-gray-500 mb-6">システム情報を取得中...</div>
            )}
          </div>

          {/* 現在のバージョン情報 */}
          <div className="mb-6">
            <h3 className="text-lg font-medium text-gray-900 mb-4">現在のバージョン</h3>
            {currentVersion ? (
              <div className="bg-gray-50 rounded-lg p-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <h4 className="font-medium text-gray-900">コミットハッシュ</h4>
                    <p className="text-sm text-gray-600 font-mono">{currentVersion.commitShort}</p>
                  </div>
                  <div>
                    <h4 className="font-medium text-gray-900">ブランチ</h4>
                    <p className="text-sm text-gray-600">{currentVersion.branch}</p>
                  </div>
                  <div>
                    <h4 className="font-medium text-gray-900">コミット日時</h4>
                    <p className="text-sm text-gray-600">{new Date(currentVersion.commitDate).toLocaleString('ja-JP')}</p>
                  </div>
                  <div>
                    <h4 className="font-medium text-gray-900">最終更新</h4>
                    <p className="text-sm text-gray-600">{new Date(currentVersion.timestamp).toLocaleString('ja-JP')}</p>
                  </div>
                </div>
                <div className="mt-4">
                  <h4 className="font-medium text-gray-900">コミットメッセージ</h4>
                  <p className="text-sm text-gray-600">{currentVersion.commitMessage}</p>
                </div>
              </div>
            ) : (
              <div className="text-gray-500">バージョン情報を取得中...</div>
            )}
          </div>

          {/* GitHub履歴 */}
          <div className="mb-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-medium text-gray-900">最新のコミット履歴</h3>
              <button
                onClick={fetchGitHubData}
                disabled={githubLoading}
                className="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm font-medium disabled:opacity-50"
              >
                {githubLoading ? '読み込み中...' : '更新'}
              </button>
            </div>
            
            {githubLoading ? (
              <div className="text-center py-8">
                <div className="text-gray-500">読み込み中...</div>
              </div>
            ) : githubCommits.length === 0 ? (
              <div className="text-center py-8">
                <div className="text-gray-500">コミット履歴を取得できませんでした</div>
              </div>
            ) : (
              <div className="space-y-3">
                {githubCommits.slice(0, 5).map((commit) => (
                  <div key={commit.sha} className="border rounded-lg p-4 hover:bg-gray-50">
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        <div className="flex items-center space-x-2 mb-2">
                          <span className="font-mono text-sm bg-gray-100 px-2 py-1 rounded">
                            {commit.sha.substring(0, 7)}
                          </span>
                          <span className="text-sm text-gray-500">
                            {new Date(commit.commit.author.date).toLocaleString('ja-JP')}
                          </span>
                        </div>
                        <p className="text-sm text-gray-900 mb-1">{commit.commit.message}</p>
                        <p className="text-xs text-gray-500">
                          by {commit.commit.author.name}
                        </p>
                      </div>
                      <a
                        href={commit.html_url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-blue-600 hover:text-blue-800 text-sm"
                      >
                        GitHub で見る
                      </a>
                    </div>
                  </div>
                ))}
                <div className="text-center">
                  <a
                    href="https://github.com/tanaka-naoki/nagaiku-budget/commits"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-blue-600 hover:text-blue-800 text-sm"
                  >
                    すべてのコミットを GitHub で見る
                  </a>
                </div>
              </div>
            )}
          </div>

          {/* リリース情報 */}
          {githubReleases.length > 0 && (
            <div className="mb-6">
              <h3 className="text-lg font-medium text-gray-900 mb-4">最新のリリース</h3>
              <div className="space-y-3">
                {githubReleases.slice(0, 3).map((release) => (
                  <div key={release.tag_name} className="border rounded-lg p-4">
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        <div className="flex items-center space-x-2 mb-2">
                          <span className="font-semibold text-gray-900">{release.name || release.tag_name}</span>
                          {release.prerelease && (
                            <span className="bg-yellow-100 text-yellow-800 text-xs px-2 py-1 rounded">
                              プレリリース
                            </span>
                          )}
                        </div>
                        <p className="text-sm text-gray-600 mb-2">
                          {new Date(release.published_at).toLocaleString('ja-JP')}
                        </p>
                        {release.body && (
                          <p className="text-sm text-gray-700 whitespace-pre-line">
                            {release.body.substring(0, 200)}
                            {release.body.length > 200 && '...'}
                          </p>
                        )}
                      </div>
                      <a
                        href={release.html_url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-blue-600 hover:text-blue-800 text-sm"
                      >
                        GitHub で見る
                      </a>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
            <div>
              <h4 className="font-medium text-gray-900">デフォルト表示期間</h4>
              <p className="text-sm text-gray-600">2025年4月1日 ～ 2026年3月31日</p>
            </div>
            <div>
              <h4 className="font-medium text-gray-900">リポジトリ</h4>
              <p className="text-sm text-gray-600">
                <a
                  href="https://github.com/tanaka-naoki/nagaiku-budget"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-blue-600 hover:text-blue-800"
                >
                  GitHub で見る
                </a>
              </p>
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