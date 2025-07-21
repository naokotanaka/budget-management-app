'use client';

import React, { useState, useEffect, useRef } from 'react';
import { AgGridReact } from 'ag-grid-react';
import { ColDef } from 'ag-grid-community';
import { api, Transaction, BudgetItem, Grant, Allocation } from '@/lib/api';
import '@/lib/ag-grid-setup';

interface BatchAllocationPanelProps {
  selectedRows: Transaction[];
  onAllocationComplete?: () => void;
  onBudgetItemSelected?: (grant: { start_date: string; end_date: string } | null) => void;
}

const BatchAllocationPanel: React.FC<BatchAllocationPanelProps> = ({ selectedRows, onAllocationComplete, onBudgetItemSelected }) => {
  const [budgetItems, setBudgetItems] = useState<BudgetItem[]>([]);
  const [grants, setGrants] = useState<Grant[]>([]);
  const [allocations, setAllocations] = useState<Allocation[]>([]);
  const [selectedBudgetItem, setSelectedBudgetItem] = useState<BudgetItem | null>(null);
  const [selectedBudgetItemId, setSelectedBudgetItemId] = useState<number | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  const budgetGridRef = useRef<AgGridReact>(null);


  // 予算項目データを取得
  useEffect(() => {
    const fetchData = async () => {
      try {
        const [budgetItemsResponse, grantsResponse, allocationsResponse] = await Promise.all([
          api.getBudgetItems(),
          api.getGrants(),
          api.getAllocations()
        ]);
        setBudgetItems(budgetItemsResponse);
        setGrants(grantsResponse);
        setAllocations(allocationsResponse);
      } catch (err) {
        setError('データの取得に失敗しました');
        console.error('Error fetching data:', err);
      }
    };

    fetchData();
  }, []);

  // 予算項目データが更新された際に選択状態を復元
  useEffect(() => {
    if (selectedBudgetItemId && budgetItems.length > 0 && budgetGridRef.current?.api) {
      // 少し遅延させてグリッドの準備を待つ
      setTimeout(() => {
        if (budgetGridRef.current?.api) {
          budgetGridRef.current.api.forEachNode((node) => {
            if (node.data.id === selectedBudgetItemId) {
              node.setSelected(true);
              // 選択された行を画面の中央に表示
              budgetGridRef.current?.api?.ensureIndexVisible(node.rowIndex || 0, 'middle');
              return;
            }
          });
        }
      }, 100);
    }
  }, [budgetItems, selectedBudgetItemId]);

  // 残額を計算する関数
  const getRemainingAmount = (budgetItem: BudgetItem) => {
    const allocatedAmount = allocations
      .filter(allocation => allocation.budget_item_id === budgetItem.id)
      .reduce((total, allocation) => total + (allocation.amount || 0), 0);
    return budgetItem.budgeted_amount - allocatedAmount;
  };

  // 予算項目グリッドの列定義
  const budgetColumnDefs: ColDef[] = [
    {
      headerName: '助成金',
      field: 'grant_name',
      width: 120,
      cellStyle: { fontSize: '12px' },
      cellRenderer: (params: any) => {
        const grant = grants.find(g => g.id === params.data.grant_id);
        return grant?.name || '不明';
      }
    },
    {
      headerName: '予算項目',
      field: 'name',
      width: 120,
      cellStyle: { fontSize: '12px' }
    },
    {
      headerName: '残額',
      field: 'remaining_amount',
      width: 100,
      valueGetter: (params: any) => getRemainingAmount(params.data),
      valueFormatter: (params: any) => `¥${params.value?.toLocaleString() || 0}`,
      cellStyle: (params: any) => {
        const remaining = params.value || 0;
        return {
          fontSize: '12px',
          textAlign: 'right',
          backgroundColor: remaining < 0 ? '#fef2f2' : '#f0fdf4',
          color: remaining < 0 ? '#dc2626' : '#16a34a',
          fontWeight: 'bold'
        };
      }
    },
    {
      headerName: '予算額',
      field: 'budgeted_amount',
      width: 100,
      valueFormatter: (params: any) => `¥${params.value?.toLocaleString() || 0}`,
      cellStyle: { fontSize: '12px', textAlign: 'right' }
    },
    {
      headerName: 'ステータス',
      field: 'grant_status',
      width: 80,
      cellStyle: { fontSize: '12px' },
      cellRenderer: (params: any) => {
        const grant = grants.find(g => g.id === params.data.grant_id);
        const status = grant?.status || 'active';
        const statusText = status === 'active' ? '実行中' : status === 'completed' ? '終了' : '報告済み';
        return statusText;
      }
    }
  ];

  // 予算項目選択ハンドラー
  const handleBudgetItemSelection = () => {
    const selectedNodes = budgetGridRef.current?.api?.getSelectedNodes();
    if (selectedNodes && selectedNodes.length > 0) {
      const budgetItem = selectedNodes[0].data;
      const selectedNode = selectedNodes[0];
      
      setSelectedBudgetItem(budgetItem);
      setSelectedBudgetItemId(budgetItem.id);

      // 選択された行を表示領域に保持（より確実に）
      if (budgetGridRef.current?.api && selectedNode.rowIndex !== undefined) {
        // 複数回試行して確実にスクロール位置を保持
        const ensureVisible = () => {
          if (budgetGridRef.current?.api && selectedNode.rowIndex !== undefined) {
            budgetGridRef.current.api.ensureIndexVisible(selectedNode.rowIndex, 'middle');
          }
        };
        
        // 即座に実行
        ensureVisible();
        
        // 少し遅延して再実行（他の処理で上書きされることを防ぐ）
        setTimeout(ensureVisible, 50);
        setTimeout(ensureVisible, 150);
        setTimeout(ensureVisible, 300);
      }

      // 選択された予算項目に紐づく助成金の期間を取得
      const grant = grants.find(g => g.id === budgetItem.grant_id);
      if (grant && onBudgetItemSelected) {
        const dateFilter = {
          start_date: grant.start_date,
          end_date: grant.end_date
        };
        onBudgetItemSelected(dateFilter);
      }
    }
    // 選択解除時はフィルターをクリアしない（予算項目の選択状態を保持）
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
          <div className="flex justify-between items-center mb-2">
            <h3 className="font-medium text-gray-700">予算項目を選択</h3>
            {selectedBudgetItem && (
              <button
                onClick={() => {
                  setSelectedBudgetItem(null);
                  setSelectedBudgetItemId(null);
                  if (budgetGridRef.current?.api) {
                    budgetGridRef.current.api.deselectAll();
                  }
                  if (onBudgetItemSelected) {
                    onBudgetItemSelected(null);
                  }
                }}
                className="text-sm px-3 py-1 bg-gray-600 text-white rounded hover:bg-gray-700"
              >
                選択解除
              </button>
            )}
          </div>
          <div style={{ height: '400px', width: '100%' }}>
            <AgGridReact
              ref={budgetGridRef}
              rowData={budgetItems.filter(item => {
                const grant = grants.find(g => g.id === item.grant_id);
                return grant?.status !== 'applied';
              })}
              columnDefs={budgetColumnDefs}
              className="ag-theme-alpine"
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
        {selectedBudgetItem && (() => {
          // 選択された予算項目の残額を計算
          const budgetItemAllocations = allocations.filter(a => a.budget_item_id === selectedBudgetItem.id);
          const allocatedAmount = budgetItemAllocations.reduce((sum, a) => sum + a.amount, 0);
          const budgetItemRemaining = selectedBudgetItem.budgeted_amount - allocatedAmount;
          
          // 選択された予算項目が属する助成金の情報を取得
          const grant = grants.find(g => g.id === selectedBudgetItem.grant_id);
          let grantRemaining = 0;
          
          if (grant) {
            // 助成金全体の予算項目を取得
            const grantBudgetItems = budgetItems.filter(item => item.grant_id === grant.id);
            const totalGrantBudget = grantBudgetItems.reduce((sum, item) => sum + item.budgeted_amount, 0);
            
            // 助成金全体の割当済み金額を計算
            const grantAllocations = allocations.filter(a => 
              grantBudgetItems.some(item => item.id === a.budget_item_id)
            );
            const totalGrantAllocated = grantAllocations.reduce((sum, a) => sum + a.amount, 0);
            grantRemaining = totalGrantBudget - totalGrantAllocated;
          }
          
          return (
            <div className="bg-blue-50 p-3 rounded flex-shrink-0">
              <h4 className="font-medium text-blue-700 mb-2">選択された予算項目</h4>
              <div className="text-sm text-blue-600 space-y-1">
                <div className="font-medium">{selectedBudgetItem.display_name}</div>
                <div>予算額: ¥{selectedBudgetItem.budgeted_amount.toLocaleString()}</div>
                <div>割当済み: ¥{allocatedAmount.toLocaleString()}</div>
                <div className={`font-medium ${budgetItemRemaining > 0 ? 'text-red-600' : 'text-gray-700'}`}>
                  項目残額: ¥{budgetItemRemaining.toLocaleString()}
                </div>
                {grant && (
                  <div className={`font-medium ${grantRemaining > 0 ? 'text-red-600' : 'text-gray-700'}`}>
                    助成金残額: ¥{grantRemaining.toLocaleString()} ({grant.name})
                  </div>
                )}
              </div>
            </div>
          );
        })()}

        {/* 実行ボタン */}
        <div className="flex-shrink-0 space-y-2">
          <button
            onClick={handleBatchAllocation}
            disabled={loading || !selectedBudgetItem || selectedRows.length === 0}
            className={`w-full py-2 px-4 rounded-md font-medium ${loading || !selectedBudgetItem || selectedRows.length === 0
              ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
              : 'bg-blue-600 text-white hover:bg-blue-700'
              }`}
          >
            {loading ? '実行中...' : `${selectedRows.length}件を一括割当`}
          </button>

          <button
            onClick={handleBatchUnallocation}
            disabled={loading || selectedRows.length === 0}
            className={`w-full py-2 px-4 rounded-md font-medium ${loading || selectedRows.length === 0
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