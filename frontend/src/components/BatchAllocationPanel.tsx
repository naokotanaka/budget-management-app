'use client';

import React, { useState, useEffect, useRef } from 'react';
import { AgGridReact } from 'ag-grid-react';
import { ColDef, themeAlpine } from 'ag-grid-community';
import { api, Transaction, BudgetItem, Grant } from '@/lib/api';
import '@/lib/ag-grid-setup';

interface BatchAllocationPanelProps {
  selectedRows: Transaction[];
  onAllocationComplete?: () => void;
}

const BatchAllocationPanel: React.FC<BatchAllocationPanelProps> = ({ selectedRows, onAllocationComplete }) => {
  const [budgetItems, setBudgetItems] = useState<BudgetItem[]>([]);
  const [grants, setGrants] = useState<Grant[]>([]);
  const [selectedBudgetItem, setSelectedBudgetItem] = useState<BudgetItem | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  
  const budgetGridRef = useRef<AgGridReact>(null);


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

  // 予算項目グリッドの列定義
  const budgetColumnDefs: ColDef[] = [
    {
      headerName: '助成金',
      field: 'grant_name',
      width: 120,
      cellStyle: { fontSize: '12px' }
    },
    {
      headerName: '予算項目',
      field: 'name',
      width: 140,
      cellStyle: { fontSize: '12px' }
    },
    {
      headerName: '予算額',
      field: 'budgeted_amount',
      width: 100,
      valueFormatter: (params) => `¥${params.value?.toLocaleString() || 0}`,
      cellStyle: { fontSize: '12px', textAlign: 'right' }
    }
  ];

  // 予算項目選択ハンドラー
  const handleBudgetItemSelection = () => {
    const selectedNodes = budgetGridRef.current?.api?.getSelectedNodes();
    if (selectedNodes && selectedNodes.length > 0) {
      setSelectedBudgetItem(selectedNodes[0].data);
    } else {
      setSelectedBudgetItem(null);
    }
  };

  // 一括割当解除
  const handleBatchUnallocation = async () => {
    if (selectedRows.length === 0) {
      setError('解除する取引を選択してください');
      return;
    }

    const confirmResult = window.confirm(`${selectedRows.length}件の取引の割当を解除しますか？`);
    if (!confirmResult) return;

    setLoading(true);
    setError(null);
    setSuccessMessage(null);

    try {
      // 既存の割当データを取得
      const existingAllocations = await api.getAllocations();
      
      const results = [];
      
      // 各取引の割当を解除
      for (const transaction of selectedRows) {
        try {
          const existingAllocation = existingAllocations.find(
            (allocation: any) => allocation.transaction_id === transaction.id
          );

          if (existingAllocation) {
            // 既存の割当を削除
            await api.deleteAllocation(existingAllocation.id);
            results.push({ status: 'fulfilled', value: existingAllocation });
          } else {
            // 割当が存在しない場合はスキップ
            console.log(`No allocation found for transaction ${transaction.id}`);
            results.push({ status: 'fulfilled', value: null });
          }
        } catch (error) {
          console.error(`Error removing allocation for transaction ${transaction.id}:`, error);
          results.push({ status: 'rejected', reason: error });
        }
      }
      
      // 成功・失敗の集計
      const successful = results.filter(result => result.status === 'fulfilled').length;
      const failed = results.filter(result => result.status === 'rejected').length;
      
      if (failed === 0) {
        // 全て成功
        setError(null);
        setSuccessMessage(`${successful}件の取引の割当を解除しました`);
        
        // 成功メッセージを3秒後に自動消去
        setTimeout(() => setSuccessMessage(null), 3000);
        
        // 表示を更新
        if (onAllocationComplete) {
          onAllocationComplete();
        }
      } else if (successful > 0) {
        // 部分的に成功
        setError(`${successful}件解除成功、${failed}件解除失敗しました`);
        // 部分的成功の場合のみalert表示
        alert(`部分的に完了: ${successful}件解除成功、${failed}件解除失敗`);
        
        // 部分的成功でも表示を更新
        if (onAllocationComplete) {
          onAllocationComplete();
        }
      } else {
        // 全て失敗
        throw new Error('全ての割当解除が失敗しました');
      }
      
    } catch (err) {
      setError('一括割当解除に失敗しました');
      console.error('Error in batch unallocation:', err);
    } finally {
      setLoading(false);
    }
  };

  // 一括割当実行
  const handleBatchAllocation = async () => {
    if (!selectedBudgetItem || selectedRows.length === 0) {
      setError('予算項目を選択し、取引を選択してください');
      return;
    }

    setLoading(true);
    setError(null);
    setSuccessMessage(null);

    try {
      // 既存の割当データを一度だけ取得
      const existingAllocations = await api.getAllocations();
      
      const results = [];
      
      // 各取引を順次処理（並列処理を避けてエラーを減らす）
      for (const transaction of selectedRows) {
        try {
          const allocationData = {
            transaction_id: transaction.id,
            budget_item_id: selectedBudgetItem.id,
            amount: transaction.amount
          };

          const existingAllocation = existingAllocations.find(
            (allocation: any) => allocation.transaction_id === transaction.id
          );

          let result;
          if (existingAllocation) {
            // 既存の割当がある場合は更新
            result = await api.updateAllocation(existingAllocation.id, allocationData);
          } else {
            // 新規作成
            result = await api.createAllocation(allocationData);
          }
          
          results.push({ status: 'fulfilled', value: result });
        } catch (error) {
          console.error(`Error processing allocation for transaction ${transaction.id}:`, error);
          results.push({ status: 'rejected', reason: error });
        }
      }
      
      // 成功・失敗の集計
      const successful = results.filter(result => result.status === 'fulfilled').length;
      const failed = results.filter(result => result.status === 'rejected').length;
      
      if (failed === 0) {
        // 全て成功
        setError(null);
        setSuccessMessage(`${successful}件の取引を「${selectedBudgetItem.display_name}」に割り当てました`);
        
        // 成功メッセージを3秒後に自動消去
        setTimeout(() => setSuccessMessage(null), 3000);
        
        setSelectedBudgetItem(null);
        
        // 表示を更新
        if (onAllocationComplete) {
          onAllocationComplete();
        }
      } else if (successful > 0) {
        // 部分的に成功
        setError(`${successful}件成功、${failed}件失敗しました`);
        // 部分的成功の場合のみalert表示
        alert(`部分的に完了: ${successful}件成功、${failed}件失敗`);
        
        // 部分的成功でも表示を更新
        if (onAllocationComplete) {
          onAllocationComplete();
        }
      } else {
        // 全て失敗
        throw new Error('全ての割当が失敗しました');
      }
      
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
    <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-4 h-full flex flex-col">
      <h2 className="text-lg font-semibold mb-4">一括割当</h2>
      
      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-3 py-2 rounded mb-4">
          {error}
        </div>
      )}
      
      {successMessage && (
        <div className="bg-green-50 border border-green-200 text-green-700 px-3 py-2 rounded mb-4">
          {successMessage}
        </div>
      )}
      
      <div className="flex flex-col h-full space-y-4">
        {/* 選択された取引の情報 */}
        <div className="bg-gray-50 p-3 rounded flex-shrink-0">
          <h3 className="font-medium text-gray-700 mb-2">選択された取引</h3>
          <div className="text-sm text-gray-600">
            <div>件数: {selectedRows.length}件</div>
            <div>合計金額: ¥{totalAmount.toLocaleString()}</div>
          </div>
        </div>

        {/* 予算項目グリッド */}
        <div className="flex-1 min-h-0">
          <h3 className="font-medium text-gray-700 mb-2">予算項目を選択</h3>
          <div style={{ height: '300px', width: '100%' }}>
            <AgGridReact
              ref={budgetGridRef}
              rowData={budgetItems}
              columnDefs={budgetColumnDefs}
              theme={themeAlpine}
              rowSelection="single"
              onSelectionChanged={handleBudgetItemSelection}
              defaultColDef={{
                sortable: true,
                filter: true,
                resizable: true,
                minWidth: 100
              }}
              rowHeight={28}
              headerHeight={32}
              suppressMenuHide={true}
              suppressMovableColumns={true}
              enableCellTextSelection={true}
            />
          </div>
        </div>

        {/* 選択された予算項目の情報 */}
        {selectedBudgetItem && (
          <div className="bg-blue-50 p-3 rounded flex-shrink-0">
            <h4 className="font-medium text-blue-700 mb-1">選択された予算項目</h4>
            <div className="text-sm text-blue-600">
              <div>{selectedBudgetItem.display_name}</div>
              <div>予算額: ¥{selectedBudgetItem.budgeted_amount.toLocaleString()}</div>
            </div>
          </div>
        )}

        {/* 実行ボタン */}
        <div className="flex-shrink-0 space-y-2">
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
          
          <button
            onClick={handleBatchUnallocation}
            disabled={loading || selectedRows.length === 0}
            className={`w-full py-2 px-4 rounded-md font-medium ${
              loading || selectedRows.length === 0
                ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                : 'bg-red-600 text-white hover:bg-red-700'
            }`}
          >
            {loading ? '実行中...' : `${selectedRows.length}件の割当を解除`}
          </button>
        </div>
      </div>
    </div>
  );
};

export default BatchAllocationPanel;