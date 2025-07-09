'use client';

import React, { useMemo } from 'react';
import { Transaction } from '@/lib/api';

interface SummaryPanelProps {
  selectedRows: Transaction[];
}

const SummaryPanel: React.FC<SummaryPanelProps> = ({ selectedRows }) => {
  const summary = useMemo(() => {
    if (!selectedRows || selectedRows.length === 0) {
      return {
        total: 0,
        count: 0,
        byBudgetItem: {}
      };
    }

    const total = selectedRows.reduce((sum, row) => sum + (row.amount || 0), 0);
    const count = selectedRows.length;

    // 予算項目別集計
    const byBudgetItem = selectedRows.reduce((acc, row) => {
      // 予算項目は文字列または未割当として扱う
      let budgetItem: string;
      if (typeof row.budget_item === 'string') {
        budgetItem = row.budget_item;
      } else if (row.budget_item?.name) {
        budgetItem = row.budget_item.name;
      } else {
        budgetItem = '未割当';
      }
      
      // '未割当'の場合はそのまま、それ以外は表示名として扱う
      if (budgetItem === '未割当' || !budgetItem) {
        budgetItem = '未割当';
      }
      
      acc[budgetItem] = (acc[budgetItem] || 0) + (row.amount || 0);
      return acc;
    }, {} as Record<string, number>);

    return {
      total,
      count,
      byBudgetItem
    };
  }, [selectedRows]);

  return (
    <div className="w-80 p-4 bg-gray-50 border-l overflow-y-auto">
      <h3 className="font-bold mb-4 text-lg">選択中の集計</h3>
      
      {/* 基本情報 */}
      <div className="mb-6 p-3 bg-white rounded shadow">
        <div className="flex justify-between items-center mb-2">
          <span className="font-semibold">件数:</span>
          <span className="font-bold text-blue-600">{summary.count}件</span>
        </div>
        <div className="flex justify-between items-center">
          <span className="font-semibold">合計:</span>
          <span className="font-bold text-green-600">{summary.total.toLocaleString()}円</span>
        </div>
      </div>

      {/* 予算項目別集計 */}
      <div className="mb-6">
        <h4 className="font-bold mb-2 text-sm text-gray-700">予算項目別</h4>
        <div className="space-y-1">
          {Object.entries(summary.byBudgetItem).map(([budgetItem, amount]) => (
            <div key={budgetItem} className="flex justify-between text-sm p-2 bg-white rounded">
              <span className="truncate flex-1 mr-2">{budgetItem}</span>
              <span className="font-semibold">{amount.toLocaleString()}円</span>
            </div>
          ))}
        </div>
      </div>

      {/* 平均値 */}
      {summary.count > 0 && (
        <div className="p-3 bg-blue-50 rounded">
          <div className="flex justify-between text-sm">
            <span>平均金額:</span>
            <span className="font-semibold">{Math.round(summary.total / summary.count).toLocaleString()}円</span>
          </div>
        </div>
      )}
    </div>
  );
};

export default SummaryPanel;