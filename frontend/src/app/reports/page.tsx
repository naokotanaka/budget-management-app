'use client';

import React, { useState, useEffect } from 'react';
import { api } from '@/lib/api';
import { CONFIG, API_CONFIG } from '@/lib/config';

interface MonthlySummaryItem {
  grant_id: number;
  grant_name: string;
  year: number;
  month: number;
  year_month: string;
  total_amount: number;
  transaction_count: number;
}

interface BudgetVsActualItem {
  grant_id: number;
  grant_name: string;
  grant_total_amount: number;
  grant_start_date: string | null;
  grant_end_date: string | null;
  budget_total: number;
  spent_total: number;
  remaining: number;
  usage_rate: number;
  period_progress: number;
}

const ReportsPage: React.FC = () => {
  const [crossTableData, setCrossTableData] = useState<any>({});
  const [monthlySummary, setMonthlySummary] = useState<MonthlySummaryItem[]>([]);
  const [budgetVsActual, setBudgetVsActual] = useState<BudgetVsActualItem[]>([]);
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [loading, setLoading] = useState(false);
  const [monthlyLoading, setMonthlyLoading] = useState(false);
  const [budgetLoading, setBudgetLoading] = useState(false);

  // 初期値設定（デフォルト期間）
  useEffect(() => {
    setStartDate(CONFIG.DEFAULT_DATE_RANGE.START);
    setEndDate(CONFIG.DEFAULT_DATE_RANGE.END);
  }, []);

  // 日付が設定されたら自動でデータを取得
  useEffect(() => {
    if (startDate && endDate) {
      loadCrossTableData();
      loadMonthlySummary();
      loadBudgetVsActual();
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

  const loadMonthlySummary = async () => {
    if (!startDate || !endDate) return;

    try {
      setMonthlyLoading(true);
      
      const response = await fetch(
        `${API_CONFIG.BASE_URL}/api/reports/monthly-summary?start_date=${startDate}&end_date=${endDate}`
      );
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      
      const result = await response.json();
      setMonthlySummary(result.summary || []);
    } catch (error) {
      console.error('Failed to load monthly summary:', error);
      alert('月別集計データの読み込みに失敗しました');
    } finally {
      setMonthlyLoading(false);
    }
  };

  const loadBudgetVsActual = async () => {
    if (!startDate || !endDate) return;

    try {
      setBudgetLoading(true);
      
      const response = await fetch(
        `${API_CONFIG.BASE_URL}/api/reports/budget-vs-actual?start_date=${startDate}&end_date=${endDate}`
      );
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      
      const result = await response.json();
      setBudgetVsActual(result.summary || []);
    } catch (error) {
      console.error('Failed to load budget vs actual:', error);
      alert('予算vs実績データの読み込みに失敗しました');
    } finally {
      setBudgetLoading(false);
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
              onClick={() => {
                loadCrossTableData();
                loadMonthlySummary();
                loadBudgetVsActual();
              }}
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
                      <td className="px-6 py-2 whitespace-nowrap text-sm font-medium text-gray-900 sticky left-0 bg-white">
                        {budgetItem}
                      </td>
                      {months.map(month => (
                        <td key={month} className="px-4 py-2 whitespace-nowrap text-sm text-gray-900 text-right">
                          {amounts[month] ? amounts[month].toLocaleString() : '-'}
                        </td>
                      ))}
                      <td className="px-6 py-2 whitespace-nowrap text-sm font-bold text-gray-900 text-right bg-yellow-50">
                        {getBudgetItemTotal(budgetItem).toLocaleString()}
                      </td>
                    </tr>
                  ))
                )}
                
                {/* 合計行 */}
                {Object.keys(crossTableData).length > 0 && (
                  <tr className="bg-blue-50 font-bold">
                    <td className="px-6 py-2 whitespace-nowrap text-sm font-bold text-gray-900 sticky left-0 bg-blue-50">
                      合計
                    </td>
                    {months.map(month => (
                      <td key={month} className="px-4 py-2 whitespace-nowrap text-sm font-bold text-gray-900 text-right">
                        {getMonthTotal(month).toLocaleString()}
                      </td>
                    ))}
                    <td className="px-6 py-2 whitespace-nowrap text-sm font-bold text-gray-900 text-right bg-yellow-100">
                      {getGrandTotal().toLocaleString()}
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}


      {/* 予算vs実績比較テーブル */}
      <div className="mt-6">
        <div className="bg-white shadow rounded-lg">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-medium text-gray-900">予算vs実績比較</h3>
          </div>
          
          <div className="p-6">
            {budgetLoading ? (
              <div className="text-center py-8">
                <div className="text-gray-500">読み込み中...</div>
              </div>
            ) : budgetVsActual.length === 0 ? (
              <div className="text-center py-8">
                <div className="text-gray-500">データがありません</div>
              </div>
            ) : (
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        助成金
                      </th>
                      <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        予算合計
                      </th>
                      <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        実績合計
                      </th>
                      <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        残額
                      </th>
                      <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        執行率
                      </th>
                      <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        期間進捗
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {budgetVsActual.map((item, index) => (
                      <tr key={item.grant_id} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                        <td className="px-4 py-2 whitespace-nowrap text-sm font-medium text-gray-900">
                          {item.grant_name}
                        </td>
                        <td className="px-4 py-2 whitespace-nowrap text-sm text-gray-900 text-right">
                          {item.budget_total.toLocaleString()}円
                        </td>
                        <td className="px-4 py-2 whitespace-nowrap text-sm text-gray-900 text-right">
                          {item.spent_total.toLocaleString()}円
                        </td>
                        <td className="px-4 py-2 whitespace-nowrap text-sm text-right">
                          <span className={item.remaining > 0 ? 'text-red-600 font-bold' : 'text-gray-900'}>
                            {item.remaining.toLocaleString()}円
                          </span>
                        </td>
                        <td className="px-4 py-2 whitespace-nowrap text-sm text-right">
                          <span className={item.usage_rate > 100 ? 'text-red-600 font-bold' : 'text-gray-900'}>
                            {item.usage_rate}%
                          </span>
                        </td>
                        <td className="px-4 py-2 whitespace-nowrap text-sm text-right">
                          <span className={
                            item.period_progress >= 90 ? 'text-red-600 font-bold' : 
                            item.period_progress >= 80 ? 'text-blue-600 font-bold' : 
                            'text-gray-900'
                          }>
                            {item.period_progress}%
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* 月別集計テーブル */}
      <div className="mt-6">
        <div className="bg-white shadow rounded-lg">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-medium text-gray-900">助成金ごとの月別集計</h3>
          </div>
          
          <div className="p-6">
            {monthlyLoading ? (
              <div className="text-center py-8">
                <div className="text-gray-500">読み込み中...</div>
              </div>
            ) : monthlySummary.length === 0 ? (
              <div className="text-center py-8">
                <div className="text-gray-500">データがありません</div>
              </div>
            ) : (
              <div className="overflow-x-auto">
                {(() => {
                  // 助成金リストを取得
                  const grants = Array.from(new Set(monthlySummary.map(item => item.grant_name))).sort();
                  
                  // 月リストを取得
                  const months = Array.from(new Set(monthlySummary.map(item => item.year_month))).sort();
                  
                  // データをマトリックス形式に変換
                  const matrix: Record<string, Record<string, number>> = {};
                  
                  grants.forEach(grant => {
                    matrix[grant] = {};
                    months.forEach(month => {
                      matrix[grant][month] = 0;
                    });
                  });
                  
                  monthlySummary.forEach(item => {
                    matrix[item.grant_name][item.year_month] = item.total_amount;
                  });
                  
                  return (
                    <table className="min-w-full divide-y divide-gray-200">
                      <thead className="bg-gray-50">
                        <tr>
                          <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sticky left-0 bg-gray-50">
                            助成金
                          </th>
                          {months.map(month => (
                            <th key={month} className="px-4 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider min-w-[120px]">
                              {month}
                            </th>
                          ))}
                          <th className="px-4 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider bg-blue-50">
                            合計
                          </th>
                        </tr>
                      </thead>
                      <tbody className="bg-white divide-y divide-gray-200">
                        {grants.map((grant, grantIndex) => (
                          <tr key={grant} className={grantIndex % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                            <td className="px-4 py-2 whitespace-nowrap text-sm font-medium text-gray-900 sticky left-0 bg-inherit">
                              {grant}
                            </td>
                            {months.map(month => {
                              const amount = matrix[grant][month];
                              return (
                                <td key={month} className="px-4 py-2 text-center text-sm">
                                  {amount > 0 ? (
                                    <div className="text-gray-900 font-medium">
                                      {amount.toLocaleString()}円
                                    </div>
                                  ) : (
                                    <span className="text-gray-300">-</span>
                                  )}
                                </td>
                              );
                            })}
                            <td className="px-4 py-2 text-center text-sm bg-blue-50">
                              {(() => {
                                const totalAmount = months.reduce((sum, month) => sum + matrix[grant][month], 0);
                                return (
                                  <div className="text-gray-900 font-bold">
                                    {totalAmount.toLocaleString()}円
                                  </div>
                                );
                              })()}
                            </td>
                          </tr>
                        ))}
                        
                        {/* 合計行 */}
                        <tr className="bg-blue-50 font-medium">
                          <td className="px-4 py-2 text-sm font-bold text-gray-900 sticky left-0 bg-blue-50">
                            合計
                          </td>
                          {months.map(month => {
                            const monthTotal = grants.reduce((sum, grant) => sum + matrix[grant][month], 0);
                            return (
                              <td key={month} className="px-4 py-2 text-center text-sm">
                                <div className="text-gray-900 font-bold">
                                  {monthTotal.toLocaleString()}円
                                </div>
                              </td>
                            );
                          })}
                          <td className="px-4 py-2 text-center text-sm bg-blue-100">
                            {(() => {
                              const grandTotal = monthlySummary.reduce((sum, item) => sum + item.total_amount, 0);
                              return (
                                <div className="text-gray-900 font-bold text-lg">
                                  {grandTotal.toLocaleString()}円
                                </div>
                              );
                            })()}
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  );
                })()}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default ReportsPage;