'use client';

import React, { useState, useEffect } from 'react';
import { api, Transaction, BudgetItem, Grant } from '@/lib/api';

interface BatchAllocationPanelProps {
  selectedRows: Transaction[];
}

const BatchAllocationPanel: React.FC<BatchAllocationPanelProps> = ({ selectedRows }) => {
  const [budgetItems, setBudgetItems] = useState<BudgetItem[]>([]);
  const [grants, setGrants] = useState<Grant[]>([]);
  const [selectedBudgetItem, setSelectedBudgetItem] = useState<BudgetItem | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // 予算項目データを取得
  useEffect(() => {
    const fetchData = async () => {
      try {
        const [budgetItemsResponse, grantsResponse] = await Promise.all([
          api.getBudgetItems(),
          api.getGrants()
        ]);
        setBudgetItems(budgetItemsResponse);
        setGrants(grantsResponse);
      } catch (err) {
        setError('データの取得に失敗しました');
        console.error('Error fetching data:', err);
      }
    };

    fetchData();
  }, []);

  // 一括割当実行
  const handleBatchAllocation = async () => {
    if (!selectedBudgetItem || selectedRows.length === 0) {
      setError('予算項目を選択し、取引を選択してください');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      // 各取引に対して割当を実行
      const allocationPromises = selectedRows.map(async (transaction) => {
        const allocationData = {
          transaction_id: transaction.id,
          budget_item_id: selectedBudgetItem.id,
          amount: transaction.amount
        };

        // 既存の割当があるかチェック
        const existingAllocations = await api.getAllocations();
        const existingAllocation = existingAllocations.find(
          (allocation: any) => allocation.transaction_id === transaction.id
        );

        if (existingAllocation) {
          // 更新
          return api.updateAllocation(existingAllocation.id, allocationData);
        } else {
          // 新規作成
          return api.createAllocation(allocationData);
        }
      });

      await Promise.all(allocationPromises);
      
      // 成功メッセージ
      setError(null);
      alert(`${selectedRows.length}件の取引を「${selectedBudgetItem.display_name}」に割り当てました`);
      
      // 選択をクリア
      setSelectedBudgetItem(null);
      
    } catch (err) {
      setError('一括割当に失敗しました');
      console.error('Error in batch allocation:', err);
    } finally {
      setLoading(false);
    }
  };

  // 選択された取引の合計金額を計算
  const totalAmount = selectedRows.reduce((sum, row) => sum + row.amount, 0);

  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-4 h-full">
      <h2 className="text-lg font-semibold mb-4">一括割当</h2>
      
      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-3 py-2 rounded mb-4">
          {error}
        </div>
      )}
      
      <div className="space-y-4">
        {/* 選択された取引の情報 */}
        <div className="bg-gray-50 p-3 rounded">
          <h3 className="font-medium text-gray-700 mb-2">選択された取引</h3>
          <div className="text-sm text-gray-600">
            <div>件数: {selectedRows.length}件</div>
            <div>合計金額: ¥{totalAmount.toLocaleString()}</div>
          </div>
        </div>

        {/* 予算項目選択 */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            割当先予算項目
          </label>
          <select
            value={selectedBudgetItem?.id || ''}
            onChange={(e) => {
              const budgetItem = budgetItems.find(item => item.id === parseInt(e.target.value));
              setSelectedBudgetItem(budgetItem || null);
            }}
            className="w-full p-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          >
            <option value="">予算項目を選択...</option>
            {grants.map(grant => (
              <optgroup key={grant.id} label={grant.name}>
                {budgetItems
                  .filter(item => item.grant_id === grant.id)
                  .map(item => (
                    <option key={item.id} value={item.id}>
                      {item.display_name}
                    </option>
                  ))}
              </optgroup>
            ))}
          </select>
        </div>

        {/* 選択された予算項目の情報 */}
        {selectedBudgetItem && (
          <div className="bg-blue-50 p-3 rounded">
            <h4 className="font-medium text-blue-700 mb-1">選択された予算項目</h4>
            <div className="text-sm text-blue-600">
              <div>{selectedBudgetItem.display_name}</div>
              <div>予算額: ¥{selectedBudgetItem.budgeted_amount.toLocaleString()}</div>
            </div>
          </div>
        )}

        {/* 実行ボタン */}
        <button
          onClick={handleBatchAllocation}
          disabled={loading || !selectedBudgetItem || selectedRows.length === 0}
          className={`w-full py-2 px-4 rounded-md font-medium ${
            loading || !selectedBudgetItem || selectedRows.length === 0
              ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
              : 'bg-blue-600 text-white hover:bg-blue-700'
          }`}
        >
          {loading ? '実行中...' : `${selectedRows.length}件を一括割当`}
        </button>
      </div>
    </div>
  );
};

export default BatchAllocationPanel;