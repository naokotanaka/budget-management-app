'use client';

import React, { useState, useEffect } from 'react';
import { api } from '@/lib/api';
import { CONFIG } from '@/lib/config';

const ReportsPage: React.FC = () => {
  const [crossTableData, setCrossTableData] = useState<any>({});
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [loading, setLoading] = useState(false);

  // 初期値設定（デフォルト期間）
  useEffect(() => {
    setStartDate(CONFIG.DEFAULT_DATE_RANGE.START);
    setEndDate(CONFIG.DEFAULT_DATE_RANGE.END);
  }, []);

  // 日付が設定されたら自動でデータを取得
  useEffect(() => {
    if (startDate && endDate) {
      loadCrossTableData();
    }
  }, [startDate, endDate]);

  const loadCrossTableData = async () => {
    if (!startDate || !endDate) return;

    try {
      setLoading(true);
      const data = await api.getCrossTable(startDate, endDate);
      setCrossTableData(data);
    } catch (error) {
      console.error('Failed to load cross table data:', error);
      alert('レポートデータの読み込みに失敗しました');
    } finally {
      setLoading(false);
    }
  };

  // 月のリストを生成
  const generateMonths = () => {
    if (!startDate || !endDate) return [];
    
    const start = new Date(startDate);
    const end = new Date(endDate);
    const months = [];
    
    const current = new Date(start);
    while (current <= end) {
      const year = current.getFullYear();
      const month = (current.getMonth() + 1).toString().padStart(2, '0');
      months.push(`${year}-${month}`);
      current.setMonth(current.getMonth() + 1);
    }
    
    return months;
  };

  const months = generateMonths();

  // 予算項目ごとの合計を計算
  const getBudgetItemTotal = (budgetItem: string) => {
    const amounts = crossTableData[budgetItem] || {};
    return Object.values(amounts).reduce((total: number, amount: any) => total + (amount || 0), 0);
  };

  // 月ごとの合計を計算
  const getMonthTotal = (month: string) => {
    return Object.values(crossTableData).reduce((total: number, amounts: any) => {
      return total + (amounts[month] || 0);
    }, 0);
  };

  // 総合計を計算
  const getGrandTotal = () => {
    return Object.values(crossTableData).reduce((total: number, amounts: any) => {
      return total + Object.values(amounts).reduce((subtotal: number, amount: any) => subtotal + (amount || 0), 0);
    }, 0);
  };

  return (
    <div className="px-4 py-6 sm:px-0">
      <div className="border-b border-gray-200 pb-4 mb-6">
        <h1 className="text-2xl font-bold text-gray-900">レポート</h1>
        <p className="mt-2 text-sm text-gray-600">
          予算項目×月のクロス集計表
        </p>
      </div>

      {/* 期間選択 */}
      <div className="bg-white p-6 rounded-lg shadow mb-6">
        <h3 className="text-lg font-medium mb-4">期間設定</h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 items-end">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
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
            <label className="block text-sm font-medium text-gray-700 mb-1">
              終了日
            </label>
            <input
              type="date"
              value={endDate}
              onChange={(e) => setEndDate(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <div>
            <button
              onClick={loadCrossTableData}
              disabled={loading || !startDate || !endDate}
              className="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50"
            >
              {loading ? '読み込み中...' : '更新'}
            </button>
          </div>
        </div>
      </div>

      {/* クロス集計表 */}
      {loading ? (
        <div className="text-center py-8">
          <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          <p className="mt-2 text-sm text-gray-600">データを読み込み中...</p>
        </div>
      ) : (
        <div className="bg-white rounded-lg shadow overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-medium text-gray-900">
              予算項目×月 クロス集計表
            </h3>
            <p className="text-sm text-gray-600 mt-1">
              {startDate} ～ {endDate}
            </p>
          </div>
          
          <div className="overflow-x-auto">
            <table className="min-w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sticky left-0 bg-gray-50 z-10">
                    予算項目
                  </th>
                  {months.map(month => (
                    <th key={month} className="px-4 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider min-w-[100px]">
                      {month}
                    </th>
                  ))}
                  <th className="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider bg-yellow-50">
                    合計
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {Object.keys(crossTableData).length === 0 ? (
                  <tr>
                    <td colSpan={months.length + 2} className="px-6 py-8 text-center text-gray-500">
                      データがありません
                    </td>
                  </tr>
                ) : (
                  Object.entries(crossTableData).map(([budgetItem, amounts]: [string, any]) => (
                    <tr key={budgetItem} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 sticky left-0 bg-white">
                        {budgetItem}
                      </td>
                      {months.map(month => (
                        <td key={month} className="px-4 py-4 whitespace-nowrap text-sm text-gray-900 text-right">
                          {amounts[month] ? amounts[month].toLocaleString() : '-'}
                        </td>
                      ))}
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900 text-right bg-yellow-50">
                        {getBudgetItemTotal(budgetItem).toLocaleString()}
                      </td>
                    </tr>
                  ))
                )}
                
                {/* 合計行 */}
                {Object.keys(crossTableData).length > 0 && (
                  <tr className="bg-blue-50 font-bold">
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900 sticky left-0 bg-blue-50">
                      合計
                    </td>
                    {months.map(month => (
                      <td key={month} className="px-4 py-4 whitespace-nowrap text-sm font-bold text-gray-900 text-right">
                        {getMonthTotal(month).toLocaleString()}
                      </td>
                    ))}
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900 text-right bg-yellow-100">
                      {getGrandTotal().toLocaleString()}
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* 追加の統計情報 */}
      {Object.keys(crossTableData).length > 0 && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-6">
          <div className="bg-white p-6 rounded-lg shadow">
            <h4 className="text-lg font-medium text-gray-900 mb-2">総支出額</h4>
            <p className="text-3xl font-bold text-blue-600">
              {getGrandTotal().toLocaleString()}円
            </p>
          </div>
          
          <div className="bg-white p-6 rounded-lg shadow">
            <h4 className="text-lg font-medium text-gray-900 mb-2">予算項目数</h4>
            <p className="text-3xl font-bold text-green-600">
              {Object.keys(crossTableData).length}項目
            </p>
          </div>
          
          <div className="bg-white p-6 rounded-lg shadow">
            <h4 className="text-lg font-medium text-gray-900 mb-2">対象期間</h4>
            <p className="text-lg font-bold text-purple-600">
              {months.length}ヶ月
            </p>
          </div>
        </div>
      )}
    </div>
  );
};

export default ReportsPage;