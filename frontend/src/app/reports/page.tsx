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

interface MonthlyAllocationItem {
  grant_id: number;
  grant_name: string;
  grant_code: string | null;
  grant_start_date: string;
  grant_end_date: string;
  grant_total_days: number;
  budget_item_id: number;
  budget_item_name: string;
  budget_item_category: string;
  budget_item_total: number;
  year: number;
  month: number;
  year_month: string;
  days_in_allocation: number;
  daily_amount: number;
  monthly_allocation: number;
  period_start: string;
  period_end: string;
}

interface MonthlyAllocationSummary {
  year_month: string;
  year: number;
  month: number;
  total_amount: number;
  grant_count: number;
  budget_item_count: number;
}

interface AllocationCrossTableResponse {
  budget_cross_table: Record<string, Record<string, {
    planned: number;
    actual: number;
    difference: number;
  }>>;
  category_cross_table: Record<string, Record<string, {
    planned: number;
    actual: number;
    difference: number;
  }>>;
  months: string[];
  generated_at: string;
}

const ReportsPage: React.FC = () => {
  const [monthlySummary, setMonthlySummary] = useState<MonthlySummaryItem[]>([]);
  const [budgetVsActual, setBudgetVsActual] = useState<BudgetVsActualItem[]>([]);
  const [allocationCrossTable, setAllocationCrossTable] = useState<AllocationCrossTableResponse | null>(null);
  const [budgetItems, setBudgetItems] = useState<any[]>([]);
  const [grants, setGrants] = useState<any[]>([]);
  const [allocations, setAllocations] = useState<any[]>([]);
  const [startDate, setStartDate] = useState(CONFIG.DEFAULT_DATE_RANGE.START);
  const [endDate, setEndDate] = useState(CONFIG.DEFAULT_DATE_RANGE.END);
  const [loading, setLoading] = useState(false);
  const [categoryLoading, setCategoryLoading] = useState(false);
  const [monthlyLoading, setMonthlyLoading] = useState(false);
  const [budgetLoading, setBudgetLoading] = useState(false);
  const [allocationCrossLoading, setAllocationCrossLoading] = useState(false);
  const [sortBudgetByCategory, setSortBudgetByCategory] = useState(false);
  
  // 表示項目の制御
  const [showPlanned, setShowPlanned] = useState(true);
  const [showActual, setShowActual] = useState(true);
  const [showDifference, setShowDifference] = useState(true);

  // 月が未来かどうかを判定するユーティリティ関数
  const isFutureMonth = (monthString: string) => {
    const today = new Date();
    const currentYear = today.getFullYear();
    const currentMonth = today.getMonth() + 1; // 0ベースなので+1
    
    // 複数の形式に対応
    let year: number, month: number;
    
    if (monthString.includes('/')) {
      // YYYY/MM 形式
      [year, month] = monthString.split('/').map(Number);
    } else if (monthString.includes('-')) {
      // YYYY-MM 形式
      [year, month] = monthString.split('-').map(Number);
    } else {
      console.warn('Unknown month format:', monthString);
      return false;
    }
    
    // 翌月以降を未来月として判定（当月は過去月として扱う）
    return year > currentYear || (year === currentYear && month > currentMonth);
  };

  // 初期データを取得
  useEffect(() => {
    const loadInitialData = async () => {
      try {
        const [budgetItemsData, grantsData, allocationsData] = await Promise.all([
          api.getBudgetItems(),
          api.getGrants(),
          api.getAllocations()
        ]);
        setBudgetItems(budgetItemsData);
        setGrants(grantsData);
        setAllocations(allocationsData);
      } catch (error) {
        console.error('Failed to load initial data:', error);
      }
    };
    loadInitialData();
  }, []);

  // 日付が設定されたら自動でデータを取得
  useEffect(() => {
    console.log('🔍 日付変更useEffect:', { startDate, endDate, hasStartDate: !!startDate, hasEndDate: !!endDate });
    if (startDate && endDate) {
      console.log('🔍 期間設定あり - 全API呼び出し');
      loadMonthlySummary();
      loadBudgetVsActual();
      loadAllocationCrossTable();
    } else {
      console.log('🔍 期間設定なし - 期間配分クロス集計表のみ');
      // 期間が未設定の場合は期間配分クロス集計表のみ読み込み
      loadAllocationCrossTable();
    }
  }, [startDate, endDate]);


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

  const loadAllocationCrossTable = async () => {
    try {
      setAllocationCrossLoading(true);
      
      // 表示期間が設定されている場合はそれを利用、未設定の場合はすべての期間
      let url = `${API_CONFIG.BASE_URL}/api/reports/monthly-allocation-cross-table`;
      if (startDate && endDate) {
        url += `?start_date=${startDate}&end_date=${endDate}`;
        console.log('🔍 期間配分クロス集計表API呼び出し（期間指定あり）:', url);
      } else {
        console.log('🔍 期間配分クロス集計表API呼び出し（期間指定なし）:', url);
      }
      
      const response = await fetch(url);
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      
      const result = await response.json();
      console.log('🔍 期間配分クロス集計表レスポンス:', {
        months: result.months,
        monthsCount: result.months?.length,
        startDate,
        endDate
      });
      setAllocationCrossTable(result);
    } catch (error) {
      console.error('Failed to load allocation cross table:', error);
      alert('期間配分クロス集計表の読み込みに失敗しました');
    } finally {
      setAllocationCrossLoading(false);
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


  // 予算項目名から予算項目データを取得
  const getBudgetItemByDisplayName = (displayName: string) => {
    return budgetItems.find(item => item.display_name === displayName);
  };

  // 残額を計算
  const getRemainingAmount = (budgetItem: any) => {
    if (!budgetItem) return 0;
    const allocatedAmount = allocations
      .filter(allocation => allocation.budget_item_id === budgetItem.id)
      .reduce((total, allocation) => total + (allocation.amount || 0), 0);
    return budgetItem.budgeted_amount - allocatedAmount;
  };

  // 助成金の終了日を取得
  const getGrantEndDate = (budgetItem: any) => {
    if (!budgetItem) return null;
    const grant = grants.find(g => g.id === budgetItem.grant_id);
    return grant?.end_date || null;
  };

  // 月が助成金終了日以降かどうかを判定
  const isMonthAfterGrantEnd = (month: string, endDate: string | null) => {
    if (!endDate) return false;
    const monthDate = new Date(month + '-01');
    const grantEndDate = new Date(endDate);
    return monthDate > grantEndDate;
  };


  // 残額の色を決定する関数（他のページと同じルール）
  const getRemainingAmountColor = (remaining: number, endDate?: string) => {
    if (remaining <= 0) return 'text-gray-900';
    if (!endDate) return 'text-green-600 font-bold';
    
    const today = new Date();
    const end = new Date(endDate);
    const diffTime = end.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays < 0) return 'text-gray-400'; // 終了済み
    if (diffDays <= 30) return 'text-red-600 font-bold'; // 30日以下
    if (diffDays <= 60) return 'text-blue-600 font-bold'; // 60日以下
    return 'text-green-600 font-bold'; // それ以上
  };

  return (
    <div className="px-4 py-6 sm:px-0">
      <div className="border-b border-gray-200 pb-4 mb-6">
        <h1 className="text-2xl font-bold text-gray-900">レポート</h1>
        <p className="mt-2 text-sm text-gray-600">
          期間配分版クロス集計表
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
                loadMonthlySummary();
                loadBudgetVsActual();
                loadAllocationCrossTable();
              }}
              disabled={loading || categoryLoading || !startDate || !endDate}
              className="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50"
            >
              {(loading || categoryLoading) ? '読み込み中...' : '更新'}
            </button>
          </div>
        </div>
      </div>


      {/* 予算vs実績比較テーブル */}
      <div className="mt-6" style={{ display: 'none' }}>
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
                        残り日数
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
                          <span className={(() => {
                            if (item.grant_name === '未割当') return 'text-gray-900';
                            if (item.remaining <= 0) return 'text-gray-900';
                            if (!item.grant_end_date) return 'text-green-600 font-bold';
                            
                            const today = new Date();
                            const end = new Date(item.grant_end_date);
                            const diffTime = end.getTime() - today.getTime();
                            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                            
                            if (diffDays < 0) return 'text-gray-400'; // 終了済み
                            if (diffDays <= 30) return 'text-red-600 font-bold'; // 30日以下
                            if (diffDays <= 60) return 'text-blue-600 font-bold'; // 60日以下
                            return 'text-green-600 font-bold'; // それ以上
                          })()}>
                            {item.grant_name === '未割当' ? '-' : `${item.remaining.toLocaleString()}円`}
                          </span>
                        </td>
                        <td className="px-4 py-2 whitespace-nowrap text-sm text-right">
                          <span className={item.usage_rate > 100 ? 'text-red-600 font-bold' : 'text-gray-900'}>
                            {item.grant_name === '未割当' ? '-' : `${item.usage_rate}%`}
                          </span>
                        </td>
                        <td className="px-4 py-2 whitespace-nowrap text-sm text-right">
                          <span className={(() => {
                            if (item.grant_name === '未割当') return 'text-gray-900';
                            if (!item.grant_end_date) return 'text-gray-900';
                            
                            const today = new Date();
                            const end = new Date(item.grant_end_date);
                            const diffTime = end.getTime() - today.getTime();
                            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                            
                            if (diffDays < 0) return 'text-gray-400'; // 終了済み
                            if (diffDays <= 30) return 'text-red-600 font-bold'; // 30日以下
                            if (diffDays <= 60) return 'text-blue-600 font-bold'; // 60日以下
                            return 'text-gray-900'; // それ以上
                          })()}>
                            {(() => {
                              if (item.grant_name === '未割当') return '-';
                              if (!item.grant_end_date) return '-';
                              
                              const today = new Date();
                              const end = new Date(item.grant_end_date);
                              const diffTime = end.getTime() - today.getTime();
                              const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                              
                              if (diffDays < 0) return '終了済み';
                              if (diffDays === 0) return '本日終了';
                              return `${diffDays}日`;
                            })()}
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
      <div className="mt-6" style={{ display: 'none' }}>
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

      {/* カテゴリ別予算vs実績比較 */}
      <div className="mt-6" style={{ display: 'none' }}>
        <div className="bg-white shadow rounded-lg">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-medium text-gray-900">カテゴリ別予算vs実績比較</h3>
          </div>
          
          <div className="p-6">
            {loading ? (
              <div className="text-center py-8">
                <div className="text-gray-500">読み込み中...</div>
              </div>
            ) : (() => {
              // カテゴリ別にデータを集計
              const categoryMap = new Map<string, {
                budgeted: number;
                allocated: number;
                endDate?: string;
              }>();

              budgetItems.forEach(item => {
                if (item.grant_status === 'applied') return; // 報告済みは除外
                
                const category = item.category || 'その他';
                const itemAllocations = allocations.filter(a => a.budget_item_id === item.id);
                const allocated = itemAllocations.reduce((sum, a) => sum + a.amount, 0);
                
                if (categoryMap.has(category)) {
                  const existing = categoryMap.get(category)!;
                  categoryMap.set(category, {
                    budgeted: existing.budgeted + item.budgeted_amount,
                    allocated: existing.allocated + allocated,
                    endDate: existing.endDate // 最初のend_dateを保持
                  });
                } else {
                  // カテゴリの助成金の終了日を取得（最初の助成金の終了日を使用）
                  const grant = grants.find(g => g.id === item.grant_id);
                  categoryMap.set(category, {
                    budgeted: item.budgeted_amount,
                    allocated: allocated,
                    endDate: grant?.end_date
                  });
                }
              });

              const categoryData = Array.from(categoryMap.entries())
                .map(([category, data]) => ({
                  category,
                  budgeted: data.budgeted,
                  allocated: data.allocated,
                  remaining: data.budgeted - data.allocated,
                  usageRate: data.budgeted > 0 ? (data.allocated / data.budgeted) * 100 : 0,
                  endDate: data.endDate
                }))
                .sort((a, b) => a.category.localeCompare(b.category));

              // 残り日数を計算する関数
              const getRemainingDays = (endDate?: string) => {
                if (!endDate) return null;
                const today = new Date();
                const end = new Date(endDate);
                const diffTime = end.getTime() - today.getTime();
                return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
              };

              // 残額の色を決定する関数
              const getRemainingColor = (remaining: number, endDate?: string) => {
                if (remaining <= 0) return 'text-gray-900';
                
                const remainingDays = getRemainingDays(endDate);
                if (remainingDays === null) return 'text-green-600 font-bold';
                if (remainingDays < 0) return 'text-gray-400';
                if (remainingDays <= 30) return 'text-red-600 font-bold';
                if (remainingDays <= 60) return 'text-blue-600 font-bold';
                return 'text-green-600 font-bold';
              };

              return (
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          カテゴリ
                        </th>
                        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                          予算合計
                        </th>
                        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                          実績合計
                        </th>
                        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                          残額
                        </th>
                        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                          使用率
                        </th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {categoryData.map((item, index) => {
                        return (
                          <tr key={item.category} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                            <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                              {item.category}
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono">
                              {item.budgeted.toLocaleString()}
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono">
                              {item.allocated.toLocaleString()}
                            </td>
                            <td className={`px-6 py-4 whitespace-nowrap text-sm text-right font-mono ${getRemainingColor(item.remaining, item.endDate)}`}>
                              {item.remaining.toLocaleString()}
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono">
                              {item.usageRate.toFixed(1)}%
                            </td>
                          </tr>
                        );
                      })}
                      {/* 合計行 */}
                      <tr className="bg-blue-50 font-bold">
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">
                          合計
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono font-bold">
                          {categoryData.reduce((sum, item) => sum + item.budgeted, 0).toLocaleString()}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono font-bold">
                          {categoryData.reduce((sum, item) => sum + item.allocated, 0).toLocaleString()}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono font-bold">
                          {categoryData.reduce((sum, item) => sum + item.remaining, 0).toLocaleString()}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono font-bold">
                          {(() => {
                            const totalBudgeted = categoryData.reduce((sum, item) => sum + item.budgeted, 0);
                            const totalAllocated = categoryData.reduce((sum, item) => sum + item.allocated, 0);
                            return totalBudgeted > 0 ? ((totalAllocated / totalBudgeted) * 100).toFixed(1) + '%' : '0.0%';
                          })()}
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              );
            })()}
          </div>
        </div>
      </div>

      {/* 予算項目別予算vs実績比較 */}
      <div className="mt-6" style={{ display: 'none' }}>
        <div className="bg-white shadow rounded-lg">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-medium text-gray-900">予算項目別予算vs実績比較</h3>
          </div>
          
          <div className="p-6">
            {loading ? (
              <div className="text-center py-8">
                <div className="text-gray-500">読み込み中...</div>
              </div>
            ) : (() => {
              // 予算項目別にデータを準備
              const itemData = budgetItems
                .filter(item => item.grant_status !== 'applied') // 報告済みは除外
                .map(item => {
                  const itemAllocations = allocations.filter(a => a.budget_item_id === item.id);
                  const allocated = itemAllocations.reduce((sum, a) => sum + a.amount, 0);
                  const remaining = item.budgeted_amount - allocated;
                  const usageRate = item.budgeted_amount > 0 ? (allocated / item.budgeted_amount) * 100 : 0;
                  
                  // 助成金情報を取得
                  const grant = grants.find(g => g.id === item.grant_id);
                  
                  return {
                    id: item.id,
                    name: item.display_name || `${item.grant_name || '不明'}-${item.name}`,
                    category: item.category || 'その他',
                    grantName: item.grant_name || '不明',
                    budgeted: item.budgeted_amount,
                    allocated,
                    remaining,
                    usageRate,
                    endDate: grant?.end_date
                  };
                })
                .sort((a, b) => {
                  // 助成金名でソート、その後項目名でソート
                  if (a.grantName !== b.grantName) {
                    return a.grantName.localeCompare(b.grantName);
                  }
                  return a.name.localeCompare(b.name);
                });

              // 残り日数を計算する関数
              const getRemainingDays = (endDate?: string) => {
                if (!endDate) return null;
                const today = new Date();
                const end = new Date(endDate);
                const diffTime = end.getTime() - today.getTime();
                return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
              };

              // 残額の色を決定する関数
              const getRemainingColor = (remaining: number, endDate?: string) => {
                if (remaining <= 0) return 'text-gray-900';
                
                const remainingDays = getRemainingDays(endDate);
                if (remainingDays === null) return 'text-green-600 font-bold';
                if (remainingDays < 0) return 'text-gray-400';
                if (remainingDays <= 30) return 'text-red-600 font-bold';
                if (remainingDays <= 60) return 'text-blue-600 font-bold';
                return 'text-green-600 font-bold';
              };

              return (
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          予算項目
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          カテゴリ
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          助成金
                        </th>
                        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                          予算金額
                        </th>
                        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                          実績金額
                        </th>
                        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                          残額
                        </th>
                        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                          使用率
                        </th>
                        <th className="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                          残り日数
                        </th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {itemData.map((item, index) => {
                        const remainingDays = getRemainingDays(item.endDate);
                        
                        return (
                          <tr key={item.id} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                            <td className="px-6 py-4 text-sm font-medium text-gray-900" style={{ maxWidth: '200px', wordWrap: 'break-word' }}>
                              {item.name}
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                              {item.category}
                            </td>
                            <td className="px-6 py-4 text-sm text-gray-900" style={{ maxWidth: '150px', wordWrap: 'break-word' }}>
                              {item.grantName}
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono">
                              {item.budgeted.toLocaleString()}
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono">
                              {item.allocated.toLocaleString()}
                            </td>
                            <td className={`px-6 py-4 whitespace-nowrap text-sm text-right font-mono ${getRemainingColor(item.remaining, item.endDate)}`}>
                              {item.remaining.toLocaleString()}
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono">
                              {item.usageRate.toFixed(1)}%
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap text-sm text-center">
                              {remainingDays === null ? (
                                <span className="text-gray-400">-</span>
                              ) : remainingDays < 0 ? (
                                <span className="text-gray-400">終了済み</span>
                              ) : (
                                <span className={
                                  remainingDays <= 30 ? 'text-red-600 font-bold' :
                                  remainingDays <= 60 ? 'text-blue-600 font-bold' :
                                  'text-green-600 font-bold'
                                }>
                                  {remainingDays}
                                </span>
                              )}
                            </td>
                          </tr>
                        );
                      })}
                      {/* 合計行 */}
                      <tr className="bg-blue-50 font-bold">
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900" colSpan={3}>
                          合計
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono font-bold">
                          {itemData.reduce((sum, item) => sum + item.budgeted, 0).toLocaleString()}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono font-bold">
                          {itemData.reduce((sum, item) => sum + item.allocated, 0).toLocaleString()}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono font-bold">
                          {itemData.reduce((sum, item) => sum + item.remaining, 0).toLocaleString()}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono font-bold">
                          {(() => {
                            const totalBudgeted = itemData.reduce((sum, item) => sum + item.budgeted, 0);
                            const totalAllocated = itemData.reduce((sum, item) => sum + item.allocated, 0);
                            return totalBudgeted > 0 ? ((totalAllocated / totalBudgeted) * 100).toFixed(1) + '%' : '0.0%';
                          })()}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-center font-bold text-gray-900">
                          -
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              );
            })()}
          </div>
        </div>
      </div>

      {/* 期間配分版クロス集計表 */}
      {allocationCrossLoading ? (
        <div className="text-center py-8">
          <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          <p className="mt-2 text-sm text-gray-600">期間配分データを読み込み中...</p>
        </div>
      ) : (
        allocationCrossTable && (
          <div className="space-y-6">
            {/* 期間配分版 予算項目×月 クロス集計表 */}
            <div className="bg-white rounded-lg shadow overflow-hidden mt-6">
              <div className="px-6 py-4 border-b border-gray-200">
                <div className="flex justify-between items-start">
                  <div>
                    <h3 className="text-lg font-medium text-gray-900">
                      予算項目×月 クロス集計表（期間配分版）
                    </h3>
                    <p className="text-sm text-gray-600 mt-1">
                      助成金の期間に基づいて日割り計算で配分した月ごとの予算額
                    </p>
                    <p className="text-xs text-gray-500 mt-1">
                      例：90万円の消耗品費、期間7/1-9/30（92日）→ 7月：{Math.round(900000/92*31).toLocaleString()}、8月：{Math.round(900000/92*31).toLocaleString()}、9月：{Math.round(900000/92*30).toLocaleString()}
                    </p>
                  </div>
                  <div className="flex flex-col space-y-1 text-xs">
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showPlanned} 
                        onChange={(e) => setShowPlanned(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-green-100 rounded border"></div>
                      <span>期間配分予算</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showActual} 
                        onChange={(e) => setShowActual(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-gray-100 rounded border"></div>
                      <span>実割当額</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showDifference} 
                        onChange={(e) => setShowDifference(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-blue-100 rounded border"></div>
                      <span>差額（正）</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showDifference} 
                        onChange={(e) => setShowDifference(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-red-100 rounded border"></div>
                      <span>差額（負）</span>
                    </div>
                  </div>
                </div>
              </div>
              
              <div className="overflow-auto max-h-[80vh]" style={{ position: 'relative' }}>
                <table className="min-w-full relative">
                  <thead className="bg-gray-50 sticky top-0 z-40">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sticky left-0 bg-gray-50 z-15">
                        予算項目
                      </th>
                      {allocationCrossTable.months.map(month => (
                        <th key={month} className="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider min-w-[100px]">
                          {month}
                        </th>
                      ))}
                      <th className="px-1 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider bg-yellow-50" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                        合計
                      </th>
                      <th className="px-1 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider bg-green-50" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                        予算
                      </th>
                      <th className="px-1 py-2 text-center text-xs font-medium text-gray-500 uppercase tracking-wider bg-orange-50" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                        残額(日)
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {Object.keys(allocationCrossTable.budget_cross_table).length === 0 ? (
                      <tr>
                        <td colSpan={allocationCrossTable.months.length + 3} className="px-6 py-8 text-center text-gray-500">
                          期間が設定された助成金がありません
                        </td>
                      </tr>
                    ) : (
                      Object.entries(allocationCrossTable.budget_cross_table).map(([budgetItemName, amounts]: [string, any]) => {
                        const itemTotal = allocationCrossTable.months.reduce((totals: any, month: string) => {
                          const monthData = amounts[month];
                          if (monthData) {
                            // 計画値は常に含める
                            totals.planned += monthData.planned || 0;
                            // 実割当額と差額：未来月は除外
                            if (!isFutureMonth(month)) {
                              totals.actual += monthData.actual || 0;
                              totals.difference += monthData.difference || 0;
                            }
                          }
                          return totals;
                        }, { planned: 0, actual: 0, difference: 0 });
                        
                        return (
                          <tr key={budgetItemName} className="hover:bg-gray-50">
                            <td className="px-6 py-2 whitespace-nowrap text-sm font-medium text-gray-900 sticky left-0 bg-white">
                              {budgetItemName}
                            </td>
                            {(() => {
                              return allocationCrossTable.months.map(month => {
                                const monthData = amounts[month];
                                if (!monthData || (monthData.planned === 0 && monthData.actual === 0)) {
                                  return (
                                    <td key={month} className="px-4 py-2 whitespace-nowrap text-sm text-gray-900 text-right">
                                      -
                                    </td>
                                  );
                                }
                                
                                return (
                                  <td key={month} className="px-4 py-2 text-right text-xs">
                                    {showPlanned && (
                                      <div className="text-black font-medium bg-green-100 rounded px-1">
                                        {monthData.planned.toLocaleString()}
                                      </div>
                                    )}
                                    {showActual && (
                                      <div className="text-black bg-gray-100 rounded px-1">
                                        {isFutureMonth(month) ? '-' : `${monthData.actual.toLocaleString()}`}
                                      </div>
                                    )}
                                    {showDifference && (
                                      <div className="space-y-1">
                                        <div className={`text-black rounded px-1 whitespace-nowrap ${monthData.difference >= 0 ? 'bg-blue-100' : 'bg-red-100'}`}>
                                          {isFutureMonth(month) ? '-' : `${monthData.difference >= 0 ? '+' : ''}${monthData.difference.toLocaleString()}`}
                                        </div>
                                      </div>
                                    )}
                                  </td>
                                );
                              });
                            })()}
                            <td className="px-1 py-1 text-right text-xs bg-yellow-50" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                              {showPlanned && (
                                <div className="text-black font-medium bg-green-200 rounded px-1">
                                  {itemTotal.planned.toLocaleString()}
                                </div>
                              )}
                              {showActual && (
                                <div className="text-black bg-gray-200 rounded px-1">
                                  {itemTotal.actual.toLocaleString()}
                                </div>
                              )}
                              {showDifference && (
                                <div className={`text-black rounded px-1 whitespace-nowrap ${itemTotal.difference >= 0 ? 'bg-blue-200' : 'bg-red-200'}`}>
                                  {itemTotal.difference >= 0 ? '+' : ''}{itemTotal.difference.toLocaleString()}
                                </div>
                              )}
                            </td>
                            <td className="px-1 py-1 text-right text-xs bg-green-50" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                              {(() => {
                                // 予算項目名から予算項目情報を取得
                                const budgetItem = budgetItems.find(item => (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === budgetItemName);
                                const itemBudget = budgetItem?.budgeted_amount || amounts._budget_info?.budgeted_amount || itemTotal.planned || 0;
                                return (
                                  <div className="text-black text-xs">
                                    {itemBudget.toLocaleString()}
                                  </div>
                                );
                              })()}
                            </td>
                            {(() => {
                              const budgetInfo = amounts._budget_info || {};
                              const remainingAmount = budgetInfo.remaining_amount || 0;
                              const remainingDays = budgetInfo.remaining_days;

                              // 残額の色を決定
                              let remainingColor = 'text-gray-900';
                              if (remainingAmount <= 0) {
                                remainingColor = 'text-gray-400';
                              } else if (remainingDays !== null) {
                                if (remainingDays < 0) remainingColor = 'text-gray-400';
                                else if (remainingDays <= 30) remainingColor = 'text-red-600 font-bold';
                                else if (remainingDays <= 60) remainingColor = 'text-blue-600 font-bold';
                                else remainingColor = 'text-green-600 font-bold';
                              }
                              
                              let daysText = '-';
                              if (remainingDays !== null && remainingDays !== undefined) {
                                if (remainingDays < 0) {
                                  daysText = '終了済み';
                                } else {
                                  daysText = `${remainingDays}`;
                                }
                              }

                              return (
                                <td className="px-1 py-1 text-center text-xs bg-orange-50 whitespace-nowrap" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                                  <span className={remainingColor}>
                                    {Math.abs(remainingAmount).toLocaleString()}（{daysText}）
                                  </span>
                                </td>
                              );
                            })()}
                          </tr>
                        );
                      })
                    )}
                    
                    {/* 合計行 */}
                    {Object.keys(allocationCrossTable.budget_cross_table).length > 0 && (
                      <tr className="bg-blue-50 font-bold sticky bottom-0 z-40">
                        <td className="px-6 py-2 whitespace-nowrap text-sm font-bold text-gray-900 sticky left-0 bg-blue-50 z-15">
                          合計
                        </td>
                        {allocationCrossTable.months.map(month => {
                          const monthTotal = Object.values(allocationCrossTable.budget_cross_table).reduce((totals: any, amounts: any) => {
                            const monthData = amounts[month];
                            if (monthData && !isFutureMonth(month)) {
                              totals.planned += monthData.planned || 0;
                              totals.actual += monthData.actual || 0;
                              totals.difference += monthData.difference || 0;
                            }
                            return totals;
                          }, { planned: 0, actual: 0, difference: 0 });
                          
                          if (isFutureMonth(month)) {
                            return (
                              <td key={month} className="px-4 py-2 text-right text-xs">
                                {showPlanned && <div className="text-green-600 font-bold">-</div>}
                                {showActual && <div className="text-gray-800 font-bold">-</div>}
                                {showDifference && <div className="text-gray-500 font-bold">-</div>}
                              </td>
                            );
                          }
                          
                          return (
                            <td key={month} className="px-4 py-2 text-right text-xs">
                              {showPlanned && (
                                <div className="text-green-600 font-bold">
                                  {monthTotal.planned.toLocaleString()}
                                </div>
                              )}
                              {showActual && (
                                <div className="text-gray-800 font-bold">
                                  {monthTotal.actual.toLocaleString()}
                                </div>
                              )}
                              {showDifference && (
                                <div className={monthTotal.difference >= 0 ? 'text-blue-600 font-bold' : 'text-red-600 font-bold'}>
                                  {monthTotal.difference >= 0 ? '+' : ''}{monthTotal.difference.toLocaleString()}
                                </div>
                              )}
                            </td>
                          );
                        })}
                        <td className="px-1 py-1 text-right text-xs bg-yellow-100" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                          {(() => {
                            // 表示されている差額のみを合計
                            const grandTotal = Object.values(allocationCrossTable.budget_cross_table).reduce((totals: any, amounts: any) => {
                              allocationCrossTable.months.forEach(month => {
                                const monthData = amounts[month];
                                if (monthData) {
                                  // 計画値は常に含める
                                  totals.planned += monthData.planned || 0;
                                  
                                  // 実割当額と差額：未来月は"-"表示なので除外
                                  if (!isFutureMonth(month)) {
                                    totals.actual += monthData.actual || 0;
                                    totals.difference += monthData.difference || 0;
                                  }
                                }
                              });
                              return totals;
                            }, { planned: 0, actual: 0, difference: 0 });
                            
                            return (
                              <>
                                {showPlanned && (
                                  <div className="text-green-600 font-bold">
                                    {grandTotal.planned.toLocaleString()}
                                  </div>
                                )}
                                {showActual && (
                                  <div className="text-gray-800 font-bold">
                                    {grandTotal.actual.toLocaleString()}
                                  </div>
                                )}
                                {showDifference && (
                                  <div className={`whitespace-nowrap ${grandTotal.difference >= 0 ? 'text-blue-600 font-bold' : 'text-red-600 font-bold'}`}>
                                    {grandTotal.difference >= 0 ? '+' : ''}{grandTotal.difference.toLocaleString()}
                                  </div>
                                )}
                              </>
                            );
                          })()}
                        </td>
                        <td className="px-1 py-1 text-right text-xs bg-green-100" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                          {(() => {
                            const totalBudget = Object.entries(allocationCrossTable.budget_cross_table).reduce((total: number, [budgetItemName, amounts]: [string, any]) => {
                              const budgetItem = budgetItems.find(item => (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === budgetItemName);
                              const budgetInfo = amounts._budget_info || {};
                              const itemPlanned = Object.values(amounts).reduce((sum: number, monthData: any) => sum + (monthData?.planned || 0), 0);
                              return total + (budgetItem?.budgeted_amount || budgetInfo.budgeted_amount || itemPlanned || 0);
                            }, 0);
                            
                            return (
                              <div className="text-black text-xs font-bold">
                                {totalBudget.toLocaleString()}
                              </div>
                            );
                          })()}
                        </td>
                        <td className="px-1 py-1 text-center text-xs bg-orange-100" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                          <div className="text-gray-500">
                            -
                          </div>
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>

            {/* 期間配分版 予算項目×月 クロス集計表（カテゴリ順） */}
            <div className="bg-white rounded-lg shadow overflow-hidden mt-6">
              <div className="px-6 py-4 border-b border-gray-200">
                <div className="flex justify-between items-start">
                  <div>
                    <h3 className="text-lg font-medium text-gray-900">
                      予算項目×月 クロス集計表（期間配分版・カテゴリ順）
                    </h3>
                    <p className="text-sm text-gray-600 mt-1">
                      助成金の期間に基づいて日割り計算で配分した月ごとの予算項目別予算額（カテゴリ順に並び替え）
                    </p>
                  </div>
                  <div className="flex flex-col space-y-1 text-xs">
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showPlanned} 
                        onChange={(e) => setShowPlanned(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-green-100 rounded border"></div>
                      <span>期間配分予算</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showActual} 
                        onChange={(e) => setShowActual(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-gray-100 rounded border"></div>
                      <span>実割当額</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showDifference} 
                        onChange={(e) => setShowDifference(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-blue-100 rounded border"></div>
                      <span>差額（正）</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showDifference} 
                        onChange={(e) => setShowDifference(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-red-100 rounded border"></div>
                      <span>差額（負）</span>
                    </div>
                  </div>
                </div>
              </div>
              
              <div className="overflow-auto max-h-[80vh]" style={{ position: 'relative' }}>
                <table className="min-w-full relative">
                  <thead className="bg-gray-50 sticky top-0 z-40">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sticky left-0 bg-gray-50 z-15">
                        予算項目（カテゴリ順）
                      </th>
                      {allocationCrossTable.months.map(month => (
                        <th key={month} className="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider min-w-[100px]">
                          {month}
                        </th>
                      ))}
                      <th className="px-1 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider bg-yellow-50" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                        合計
                      </th>
                      <th className="px-1 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider bg-green-50" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                        予算
                      </th>
                      <th className="px-1 py-2 text-center text-xs font-medium text-gray-500 uppercase tracking-wider bg-orange-50" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                        残額(日)
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {Object.keys(allocationCrossTable.budget_cross_table).length === 0 ? (
                      <tr>
                        <td colSpan={allocationCrossTable.months.length + 3} className="px-6 py-8 text-center text-gray-500">
                          期間が設定された助成金がありません
                        </td>
                      </tr>
                    ) : (
                      (() => {
                        // 予算項目をカテゴリ順でソート
                        const budgetItemEntries = Object.entries(allocationCrossTable.budget_cross_table);
                        const sortedBudgetItems = budgetItemEntries.sort(([budgetItemNameA], [budgetItemNameB]) => {
                          // 予算項目名から対応するbudgetItemsのデータを取得
                          const budgetItemA = budgetItems.find(item => (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === budgetItemNameA);
                          const budgetItemB = budgetItems.find(item => (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === budgetItemNameB);
                          
                          const categoryA = budgetItemA?.category || 'その他';
                          const categoryB = budgetItemB?.category || 'その他';
                          
                          // まずカテゴリで並び替え、次に項目名で並び替え
                          if (categoryA !== categoryB) {
                            return categoryA.localeCompare(categoryB);
                          }
                          return budgetItemNameA.localeCompare(budgetItemNameB);
                        });

                        return sortedBudgetItems.map(([budgetItemName, amounts]: [string, any], index) => {
                          const itemTotal = {
                            planned: Object.values(amounts).reduce((total: number, amount: any) => total + (amount?.planned || 0), 0),
                            actual: Object.values(amounts).reduce((total: number, amount: any) => total + (amount?.actual || 0), 0),
                            difference: Object.values(amounts).reduce((total: number, amount: any) => total + (amount?.difference || 0), 0)
                          };
                          
                          // カテゴリ情報を取得
                          const budgetItem = budgetItems.find(item => (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === budgetItemName);
                          const category = budgetItem?.category || 'その他';
                          
                          // 前の項目と異なるカテゴリかどうかを判定
                          const prevItem = index > 0 ? sortedBudgetItems[index - 1] : null;
                          const prevBudgetItem = prevItem ? budgetItems.find(item => (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === prevItem[0]) : null;
                          const prevCategory = prevBudgetItem?.category || 'その他';
                          const isNewCategory = index === 0 || category !== prevCategory;
                          
                          return (
                            <tr key={budgetItemName} className={`hover:bg-gray-50 ${isNewCategory ? 'border-t-4 border-t-gray-800' : ''}`}>
                              <td className="px-6 py-2 whitespace-nowrap text-sm font-medium text-gray-900 sticky left-0 bg-white">
                                <div className="flex items-center justify-between">
                                  <div>{budgetItemName}</div>
                                  <div className="text-xs text-gray-500 ml-4">[{category}]</div>
                                </div>
                              </td>
                              {(() => {
                                return allocationCrossTable.months.map(month => {
                                  const monthData = amounts[month];
                                  if (!monthData || (monthData.planned === 0 && monthData.actual === 0)) {
                                    return (
                                      <td key={month} className="px-4 py-2 whitespace-nowrap text-sm text-gray-900 text-right">
                                        -
                                      </td>
                                    );
                                  }
                                  
                                  return (
                                    <td key={month} className="px-4 py-2 text-right text-xs">
                                      {showPlanned && (
                                        <div className="text-black font-medium bg-green-100 rounded px-1">
                                          {monthData.planned.toLocaleString()}
                                        </div>
                                      )}
                                      {showActual && (
                                        <div className="text-black bg-gray-100 rounded px-1">
                                          {isFutureMonth(month) ? '-' : `${monthData.actual.toLocaleString()}`}
                                        </div>
                                      )}
                                      {showDifference && (
                                        <div className="space-y-1">
                                          <div className={`text-black rounded px-1 whitespace-nowrap ${monthData.difference >= 0 ? 'bg-blue-100' : 'bg-red-100'}`}>
                                            {isFutureMonth(month) ? '-' : `${monthData.difference >= 0 ? '+' : ''}${monthData.difference.toLocaleString()}`}
                                          </div>
                                        </div>
                                      )}
                                    </td>
                                  );
                                });
                              })()}
                              <td className="px-1 py-1 text-right text-xs bg-yellow-50" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                                {showPlanned && (
                                  <div className="text-black font-medium bg-green-200 rounded px-1">
                                    {itemTotal.planned.toLocaleString()}
                                  </div>
                                )}
                                {showActual && (
                                  <div className="text-black bg-gray-200 rounded px-1">
                                    {itemTotal.actual.toLocaleString()}
                                  </div>
                                )}
                                {showDifference && (
                                  <div className={`text-black rounded px-1 whitespace-nowrap ${itemTotal.difference >= 0 ? 'bg-blue-200' : 'bg-red-200'}`}>
                                    {itemTotal.difference >= 0 ? '+' : ''}{itemTotal.difference.toLocaleString()}
                                  </div>
                                )}
                              </td>
                              <td className="px-1 py-1 text-right text-xs bg-green-50" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                                {(() => {
                                  // 予算項目名から予算項目情報を取得
                                  const budgetItem = budgetItems.find(item => (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === budgetItemName);
                                  const itemBudget = budgetItem?.budgeted_amount || amounts._budget_info?.budgeted_amount || itemTotal.planned || 0;
                                  return (
                                    <div className="text-black text-xs">
                                      {itemBudget.toLocaleString()}
                                    </div>
                                  );
                                })()}
                              </td>
                              {(() => {
                                const budgetInfo = amounts._budget_info || {};
                                const remainingAmount = budgetInfo.remaining_amount || 0;
                                const remainingDays = budgetInfo.remaining_days;

                                // 残額の色を決定
                                let remainingColor = 'text-gray-900';
                                if (remainingAmount <= 0) {
                                  remainingColor = 'text-gray-400';
                                } else if (remainingDays !== null) {
                                  if (remainingDays < 0) remainingColor = 'text-gray-400';
                                  else if (remainingDays <= 30) remainingColor = 'text-red-600 font-bold';
                                  else if (remainingDays <= 60) remainingColor = 'text-blue-600 font-bold';
                                  else remainingColor = 'text-green-600 font-bold';
                                }
                                
                                let daysText = '-';
                                if (remainingDays !== null && remainingDays !== undefined) {
                                  if (remainingDays < 0) {
                                    daysText = '終了済み';
                                  } else {
                                    daysText = `${remainingDays}`;
                                  }
                                }

                                return (
                                  <td className="px-1 py-1 text-center text-xs bg-orange-50 whitespace-nowrap" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                                    <span className={remainingColor}>
                                      {Math.abs(remainingAmount).toLocaleString()}（{daysText}）
                                    </span>
                                  </td>
                                );
                              })()}
                            </tr>
                          );
                        });
                      })()
                    )}
                    
                    {/* 合計行 */}
                    {Object.keys(allocationCrossTable.budget_cross_table).length > 0 && (
                      <tr className="bg-blue-50 font-bold sticky bottom-0 z-40 border-t-4 border-t-gray-800">
                        <td className="px-6 py-2 whitespace-nowrap text-sm font-bold text-gray-900 sticky left-0 bg-blue-50 z-15">
                          合計
                        </td>
                        {allocationCrossTable.months.map(month => {
                          const monthTotal = Object.values(allocationCrossTable.budget_cross_table).reduce((totals: any, amounts: any) => {
                            const monthData = amounts[month];
                            if (monthData && !isFutureMonth(month)) {
                              totals.planned += monthData.planned || 0;
                              totals.actual += monthData.actual || 0;
                              totals.difference += monthData.difference || 0;
                            }
                            return totals;
                          }, { planned: 0, actual: 0, difference: 0 });
                          
                          if (isFutureMonth(month)) {
                            return (
                              <td key={month} className="px-4 py-2 text-right text-xs">
                                {showPlanned && <div className="text-green-600 font-bold">-</div>}
                                {showActual && <div className="text-gray-800 font-bold">-</div>}
                                {showDifference && <div className="text-gray-500 font-bold">-</div>}
                              </td>
                            );
                          }
                          
                          return (
                            <td key={month} className="px-4 py-2 text-right text-xs">
                              {showPlanned && (
                                <div className="text-green-600 font-bold">
                                  {monthTotal.planned.toLocaleString()}
                                </div>
                              )}
                              {showActual && (
                                <div className="text-gray-800 font-bold">
                                  {monthTotal.actual.toLocaleString()}
                                </div>
                              )}
                              {showDifference && (
                                <div className={monthTotal.difference >= 0 ? 'text-blue-600 font-bold' : 'text-red-600 font-bold'}>
                                  {monthTotal.difference >= 0 ? '+' : ''}{monthTotal.difference.toLocaleString()}
                                </div>
                              )}
                            </td>
                          );
                        })}
                        <td className="px-1 py-1 text-right text-xs bg-yellow-100" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                          {(() => {
                            // 表示されている差額のみを合計
                            const grandTotal = Object.values(allocationCrossTable.budget_cross_table).reduce((totals: any, amounts: any) => {
                              allocationCrossTable.months.forEach(month => {
                                const monthData = amounts[month];
                                if (monthData) {
                                  // 計画値は常に含める
                                  totals.planned += monthData.planned || 0;
                                  
                                  // 実割当額と差額：未来月は"-"表示なので除外
                                  if (!isFutureMonth(month)) {
                                    totals.actual += monthData.actual || 0;
                                    totals.difference += monthData.difference || 0;
                                  }
                                }
                              });
                              return totals;
                            }, { planned: 0, actual: 0, difference: 0 });
                            
                            return (
                              <>
                                {showPlanned && (
                                  <div className="text-green-600 font-bold">
                                    {grandTotal.planned.toLocaleString()}
                                  </div>
                                )}
                                {showActual && (
                                  <div className="text-gray-800 font-bold">
                                    {grandTotal.actual.toLocaleString()}
                                  </div>
                                )}
                                {showDifference && (
                                  <div className={`whitespace-nowrap ${grandTotal.difference >= 0 ? 'text-blue-600 font-bold' : 'text-red-600 font-bold'}`}>
                                    {grandTotal.difference >= 0 ? '+' : ''}{grandTotal.difference.toLocaleString()}
                                  </div>
                                )}
                              </>
                            );
                          })()}
                        </td>
                        <td className="px-1 py-1 text-right text-xs bg-green-100" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                          {(() => {
                            const totalBudget = Object.entries(allocationCrossTable.budget_cross_table).reduce((total: number, [budgetItemName, amounts]: [string, any]) => {
                              const budgetItem = budgetItems.find(item => (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === budgetItemName);
                              const budgetInfo = amounts._budget_info || {};
                              const itemPlanned = Object.values(amounts).reduce((sum: number, monthData: any) => sum + (monthData?.planned || 0), 0);
                              return total + (budgetItem?.budgeted_amount || budgetInfo.budgeted_amount || itemPlanned || 0);
                            }, 0);
                            
                            return (
                              <div className="text-black text-xs font-bold">
                                {totalBudget.toLocaleString()}
                              </div>
                            );
                          })()}
                        </td>
                        <td className="px-1 py-1 text-center text-xs bg-orange-100" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                          <div className="text-gray-500">
                            -
                          </div>
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>

            {/* 期間配分版 カテゴリ×月 クロス集計表 */}
            <div className="bg-white rounded-lg shadow overflow-hidden">
              <div className="px-6 py-4 border-b border-gray-200">
                <div className="flex justify-between items-start">
                  <div>
                    <h3 className="text-lg font-medium text-gray-900">
                      カテゴリ×月 クロス集計表（期間配分版）
                    </h3>
                    <p className="text-sm text-gray-600 mt-1">
                      助成金の期間に基づいて日割り計算で配分した月ごとのカテゴリ別予算額
                    </p>
                  </div>
                  <div className="flex flex-col space-y-1 text-xs">
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showPlanned} 
                        onChange={(e) => setShowPlanned(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-green-100 rounded border"></div>
                      <span>期間配分予算</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showActual} 
                        onChange={(e) => setShowActual(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-gray-100 rounded border"></div>
                      <span>実割当額</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showDifference} 
                        onChange={(e) => setShowDifference(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-blue-100 rounded border"></div>
                      <span>差額（正）</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showDifference} 
                        onChange={(e) => setShowDifference(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-red-100 rounded border"></div>
                      <span>差額（負）</span>
                    </div>
                  </div>
                </div>
              </div>
              
              <div className="overflow-auto max-h-[80vh]" style={{ position: 'relative' }}>
                <table className="min-w-full relative">
                  <thead className="bg-gray-50 sticky top-0 z-40">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sticky left-0 bg-gray-50 z-15">
                        カテゴリ
                      </th>
                      {allocationCrossTable.months.map(month => (
                        <th key={month} className="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider min-w-[100px]">
                          {month}
                        </th>
                      ))}
                      <th className="px-1 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider bg-yellow-50" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                        合計
                      </th>
                      <th className="px-1 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider bg-green-50" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                        予算
                      </th>
                      <th className="px-1 py-2 text-center text-xs font-medium text-gray-500 uppercase tracking-wider bg-orange-50" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                        残額(日)
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {Object.keys(allocationCrossTable.category_cross_table).length === 0 ? (
                      <tr>
                        <td colSpan={allocationCrossTable.months.length + 2} className="px-6 py-8 text-center text-gray-500">
                          期間が設定された助成金がありません
                        </td>
                      </tr>
                    ) : (
                      Object.entries(allocationCrossTable.category_cross_table).map(([category, amounts]: [string, any]) => {
                        const categoryTotal = {
                          planned: Object.values(amounts).reduce((total: number, amount: any) => total + (amount?.planned || 0), 0),
                          actual: Object.values(amounts).reduce((total: number, amount: any) => total + (amount?.actual || 0), 0),
                          difference: Object.values(amounts).reduce((total: number, amount: any) => total + (amount?.difference || 0), 0)
                        };
                        
                        return (
                          <tr key={category} className="hover:bg-gray-50">
                            <td className="px-6 py-2 whitespace-nowrap text-sm font-medium text-gray-900 sticky left-0 bg-white">
                              {category}
                            </td>
                            {(() => {
                              return allocationCrossTable.months.map(month => {
                                const monthData = amounts[month];
                                if (!monthData || (monthData.planned === 0 && monthData.actual === 0)) {
                                  return (
                                    <td key={month} className="px-4 py-2 whitespace-nowrap text-sm text-gray-900 text-right">
                                      -
                                    </td>
                                  );
                                }
                                
                                return (
                                  <td key={month} className="px-4 py-2 text-right text-xs">
                                    {showPlanned && (
                                      <div className="text-black font-medium bg-green-100 rounded px-1">
                                        {monthData.planned.toLocaleString()}
                                      </div>
                                    )}
                                    {showActual && (
                                      <div className="text-black bg-gray-100 rounded px-1">
                                        {isFutureMonth(month) ? '-' : `${monthData.actual.toLocaleString()}`}
                                      </div>
                                    )}
                                    {showDifference && (
                                      <div className="space-y-1">
                                        <div className={`text-black rounded px-1 whitespace-nowrap ${monthData.difference >= 0 ? 'bg-blue-100' : 'bg-red-100'}`}>
                                          {isFutureMonth(month) ? '-' : `${monthData.difference >= 0 ? '+' : ''}${monthData.difference.toLocaleString()}`}
                                        </div>
                                      </div>
                                    )}
                                  </td>
                                );
                              });
                            })()}
                            <td className="px-1 py-1 text-right text-xs bg-yellow-50" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                              {showPlanned && (
                                <div className="text-black font-medium bg-green-100 rounded px-1">
                                  {categoryTotal.planned.toLocaleString()}
                                </div>
                              )}
                              {showActual && (
                                <div className="text-black bg-gray-100 rounded px-1">
                                  {categoryTotal.actual.toLocaleString()}
                                </div>
                              )}
                              {showDifference && (
                                <div className={`text-black rounded px-1 ${categoryTotal.difference >= 0 ? 'bg-blue-100' : 'bg-red-100'}`}>
                                  {categoryTotal.difference >= 0 ? '+' : ''}{categoryTotal.difference.toLocaleString()}
                                </div>
                              )}
                            </td>
                            <td className="px-1 py-1 text-right text-xs bg-green-50" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                              <div className="text-black font-medium">
                                {amounts._category_info?.budgeted_amount?.toLocaleString() || '0'}
                              </div>
                            </td>
                            {(() => {
                              const categoryInfo = amounts._category_info || {};
                              const remainingAmount = categoryInfo.remaining_amount || 0;
                              const remainingDays = categoryInfo.remaining_days;

                              // 残額の色を決定
                              let remainingColor = 'text-gray-900';
                              if (remainingAmount <= 0) {
                                remainingColor = 'text-gray-400';
                              } else if (remainingDays !== null) {
                                if (remainingDays < 0) remainingColor = 'text-gray-400';
                                else if (remainingDays <= 30) remainingColor = 'text-red-600 font-bold';
                                else if (remainingDays <= 60) remainingColor = 'text-blue-600 font-bold';
                                else remainingColor = 'text-green-600 font-bold';
                              }
                              
                              let daysText = '-';
                              if (remainingDays !== null && remainingDays !== undefined) {
                                if (remainingDays < 0) {
                                  daysText = '終了済み';
                                } else {
                                  daysText = `${remainingDays}`;
                                }
                              }

                              return (
                                <td className="px-1 py-1 text-center text-xs bg-orange-50 whitespace-nowrap" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                                  <span className={remainingColor}>
                                    {remainingAmount.toLocaleString()}（{daysText}）
                                  </span>
                                </td>
                              );
                            })()}
                          </tr>
                        );
                      })
                    )}
                    
                    {/* 合計行 */}
                    {Object.keys(allocationCrossTable.category_cross_table).length > 0 && (
                      <tr className="bg-blue-50 font-bold sticky bottom-0 z-40">
                        <td className="px-6 py-2 whitespace-nowrap text-sm font-bold text-gray-900 sticky left-0 bg-blue-50 z-15">
                          合計
                        </td>
                        {allocationCrossTable.months.map(month => {
                          const monthTotal = Object.values(allocationCrossTable.category_cross_table).reduce((totals: any, amounts: any) => {
                            const monthData = amounts[month];
                            if (monthData && !isFutureMonth(month)) {
                              totals.planned += monthData.planned || 0;
                              totals.actual += monthData.actual || 0;
                              totals.difference += monthData.difference || 0;
                            }
                            return totals;
                          }, { planned: 0, actual: 0, difference: 0 });
                          
                          if (isFutureMonth(month)) {
                            return (
                              <td key={month} className="px-4 py-2 text-right text-xs">
                                {showPlanned && <div className="text-green-600 font-bold">-</div>}
                                {showActual && <div className="text-gray-800 font-bold">-</div>}
                                {showDifference && <div className="text-gray-500 font-bold">-</div>}
                              </td>
                            );
                          }
                          
                          return (
                            <td key={month} className="px-4 py-2 text-right text-xs">
                              {showPlanned && (
                                <div className="text-green-600 font-bold">
                                  {monthTotal.planned.toLocaleString()}
                                </div>
                              )}
                              {showActual && (
                                <div className="text-gray-800 font-bold">
                                  {monthTotal.actual.toLocaleString()}
                                </div>
                              )}
                              {showDifference && (
                                <div className={monthTotal.difference >= 0 ? 'text-blue-600 font-bold' : 'text-red-600 font-bold'}>
                                  {monthTotal.difference >= 0 ? '+' : ''}{monthTotal.difference.toLocaleString()}
                                </div>
                              )}
                            </td>
                          );
                        })}
                        <td className="px-1 py-1 text-right text-xs bg-yellow-100" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                          {(() => {
                            const grandTotal = allocationCrossTable.months.reduce((totals: any, month: string) => {
                              if (!isFutureMonth(month)) {
                                const monthTotal = Object.values(allocationCrossTable.category_cross_table).reduce((monthTotals: any, amounts: any) => {
                                  const monthData = amounts[month];
                                  if (monthData) {
                                    monthTotals.planned += monthData.planned || 0;
                                    monthTotals.actual += monthData.actual || 0;
                                    monthTotals.difference += monthData.difference || 0;
                                  }
                                  return monthTotals;
                                }, { planned: 0, actual: 0, difference: 0 });
                                
                                totals.planned += monthTotal.planned;
                                totals.actual += monthTotal.actual;
                                totals.difference += monthTotal.difference;
                              }
                              return totals;
                            }, { planned: 0, actual: 0, difference: 0 });
                            
                            return (
                              <>
                                {showPlanned && (
                                  <div className="text-green-600 font-bold">
                                    {grandTotal.planned.toLocaleString()}
                                  </div>
                                )}
                                {showActual && (
                                  <div className="text-gray-800 font-bold">
                                    {grandTotal.actual.toLocaleString()}
                                  </div>
                                )}
                                {showDifference && (
                                  <div className={`whitespace-nowrap ${grandTotal.difference >= 0 ? 'text-blue-600 font-bold' : 'text-red-600 font-bold'}`}>
                                    {grandTotal.difference >= 0 ? '+' : ''}{grandTotal.difference.toLocaleString()}
                                  </div>
                                )}
                              </>
                            );
                          })()}
                        </td>
                        <td className="px-1 py-1 text-right text-xs bg-green-100" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                          {(() => {
                            const totalBudget = Object.values(allocationCrossTable.category_cross_table).reduce((total: number, amounts: any) => {
                              const categoryInfo = amounts._category_info || {};
                              return total + (categoryInfo.budgeted_amount || 0);
                            }, 0);
                            
                            return (
                              <div className="text-black text-xs font-bold">
                                {totalBudget.toLocaleString()}
                              </div>
                            );
                          })()}
                        </td>
                        <td className="px-1 py-1 text-center text-xs bg-orange-100" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                          <div className="text-gray-500">
                            -
                          </div>
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
            
            {/* 期間配分版 助成金×月 クロス集計表 */}
            <div className="bg-white rounded-lg shadow overflow-hidden mt-6">
              <div className="px-6 py-4 border-b border-gray-200">
                <div className="flex justify-between items-start">
                  <div>
                    <h3 className="text-lg font-medium text-gray-900">
                      助成金×月 クロス集計表（期間配分版）
                    </h3>
                    <p className="text-sm text-gray-600 mt-1">
                      助成金の期間に基づいて日割り計算で配分した月ごとの助成金別予算額
                    </p>
                  </div>
                  <div className="flex flex-col space-y-1 text-xs">
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showPlanned} 
                        onChange={(e) => setShowPlanned(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-green-100 rounded border"></div>
                      <span>期間配分予算</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showActual} 
                        onChange={(e) => setShowActual(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-gray-100 rounded border"></div>
                      <span>実割当額</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showDifference} 
                        onChange={(e) => setShowDifference(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-blue-100 rounded border"></div>
                      <span>差額（正）</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <input 
                        type="checkbox" 
                        checked={showDifference} 
                        onChange={(e) => setShowDifference(e.target.checked)}
                        className="w-3 h-3"
                      />
                      <div className="w-3 h-3 bg-red-100 rounded border"></div>
                      <span>差額（負）</span>
                    </div>
                  </div>
                </div>
              </div>
              
              <div className="overflow-auto max-h-[80vh]" style={{ position: 'relative' }}>
                <table className="min-w-full relative">
                  <thead className="bg-gray-50 sticky top-0 z-40">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sticky left-0 bg-gray-50 z-15">
                        助成金
                      </th>
                      {allocationCrossTable.months.map(month => (
                        <th key={month} className="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider min-w-[100px]">
                          {month}
                        </th>
                      ))}
                      <th className="px-1 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider bg-yellow-50" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                        合計
                      </th>
                      <th className="px-1 py-2 text-right text-xs font-medium text-gray-500 uppercase tracking-wider bg-green-50" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                        予算
                      </th>
                      <th className="px-1 py-2 text-center text-xs font-medium text-gray-500 uppercase tracking-wider bg-orange-50" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                        残額(日)
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {Object.keys(allocationCrossTable.grant_cross_table || {}).length === 0 ? (
                      <tr>
                        <td colSpan={allocationCrossTable.months.length + 3} className="px-6 py-8 text-center text-gray-500">
                          期間が設定された助成金がありません
                        </td>
                      </tr>
                    ) : (
                      Object.entries(allocationCrossTable.grant_cross_table).map(([grantName, amounts], index) => {
                        // 助成金別合計を計算
                        const grantTotal = allocationCrossTable.months.reduce((total, month) => {
                          const monthData = amounts[month];
                          if (monthData) {
                            total.planned += monthData.planned || 0;
                            total.actual += monthData.actual || 0;
                            total.difference += monthData.difference || 0;
                          }
                          return total;
                        }, { planned: 0, actual: 0, difference: 0 });

                        return (
                          <tr key={grantName} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                            <td className="px-6 py-2 whitespace-nowrap text-sm font-medium text-gray-900 sticky left-0 bg-inherit z-10">
                              {grantName}
                            </td>
                            {(() => {
                              return allocationCrossTable.months.map(month => {
                                const monthData = amounts[month];
                                if (!monthData || (monthData.planned === 0 && monthData.actual === 0)) {
                                  return (
                                    <td key={month} className="px-4 py-2 whitespace-nowrap text-sm text-gray-900 text-right">
                                      -
                                    </td>
                                  );
                                }
                                
                                return (
                                  <td key={month} className="px-4 py-2 text-right text-xs">
                                    {showPlanned && (
                                      <div className="text-black font-medium bg-green-100 rounded px-1">
                                        {monthData.planned.toLocaleString()}
                                      </div>
                                    )}
                                    {showActual && (
                                      <div className="text-black bg-gray-100 rounded px-1">
                                        {isFutureMonth(month) ? '-' : `${monthData.actual.toLocaleString()}`}
                                      </div>
                                    )}
                                    {showDifference && (
                                      <div className="space-y-1">
                                        <div className={`text-black rounded px-1 whitespace-nowrap ${monthData.difference >= 0 ? 'bg-blue-100' : 'bg-red-100'}`}>
                                          {isFutureMonth(month) ? '-' : `${monthData.difference >= 0 ? '+' : ''}${monthData.difference.toLocaleString()}`}
                                        </div>
                                      </div>
                                    )}
                                  </td>
                                );
                              });
                            })()}
                            <td className="px-1 py-1 text-right text-xs bg-yellow-50" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                              {showPlanned && (
                                <div className="text-black font-medium bg-green-100 rounded px-1">
                                  {grantTotal.planned.toLocaleString()}
                                </div>
                              )}
                              {showActual && (
                                <div className="text-black bg-gray-100 rounded px-1">
                                  {grantTotal.actual.toLocaleString()}
                                </div>
                              )}
                              {showDifference && (
                                <div className={`text-black rounded px-1 ${grantTotal.difference >= 0 ? 'bg-blue-100' : 'bg-red-100'}`}>
                                  {grantTotal.difference >= 0 ? '+' : ''}{grantTotal.difference.toLocaleString()}
                                </div>
                              )}
                            </td>
                            <td className="px-1 py-1 text-right text-xs bg-green-50" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                              {(() => {
                                // 助成金名から助成金情報を取得
                                const grant = grants.find(g => g.name === grantName);
                                const grantBudget = grant?.total_amount || amounts._grant_info?.grant_total_amount || grantTotal.planned || 0;
                                return (
                                  <div className="text-black text-xs">
                                    {grantBudget.toLocaleString()}
                                  </div>
                                );
                              })()}
                            </td>
                            {(() => {
                              const grantInfo = amounts._grant_info || {};
                              const remainingAmount = grantInfo.remaining_amount || 0;
                              const remainingDays = grantInfo.remaining_days;

                              // 残額の色を決定
                              let remainingColor = 'text-gray-900';
                              if (remainingAmount <= 0) {
                                remainingColor = 'text-gray-400';
                              } else if (remainingDays !== null) {
                                if (remainingDays < 0) remainingColor = 'text-gray-400';
                                else if (remainingDays <= 30) remainingColor = 'text-red-600 font-bold';
                                else if (remainingDays <= 60) remainingColor = 'text-blue-600 font-bold';
                                else remainingColor = 'text-green-600 font-bold';
                              }
                              
                              let daysText = '-';
                              if (remainingDays !== null && remainingDays !== undefined) {
                                if (remainingDays < 0) {
                                  daysText = '終了済み';
                                } else {
                                  daysText = `${remainingDays}`;
                                }
                              }

                              return (
                                <td className="px-1 py-1 text-center text-xs bg-orange-50 whitespace-nowrap" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                                  <span className={remainingColor}>
                                    {remainingAmount.toLocaleString()}（{daysText}）
                                  </span>
                                </td>
                              );
                            })()}
                          </tr>
                        );
                      })
                    )}
                    
                    {/* 総合計行 */}
                    {Object.keys(allocationCrossTable.grant_cross_table || {}).length > 0 && (
                      <tr className="bg-blue-50 border-t-2 border-blue-200 font-bold sticky bottom-0 z-20">
                        <td className="px-6 py-3 text-sm text-gray-900 sticky left-0 bg-blue-50 z-30">
                          総合計
                        </td>
                        {allocationCrossTable.months.map(month => {
                          const monthTotal = Object.values(allocationCrossTable.grant_cross_table).reduce((total, amounts) => {
                            const monthData = amounts[month];
                            if (monthData && !isFutureMonth(month)) {
                              total.planned += monthData.planned || 0;
                              total.actual += monthData.actual || 0;
                              total.difference += monthData.difference || 0;
                            }
                            return total;
                          }, { planned: 0, actual: 0, difference: 0 });

                          if (isFutureMonth(month)) {
                            return (
                              <td key={month} className="px-4 py-3 text-right text-xs">
                                {showPlanned && <div className="text-green-600 font-bold">-</div>}
                                {showActual && <div className="text-gray-800 font-bold">-</div>}
                                {showDifference && <div className="text-gray-500 font-bold">-</div>}
                              </td>
                            );
                          }
                          
                          return (
                            <td key={month} className="px-4 py-3 text-right text-xs">
                              {showPlanned && (
                                <div className="text-green-600 font-bold">
                                  {monthTotal.planned.toLocaleString()}
                                </div>
                              )}
                              {showActual && (
                                <div className="text-gray-800 font-bold">
                                  {monthTotal.actual.toLocaleString()}
                                </div>
                              )}
                              {showDifference && (
                                <div className={monthTotal.difference >= 0 ? 'text-blue-600 font-bold' : 'text-red-600 font-bold'}>
                                  {monthTotal.difference >= 0 ? '+' : ''}{monthTotal.difference.toLocaleString()}
                                </div>
                              )}
                            </td>
                          );
                        })}
                        <td className="px-1 py-2 text-right text-xs bg-yellow-100" style={{ position: 'sticky', right: '240px', zIndex: 25, width: '100px', minWidth: '100px' }}>
                          {(() => {
                            const grandTotal = allocationCrossTable.months.reduce((totals: any, month: string) => {
                              if (!isFutureMonth(month)) {
                                const monthTotal = Object.values(allocationCrossTable.grant_cross_table).reduce((monthTotals: any, amounts: any) => {
                                  const monthData = amounts[month];
                                  if (monthData) {
                                    monthTotals.planned += monthData.planned || 0;
                                    monthTotals.actual += monthData.actual || 0;
                                    monthTotals.difference += monthData.difference || 0;
                                  }
                                  return monthTotals;
                                }, { planned: 0, actual: 0, difference: 0 });
                                
                                totals.planned += monthTotal.planned;
                                totals.actual += monthTotal.actual;
                                totals.difference += monthTotal.difference;
                              }
                              return totals;
                            }, { planned: 0, actual: 0, difference: 0 });

                            return (
                              <>
                                {showPlanned && (
                                  <div className="text-green-600 font-bold">
                                    {grandTotal.planned.toLocaleString()}
                                  </div>
                                )}
                                {showActual && (
                                  <div className="text-gray-800 font-bold">
                                    {grandTotal.actual.toLocaleString()}
                                  </div>
                                )}
                                {showDifference && (
                                  <div className={`whitespace-nowrap ${grandTotal.difference >= 0 ? 'text-blue-600 font-bold' : 'text-red-600 font-bold'}`}>
                                    {grandTotal.difference >= 0 ? '+' : ''}{grandTotal.difference.toLocaleString()}
                                  </div>
                                )}
                              </>
                            );
                          })()}
                        </td>
                        <td className="px-1 py-2 text-right text-xs bg-green-100" style={{ position: 'sticky', right: '140px', zIndex: 30, width: '100px', minWidth: '100px' }}>
                          {(() => {
                            const totalBudget = Object.entries(allocationCrossTable.grant_cross_table).reduce((total: number, [grantName, amounts]: [string, any]) => {
                              const grant = grants.find(g => g.name === grantName);
                              const grantInfo = amounts._grant_info || {};
                              const grantPlanned = Object.values(amounts).reduce((sum: number, monthData: any) => sum + (monthData?.planned || 0), 0);
                              return total + (grant?.total_amount || grantInfo.grant_total_amount || grantPlanned || 0);
                            }, 0);
                            
                            return (
                              <div className="text-black text-xs font-bold">
                                {totalBudget.toLocaleString()}
                              </div>
                            );
                          })()}
                        </td>
                        <td className="px-1 py-2 text-center text-xs bg-orange-100" style={{ position: 'sticky', right: '0', zIndex: 35, width: '140px', minWidth: '140px' }}>
                          <div className="text-gray-500">
                            -
                          </div>
                          <div className="text-gray-500">
                            -
                          </div>
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )
      )}
    </div>
  );
};

export default ReportsPage;