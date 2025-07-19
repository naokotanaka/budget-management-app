'use client';

import React, { useState, useEffect } from 'react';
import { AgGridReact } from 'ag-grid-react';
import { ColDef, GridApi, GridReadyEvent, ModuleRegistry, AllCommunityModule } from 'ag-grid-community';
import { Allocation, api } from '@/lib/api';
import { Trash2, AlertCircle } from 'lucide-react';
import dayjs from 'dayjs';

// Register AG Grid modules
ModuleRegistry.registerModules([AllCommunityModule]);

// 拡張された割当データの型定義
interface EnrichedAllocation extends Allocation {
  transaction_date: string;
  transaction_description: string;
  transaction_supplier: string;
  transaction_amount: number;
  budget_item_name: string;
  budget_item_category: string;
  grant_name: string;
  grant_status: string;
}

const AllocationsPage: React.FC = () => {
  const [allocations, setAllocations] = useState<EnrichedAllocation[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedRows, setSelectedRows] = useState<EnrichedAllocation[]>([]);
  const [gridApi, setGridApi] = useState<GridApi | null>(null);

  useEffect(() => {
    fetchAllocations();
  }, []);

  const fetchAllocations = async () => {
    try {
      setLoading(true);
      setError(null);
      
      console.log('Fetching allocations with details...');
      
      // 並列で必要なデータを取得
      const [allocationsData, transactionsData, budgetItemsData, grantsData] = await Promise.all([
        api.getAllocations(),
        api.getTransactions(),
        api.getBudgetItems(),
        api.getGrants()
      ]);
      
      console.log('Fetched allocations:', allocationsData.length);
      console.log('Fetched transactions:', transactionsData.length);
      console.log('Fetched budget items:', budgetItemsData.length);
      console.log('Fetched grants:', grantsData.length);
      
      // 割当データに詳細情報を追加
      const enrichedAllocations: EnrichedAllocation[] = allocationsData.map(allocation => {
        const transaction = transactionsData.find(t => t.id === allocation.transaction_id);
        const budgetItem = budgetItemsData.find(bi => bi.id === allocation.budget_item_id);
        const grant = budgetItem ? grantsData.find(g => g.id === budgetItem.grant_id) : null;
        
        return {
          ...allocation,
          transaction_date: transaction?.date || '',
          transaction_description: transaction?.description || '',
          transaction_supplier: transaction?.supplier || '',
          transaction_amount: transaction?.amount || 0,
          budget_item_name: budgetItem?.name || '',
          budget_item_category: budgetItem?.category || '',
          grant_name: grant?.name || '',
          grant_status: grant?.status || 'unknown'
        } as EnrichedAllocation;
      });
      
      console.log('Enriched allocations:', enrichedAllocations);
      console.log('Setting allocations state...');
      setAllocations(enrichedAllocations);
      console.log('Allocations state set successfully');
    } catch (err) {
      console.error('Error fetching allocations:', err);
      setError(err instanceof Error ? err.message : 'データの取得に失敗しました');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (allocation: EnrichedAllocation) => {
    if (!allocation.id) return;
    
    if (confirm(`ID: ${allocation.id} の割当データを削除しますか？`)) {
      try {
        await api.deleteAllocation(allocation.id);
        await fetchAllocations(); // データを再取得
      } catch (err) {
        console.error('Error deleting allocation:', err);
        alert('削除に失敗しました');
      }
    }
  };

  const handleDeleteSelected = async () => {
    if (selectedRows.length === 0) return;
    
    if (confirm(`選択された ${selectedRows.length} 件の割当データを削除しますか？`)) {
      try {
        for (const allocation of selectedRows) {
          if (allocation.id) {
            await api.deleteAllocation(allocation.id);
          }
        }
        await fetchAllocations(); // データを再取得
      } catch (err) {
        console.error('Error deleting allocations:', err);
        alert('削除に失敗しました');
      }
    }
  };

  const columns: ColDef[] = [
    {
      headerName: 'ID',
      field: 'id',
      width: 70,
      sortable: true,
      filter: true,
    },
    {
      headerName: '取引ID',
      field: 'transaction_id',
      width: 120,
      sortable: true,
      filter: true,
    },
    {
      headerName: '取引日',
      field: 'transaction_date',
      width: 100,
      sortable: true,
      filter: true,
      cellRenderer: (params: any) => {
        return params.value ? dayjs(params.value).format('MM/DD') : '';
      },
    },
    {
      headerName: '取引内容',
      field: 'transaction_description',
      width: 200,
      sortable: true,
      filter: true,
    },
    {
      headerName: '取引先',
      field: 'transaction_supplier',
      width: 150,
      sortable: true,
      filter: true,
    },
    {
      headerName: '取引金額',
      field: 'transaction_amount',
      width: 100,
      sortable: true,
      filter: true,
      cellRenderer: (params: any) => {
        return params.value?.toLocaleString() || '0';
      },
      cellStyle: { textAlign: 'right' },
    },
    {
      headerName: '割当金額',
      field: 'amount',
      width: 100,
      sortable: true,
      filter: true,
      cellRenderer: (params: any) => {
        return params.value?.toLocaleString() || '0';
      },
      cellStyle: { textAlign: 'right', fontWeight: 'bold' },
    },
    {
      headerName: '助成金',
      field: 'grant_name',
      width: 150,
      sortable: true,
      filter: true,
    },
    {
      headerName: '予算項目',
      field: 'budget_item_name',
      width: 150,
      sortable: true,
      filter: true,
    },
    {
      headerName: 'カテゴリ',
      field: 'budget_item_category',
      width: 120,
      sortable: true,
      filter: true,
    },
    {
      headerName: 'ステータス',
      field: 'grant_status',
      width: 100,
      sortable: true,
      filter: true,
      cellRenderer: (params: any) => {
        const status = params.value;
        let statusText = '';
        let statusClass = '';
        
        switch (status) {
          case 'active':
            statusText = '実行中';
            statusClass = 'text-green-600 bg-green-100';
            break;
          case 'completed':
            statusText = '終了';
            statusClass = 'text-blue-600 bg-blue-100';
            break;
          case 'applied':
            statusText = '報告済み';
            statusClass = 'text-gray-600 bg-gray-100';
            break;
          default:
            statusText = '不明';
            statusClass = 'text-gray-400 bg-gray-50';
        }
        
        return (
          <span className={`px-2 py-1 rounded text-xs ${statusClass}`}>
            {statusText}
          </span>
        );
      },
    },
    {
      headerName: '作成日時',
      field: 'created_at',
      width: 130,
      sortable: true,
      filter: true,
      cellRenderer: (params: any) => {
        return params.value ? dayjs(params.value).format('MM/DD HH:mm') : '';
      },
    },
    {
      headerName: '操作',
      field: 'actions',
      width: 80,
      cellRenderer: (params: any) => {
        return (
          <button
            onClick={() => handleDelete(params.data)}
            className="text-red-600 hover:text-red-800 p-1"
            title="削除"
          >
            <Trash2 size={16} />
          </button>
        );
      },
    },
  ];

  const onGridReady = (params: GridReadyEvent) => {
    setGridApi(params.api);
  };

  const onSelectionChanged = () => {
    if (gridApi) {
      const selectedNodes = gridApi.getSelectedNodes();
      const selectedData = selectedNodes.map(node => node.data);
      setSelectedRows(selectedData);
    }
  };

  if (loading) {
    console.log('Rendering loading state');
    return (
      <div className="w-full flex flex-col">
        <div className="border-b border-gray-200 pb-1 mb-1 px-2 pt-1 flex-shrink-0" style={{ height: '40px' }}>
          <h1 className="text-sm font-bold text-gray-900">割当データ一覧</h1>
        </div>
        <div className="flex-1 flex items-center justify-center">
          <div className="text-gray-500">データを読み込み中...</div>
        </div>
      </div>
    );
  }

  if (error) {
    console.log('Rendering error state:', error);
    return (
      <div className="w-full flex flex-col">
        <div className="border-b border-gray-200 pb-1 mb-1 px-2 pt-1 flex-shrink-0" style={{ height: '40px' }}>
          <h1 className="text-sm font-bold text-gray-900">割当データ一覧</h1>
        </div>
        <div className="flex-1 flex items-center justify-center">
          <div className="text-red-500 flex items-center gap-2">
            <AlertCircle size={20} />
            {error}
          </div>
        </div>
      </div>
    );
  }

  console.log('Rendering main state - allocations count:', allocations.length);
  console.log('Allocations data:', allocations.slice(0, 3));
  console.log('Columns:', columns.length);
  console.log('Grid API:', gridApi);
  console.log('Loading:', loading);
  console.log('Error:', error);

  return (
    <div className="w-full flex flex-col">
      <div className="border-b border-gray-200 pb-1 mb-1 px-2 pt-1 flex-shrink-0" style={{ height: '40px' }}>
        <div className="flex items-center justify-between">
          <h1 className="text-sm font-bold text-gray-900">割当データ一覧</h1>
          <div className="flex items-center gap-2">
            <span className="text-sm text-gray-600">
              {allocations.length} 件
            </span>
            {allocations.length > 0 && (
              <span className="text-xs text-blue-600">
                (最初の取引ID: {allocations[0]?.transaction_id})
              </span>
            )}
            {selectedRows.length > 0 && (
              <button
                onClick={handleDeleteSelected}
                className="bg-red-600 text-white px-3 py-1 rounded text-sm hover:bg-red-700 flex items-center gap-1"
              >
                <Trash2 size={14} />
                選択削除 ({selectedRows.length})
              </button>
            )}
            <button
              onClick={fetchAllocations}
              className="bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700"
            >
              更新
            </button>
          </div>
        </div>
      </div>
      
      <div className="flex-1 min-h-0" style={{ height: 'calc(100vh - 120px)' }}>
        <div className="h-full w-full" style={{ minHeight: '500px' }}>
          <div className="ag-theme-alpine" style={{ height: 'calc(100vh - 160px)', width: '100%' }}>
          <AgGridReact
            rowData={allocations}
            columnDefs={columns}
            className="ag-theme-alpine"
            onGridReady={onGridReady}
            defaultColDef={{
              sortable: true,
              filter: true,
              resizable: true,
              floatingFilter: true,
              minWidth: 80
            }}
            rowHeight={28}
            suppressHorizontalScroll={false}
            getRowStyle={(params) => {
              return (params.node.rowIndex ?? 0) % 2 === 0
                ? { backgroundColor: '#f3f4f6' }
                : { backgroundColor: '#ffffff' };
            }}
            pagination={true}
            paginationPageSize={100}
            suppressCellFocus={false}
            localeText={{
              // フィルター関連
              filterOoo: 'フィルター...',
              equals: '等しい',
              notEqual: '等しくない',
              lessThan: '未満',
              greaterThan: 'より大きい',
              lessThanOrEqual: '以下',
              greaterThanOrEqual: '以上',
              inRange: '範囲内',
              contains: '含む',
              notContains: '含まない',
              startsWith: 'で始まる',
              endsWith: 'で終わる',
              andCondition: 'AND',
              orCondition: 'OR',
              // ページネーション
              page: 'ページ',
              of: '/',
              to: '～',
              more: 'さらに表示',
              // その他
              loading: '読み込み中...',
              noRowsToShow: '表示するデータがありません',
              // 日付フィルター
              dateFormatOoo: 'yyyy-mm-dd'
            }}
          />
          </div>
        </div>
      </div>
    </div>
  );
};

export default AllocationsPage;