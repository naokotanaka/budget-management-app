'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { api } from '@/lib/api';
import { linkPath } from '@/lib/basePath';

export default function Home() {
  const [stats, setStats] = useState({
    totalTransactions: 0,
    totalAmount: 0,
    allocatedTransactions: 0,
    unallocatedTransactions: 0
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchStats = async () => {
    try {
      setLoading(true);
      const data = await api.getDashboardStats();
      setStats(data);
      setError(null);
    } catch (err) {
      console.error('Failed to fetch dashboard stats:', err);
      setError(err instanceof Error ? err.message : 'Failed to fetch dashboard stats');
      // Fallback to default values on error
      setStats({
        totalTransactions: 0,
        totalAmount: 0,
        allocatedTransactions: 0,
        unallocatedTransactions: 0
      });
    } finally {
      setLoading(false);
    }
  };


  useEffect(() => {
    fetchStats();
  }, []);

  const quickActions = [
    {
      title: 'CSV取込',
      description: 'freeeからエクスポートしたCSVファイルを取り込む',
      href: '/import',
      color: 'bg-blue-500',
      icon: '📁'
    },
    {
      title: '取引一覧',
      description: '取引データの確認と予算項目への割り当て',
      href: '/transactions',
      color: 'bg-green-500',
      icon: '📊'
    },
    {
      title: '助成金管理',
      description: '助成金と予算項目の設定・管理',
      href: '/grants',
      color: 'bg-purple-500',
      icon: '💰'
    },
    {
      title: 'レポート',
      description: 'クロス集計表とレポートの確認',
      href: '/reports',
      color: 'bg-orange-500',
      icon: '📈'
    }
  ];

  return (
    <div className="px-4 py-6 sm:px-0">
      {/* ヘッダー */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          ダッシュボード
        </h1>
        <p className="text-gray-600">
          NPO法人ながいくの予算管理システムへようこそ
        </p>
      </div>

      {/* エラー表示 */}
      {error && (
        <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
          <div className="flex items-center">
            <div className="text-red-500 text-xl mr-3">⚠️</div>
            <div>
              <p className="text-red-800 font-medium">データの読み込みに失敗しました</p>
              <p className="text-red-600 text-sm">{error}</p>
            </div>
          </div>
        </div>
      )}

      {/* 統計カード */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center">
            <div className="flex-1">
              <p className="text-sm font-medium text-gray-600">総取引数</p>
              <p className="text-2xl font-bold text-gray-900">
                {loading ? '...' : `${stats.totalTransactions}件`}
              </p>
            </div>
            <div className="text-3xl">📋</div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center">
            <div className="flex-1">
              <p className="text-sm font-medium text-gray-600">総金額</p>
              <p className="text-2xl font-bold text-gray-900">
                {loading ? '...' : `${stats.totalAmount.toLocaleString()}円`}
              </p>
            </div>
            <div className="text-3xl">💴</div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center">
            <div className="flex-1">
              <p className="text-sm font-medium text-gray-600">割当済み</p>
              <p className="text-2xl font-bold text-green-600">
                {loading ? '...' : `${stats.allocatedTransactions}件`}
              </p>
            </div>
            <div className="text-3xl">✅</div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center">
            <div className="flex-1">
              <p className="text-sm font-medium text-gray-600">未割当</p>
              <p className="text-2xl font-bold text-red-600">
                {loading ? '...' : `${stats.unallocatedTransactions}件`}
              </p>
            </div>
            <div className="text-3xl">⚠️</div>
          </div>
        </div>
      </div>

      {/* クイックアクション */}
      <div className="mb-8">
        <h2 className="text-xl font-semibold text-gray-900 mb-4">
          クイックアクション
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {quickActions.map((action, index) => (
            <Link key={index} href={linkPath(action.href)}>
              <div className="bg-white p-6 rounded-lg shadow hover:shadow-lg transition-shadow cursor-pointer">
                <div className="flex items-center mb-3">
                  <div className="text-2xl mr-3">{action.icon}</div>
                  <h3 className="text-lg font-semibold text-gray-900">
                    {action.title}
                  </h3>
                </div>
                <p className="text-sm text-gray-600">
                  {action.description}
                </p>
                <div className="mt-4">
                  <span className="text-blue-600 text-sm font-medium hover:text-blue-800">
                    開始 →
                  </span>
                </div>
              </div>
            </Link>
          ))}
        </div>
      </div>

      {/* 最近の活動 */}
      <div className="bg-white rounded-lg shadow">
        <div className="px-6 py-4 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900">
            システムについて
          </h2>
        </div>
        <div className="p-6">
          <div className="space-y-4">
            <div className="flex items-start">
              <div className="text-green-500 mr-3 mt-1">✓</div>
              <div>
                <p className="font-medium text-gray-900">CSV取込機能</p>
                <p className="text-sm text-gray-600">
                  freeeからエクスポートしたCSVファイルを取り込み、【事】【管】で始まる勘定科目のみを自動フィルタリング
                </p>
              </div>
            </div>
            <div className="flex items-start">
              <div className="text-green-500 mr-3 mt-1">✓</div>
              <div>
                <p className="font-medium text-gray-900">予算項目割り当て</p>
                <p className="text-sm text-gray-600">
                  個別編集モードと一括選択モードの2つの方法で取引を予算項目に割り当て可能
                </p>
              </div>
            </div>
            <div className="flex items-start">
              <div className="text-green-500 mr-3 mt-1">✓</div>
              <div>
                <p className="font-medium text-gray-900">クロス集計レポート</p>
                <p className="text-sm text-gray-600">
                  予算項目×月のクロス集計表で支出状況を可視化
                </p>
              </div>
            </div>
            <div className="flex items-start">
              <div className="text-green-500 mr-3 mt-1">✓</div>
              <div>
                <p className="font-medium text-gray-900">フィルター機能</p>
                <p className="text-sm text-gray-600">
                  複数条件でのフィルタリングとフィルター設定の保存・再利用
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  );
}
