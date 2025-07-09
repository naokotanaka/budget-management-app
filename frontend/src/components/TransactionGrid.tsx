'use client';

import React, { useState, useEffect, useRef, useMemo } from 'react';
import { AgGridReact } from 'ag-grid-react';
import { ColDef, GridApi, ModuleRegistry, AllCommunityModule, themeAlpine } from 'ag-grid-community';
import dayjs from 'dayjs';
import { api, Transaction, BudgetItem, Grant } from '@/lib/api';
import { CONFIG } from '@/lib/config';

interface TransactionGridProps {
  onSelectionChanged?: (selectedRows: Transaction[]) => void;
  enableBatchAllocation?: boolean;
}

const TransactionGrid = React.forwardRef<any, TransactionGridProps>(({ onSelectionChanged: onSelectionChangedProp, enableBatchAllocation = false }, ref) => {
  const [rowData, setRowData] = useState<Transaction[]>([]);
  const [budgetItems, setBudgetItems] = useState<BudgetItem[]>([]);
  const [grants, setGrants] = useState<Grant[]>([]);
  const [savedFilters, setSavedFilters] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedRows, setSelectedRows] = useState<Transaction[]>([]);
  const [allocations, setAllocations] = useState<{[key: string]: any}>({});
  const [apiAllocations, setApiAllocations] = useState<any[]>([]);

  const gridRef = useRef<AgGridReact>(null);
  
  // 親コンポーネントからのrefを設定
  React.useImperativeHandle(ref, () => ({
    api: gridRef.current?.api,
    reloadData: loadData
  }));

  // Register AG Grid modules and load data on mount
  useEffect(() => {
    // Register AG Grid modules
    ModuleRegistry.registerModules([AllCommunityModule]);
    
    // localStorageを使用しないデータ管理に変更
    
    loadData();
    loadSavedFilters();
  }, []);

  // デバッグ用：状態変更を監視
  useEffect(() => {
    console.log('budgetItems state changed:', budgetItems);
  }, [budgetItems]);

  useEffect(() => {
    console.log('grants state changed:', grants);
  }, [grants]);

  // グリッドが準備完了時にデフォルトフィルターを適用
  const onGridReady = (params: any) => {
    const filterModel: any = {
      'grant_status': {
        filterType: 'text',
        type: 'notEqual',
        filter: '報告済み'
      }
    };

    // sessionStorageから期間フィルター設定を読み込み
    const savedDateFilter = sessionStorage.getItem('transactionDateFilter');
    if (savedDateFilter) {
      try {
        const filterSettings = JSON.parse(savedDateFilter);
        if (filterSettings.startDate && filterSettings.endDate) {
          filterModel['date'] = {
            filterType: 'date',
            type: 'inRange',
            dateFrom: filterSettings.startDate,
            dateTo: filterSettings.endDate
          };
        }
      } catch (error) {
        console.error('Failed to parse date filter settings:', error);
      }
    }

    params.api.setFilterModel(filterModel);
  };

  const loadData = async () => {
    try {
      setLoading(true);
      console.log('=== Loading data START ===');
      const [transactions, budgetItemsData, grantsData, allocationsData] = await Promise.all([
        api.getTransactions(),
        api.getBudgetItems(),
        api.getGrants(),
        api.getAllocations()
      ]);
      console.log('=== RAW API Data ===');
      console.log('Raw budgetItemsData:', budgetItemsData);
      console.log('Raw grantsData:', grantsData);

      console.log('Loaded transactions:', transactions.length);
      console.log('Loaded budget items:', budgetItemsData.length);
      console.log('Budget items data:', budgetItemsData);
      if (budgetItemsData && budgetItemsData.length > 0) {
        console.log('First budget item:', budgetItemsData[0]);
        console.log('Budget item keys:', Object.keys(budgetItemsData[0]));
      }
      console.log('Loaded grants:', grantsData.length);
      console.log('Grants data:', grantsData);
      if (grantsData && grantsData.length > 0) {
        console.log('First grant:', grantsData[0]);
        console.log('Grant keys:', Object.keys(grantsData[0]));
      }

      // APIから取得した割当データをトランザクションに反映
      console.log('Allocations from API:', allocationsData);
      setApiAllocations(allocationsData);
      
      // 割当データをトランザクションIDでグループ化
      const allocationsByTransactionId = {};
      allocationsData.forEach(allocation => {
        if (!allocationsByTransactionId[allocation.transaction_id]) {
          allocationsByTransactionId[allocation.transaction_id] = [];
        }
        allocationsByTransactionId[allocation.transaction_id].push(allocation);
      });
      
      // トランザクションに割当情報を追加
      transactions.forEach(transaction => {
        const transactionAllocations = allocationsByTransactionId[transaction.id] || [];
        if (transactionAllocations.length > 0) {
          // 複数の割当がある場合は最初のものを使用（将来的には複数割当に対応）
          const firstAllocation = transactionAllocations[0];
          const budgetItem = budgetItemsData.find(item => item.id === firstAllocation.budget_item_id);
          if (budgetItem) {
            // 助成金-予算項目 の形式で表示
            const displayName = budgetItem.display_name || `${budgetItem.grant_name || '不明'}-${budgetItem.name}`;
            transaction.budget_item = displayName;
            transaction.allocated_amount_edit = firstAllocation.amount;
            transaction.allocated_budget_item = budgetItem;
            transaction.allocated_amount = firstAllocation.amount;
            console.log('Applied allocation from API:', {
              transaction_id: transaction.id,
              budget_item: displayName,
              amount: firstAllocation.amount
            });
          }
        }
      });

      // 助成金データはAPIからのみ使用
      const updatedGrants = grantsData.map(grant => ({
        ...grant,
        status: grant.status || 'active' // デフォルトステータスを設定
      }));
      
      console.log('Final grants data with status:', updatedGrants);

      console.log('Final transactions data being set:', transactions.slice(0, 3).map(t => ({
        id: t.id,
        budget_item: t.budget_item,
        allocated_amount_edit: t.allocated_amount_edit
      })));
      
      // 状態を設定
      console.log('Setting state with budgetItems:', budgetItemsData);
      console.log('Setting state with grants:', updatedGrants);
      
      // 状態を個別に設定して確実に更新されるようにする
      setBudgetItems(prev => {
        console.log('setBudgetItems called with:', budgetItemsData);
        return budgetItemsData;
      });
      
      setGrants(prev => {
        console.log('setGrants called with:', updatedGrants);
        return updatedGrants;
      });
      
      setRowData(prev => {
        console.log('setRowData called with transactions count:', transactions.length);
        return transactions;
      });
      
      console.log('State after setting:', {
        budgetItemsCount: budgetItemsData.length,
        grantsCount: updatedGrants.length,
        transactionsCount: transactions.length
      });
    } catch (error) {
      console.error('Failed to load data:', error);
      alert('データの読み込みに失敗しました: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const loadSavedFilters = () => {
    // フィルターはAPIから管理するか、セッションストレージを使用
    const saved = sessionStorage.getItem('savedFilters');
    if (saved) {
      setSavedFilters(JSON.parse(saved));
    }
  };

  // 報告済み助成金の予算項目を除外した選択肢を計算
  const availableBudgetItems = useMemo(() => {
    console.log('=== Calculating available budget items ===');
    console.log('loading:', loading);
    console.log('budgetItems length:', budgetItems.length);
    console.log('grants length:', grants.length);
    console.log('budgetItems data:', budgetItems);
    console.log('grants data:', grants);
    
    // ローディング中または、まだデータが取得されていない場合は基本的な選択肢のみ返す
    if (loading || !budgetItems || budgetItems.length === 0) {
      console.log('Still loading or no budget items, returning basic options');
      return ['未割当'];
    }
    
    const values = ['未割当'];
    budgetItems.forEach(item => {
      if (item && typeof item === 'object') {
        // 報告済みの助成金の予算項目を除外
        const grant = grants.find(g => g.id === item.grant_id);
        console.log(`Item: ${item.name}, Grant: ${grant?.name}, Grant Status: ${grant?.status}`);
        if (grant && grant.status === 'applied') {
          console.log('Excluding applied grant budget item:', item.name);
          return; // スキップ
        }
        
        // 助成金-予算項目 の形式で表示
        const displayName = item.display_name || `${item.grant_name || '不明'}-${item.name}`;
        if (displayName) {
          console.log('Adding budget item:', displayName);
          values.push(displayName);
        }
      }
    });
    console.log('Final available budget items:', values);
    return values;
  }, [budgetItems, grants, loading]);

  const columnDefs: ColDef[] = useMemo(() => [
    {
      headerName: '',
      field: 'select',
      checkboxSelection: true,
      headerCheckboxSelection: true,
      width: 50,
      minWidth: 50,
      maxWidth: 50,
      pinned: 'left',
      lockPosition: true,
      suppressMovable: true,
      filter: false,
      sortable: false
    },
    {
      field: 'budget_item',
      headerName: '予算項目選択',
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: {
        values: availableBudgetItems
      },
      editable: true,
      filter: 'agTextColumnFilter',
      filterParams: {
        filterOptions: ['contains', 'equals', 'notEqual', 'startsWith', 'endsWith'],
        defaultOption: 'contains',
        suppressAndOrCondition: false
      },
      valueGetter: (params) => {
        const allocation = allocations[params.data.id];
        return allocation?.budget_item || params.data.budget_item || '未割当';
      },
      valueSetter: (params) => {
        const newAllocations = { ...allocations };
        if (!newAllocations[params.data.id]) {
          newAllocations[params.data.id] = {};
        }
        // 既存の割当金額情報を保持
        const existingAllocation = allocations[params.data.id];
        if (existingAllocation) {
          newAllocations[params.data.id] = { ...existingAllocation };
        }
        newAllocations[params.data.id].budget_item = params.newValue;
        setAllocations(newAllocations);
        // 割当情報はAPI経由で管理
        return true;
      },
      cellRenderer: (params) => {
        const allocation = allocations[params.data.id];
        const value = allocation?.budget_item || params.data.budget_item || params.value;
        
        if (!value || value === '未割当') {
          return '';
        }
        
        // 文字列でない場合は文字列に変換
        if (typeof value !== 'string') {
          if (value && typeof value === 'object') {
            const displayName = value.display_name || `${value.grant_name || '不明'}-${value.name}` || '';
            return displayName;
          }
          return String(value);
        }
        
        return value;
      },
      width: 180,
      minWidth: 150,
      cellStyle: (params) => {
        const value = params.value;
        const isUnallocated = !value || value === '未割当';
        return {
          fontWeight: 'bold',
          color: isUnallocated ? '#9ca3af' : undefined,
          textAlign: 'right'
        };
      },
      pinned: 'left'
    },
    {
      field: 'allocated_amount_edit',
      headerName: '割当金額入力',
      editable: true,
      valueFormatter: (params) => params.value ? params.value.toLocaleString() : '',
      valueGetter: (params) => {
        const allocation = allocations[params.data.id];
        return allocation?.allocated_amount_edit || params.data.allocated_amount_edit;
      },
      valueSetter: (params) => {
        const newAllocations = { ...allocations };
        if (!newAllocations[params.data.id]) {
          newAllocations[params.data.id] = {};
        }
        // 既存の情報を全て保持
        const existingAllocation = allocations[params.data.id];
        if (existingAllocation) {
          newAllocations[params.data.id] = { ...existingAllocation };
        }
        
        // 現在の予算項目情報を保持
        const currentBudgetItem = existingAllocation?.budget_item || params.data.budget_item;
        if (currentBudgetItem && currentBudgetItem !== '未割当') {
          newAllocations[params.data.id].budget_item = currentBudgetItem;
          // params.dataにも設定して表示を維持
          params.data.budget_item = currentBudgetItem;
        }
        
        newAllocations[params.data.id].allocated_amount_edit = params.newValue;
        setAllocations(newAllocations);
        // 割当情報はAPI経由で管理
        
        console.log('Amount setter - preserving budget item:', currentBudgetItem);
        return true;
      },
      cellEditor: 'agNumberCellEditor',
      cellClass: 'text-right',
      width: 140,
      minWidth: 120,
      cellStyle: { fontWeight: 'bold' },
      pinned: 'left'
},
    {
      field: 'date',
      headerName: '取引日',
      valueFormatter: (params) => {
        const date = dayjs(params.value);
        const weekdays = ['日', '月', '火', '水', '木', '金', '土'];
        return `${date.format('MM/DD')} ${weekdays[date.day()]}`;
      },
      filter: 'agDateColumnFilter',
      width: 100,
      minWidth: 100,
      pinned: 'left'
    },
    {
      field: 'amount',
      headerName: '金額',
      valueFormatter: (params) => params.value?.toLocaleString() || '0',
      cellClass: 'text-right',
      filter: 'agNumberColumnFilter',
      width: 100,
      minWidth: 100,
      pinned: 'left'
    },
    {
      field: 'department',
      headerName: '部門',
      filter: 'agTextColumnFilter',
      filterParams: {
        filterOptions: ['contains', 'equals', 'notEqual', 'startsWith', 'endsWith'],
        defaultOption: 'contains',
        suppressAndOrCondition: false
      },
      width: 150,
      minWidth: 120
    },
    {
      field: 'account',
      headerName: '勘定科目',
      filter: 'agTextColumnFilter',
      filterParams: {
        filterOptions: ['contains', 'equals', 'notEqual', 'startsWith', 'endsWith'],
        defaultOption: 'contains',
        suppressAndOrCondition: false
      },
      width: 200,
      minWidth: 150
    },
    {
      field: 'description',
      headerName: '取引内容',
      filter: 'agTextColumnFilter',
      width: 300,
      minWidth: 200
    },
    {
      field: 'supplier',
      headerName: '取引先',
      filter: 'agTextColumnFilter',
      filterParams: {
        filterOptions: ['contains', 'equals', 'notEqual', 'startsWith', 'endsWith'],
        defaultOption: 'contains',
        suppressAndOrCondition: false
      },
      width: 150,
      minWidth: 120
    },
    {
      field: 'item',
      headerName: '品目',
      filter: 'agTextColumnFilter',
      filterParams: {
        filterOptions: ['contains', 'equals', 'notEqual', 'startsWith', 'endsWith'],
        defaultOption: 'contains',
        suppressAndOrCondition: false
      },
      width: 200,
      minWidth: 150
    },
    {
      field: 'remark',
      headerName: '備考',
      filter: 'agTextColumnFilter',
      width: 200,
      minWidth: 150,
      tooltipField: 'remark'
    },
    {
      field: 'memo',
      headerName: 'メモ',
      filter: 'agTextColumnFilter',
      width: 150,
      minWidth: 100
    },
    {
      field: 'management_number',
      headerName: '管理番号',
      filter: 'agTextColumnFilter',
      width: 100,
      minWidth: 80
    },
    {
      field: 'journal_number',
      headerName: '仕訳番号',
      filter: 'agNumberColumnFilter',
      width: 90,
      minWidth: 70
    },
    {
      field: 'journal_line_number',
      headerName: '行番号',
      filter: 'agNumberColumnFilter',
      width: 70,
      minWidth: 50
    },
    {
      field: 'grant_status',
      headerName: 'ステータス',
      valueGetter: (params) => {
        // budget_itemの文字列から予算項目を特定してステータスを取得
        const budgetItemDisplayName = params.data.budget_item;
        if (!budgetItemDisplayName || budgetItemDisplayName === '未割当') {
          return '';
        }
        
        // display_nameまたは構成されたdisplay_nameで検索
        const budgetItem = budgetItems.find(item => 
          (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === budgetItemDisplayName
        );
        
        if (budgetItem) {
          const grant = grants.find(g => g.id === budgetItem.grant_id);
          if (grant?.status) {
            switch (grant.status) {
              case 'active': return '実行中';
              case 'completed': return '終了';
              case 'applied': return '報告済み';
              default: return '不明';
            }
          }
        }
        
        return '';
      },
      filter: 'agTextColumnFilter',
      filterParams: {
        defaultOption: 'notEqual',
        defaultValue: '報告済み'
      },
      width: 80,
      minWidth: 70
    },
    {
      field: 'budget_category',
      headerName: 'カテゴリ',
      valueGetter: (params) => {
        // budget_itemの文字列から予算項目を特定してカテゴリを取得
        const budgetItemDisplayName = params.data.budget_item;
        if (!budgetItemDisplayName || budgetItemDisplayName === '未割当') {
          return '';
        }
        
        // display_nameまたは構成されたdisplay_nameで検索
        const budgetItem = budgetItems.find(item => 
          (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === budgetItemDisplayName
        );
        
        return budgetItem?.category || '';
      },
      filter: 'agTextColumnFilter',
      width: 100,
      minWidth: 80
    }
  ], [availableBudgetItems, allocations, budgetItems, grants]);

  // データ取得完了後にグリッドをリフレッシュ
  useEffect(() => {
    if (!loading && gridRef.current && gridRef.current.api && availableBudgetItems.length > 1) {
      console.log('Data loaded, refreshing grid with available budget items:', availableBudgetItems);
      // グリッド全体をリフレッシュして列定義を更新
      setTimeout(() => {
        if (gridRef.current && gridRef.current.api) {
          gridRef.current.api.refreshCells({ force: true });
        }
      }, 100);
    }
  }, [loading, availableBudgetItems]);

  const onCellValueChanged = async (params: any) => {
    if (params.colDef.field === 'budget_item' || params.colDef.field === 'allocated_amount_edit') {
      try {
        let budgetItemId = 0;
        let allocationAmount = 0;

        // Get budget item
        if (params.colDef.field === 'budget_item' && params.newValue) {
          const selectedItem = budgetItems.find(item => 
            (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === params.newValue
          );
          budgetItemId = selectedItem?.id || 0;
          params.data.budget_item = params.newValue;
          
          // 予算項目を選択したら、割当金額に元の金額をコピー
          const currentAllocation = allocations[params.data.id];
          if (budgetItemId > 0 && !currentAllocation?.allocated_amount_edit) {
            allocationAmount = params.data.amount;
            // 即座にparams.dataにも設定
            params.data.allocated_amount_edit = params.data.amount;
            
            // 状態を更新
            const newAllocations = { ...allocations };
            if (!newAllocations[params.data.id]) {
              newAllocations[params.data.id] = {};
            }
            newAllocations[params.data.id].allocated_amount_edit = params.data.amount;
            setAllocations(newAllocations);
            
            // ローカルストレージにも即座に保存
            // 割当情報はAPI経由で管理
            
            // 割当金額セルを即座にリフレッシュ
            setTimeout(() => {
              params.api.refreshCells({ 
                rowNodes: [params.node], 
                columns: ['allocated_amount_edit'], 
                force: true 
              });
            }, 10);
            
            console.log('予算項目選択時に金額をコピーしました:', params.data.amount);
          } else {
            allocationAmount = currentAllocation?.allocated_amount_edit || params.data.amount;
          }
        } else if (params.data.budget_item) {
          const selectedItem = budgetItems.find(item => 
            (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === params.data.budget_item
          );
          budgetItemId = selectedItem?.id || 0;
          allocationAmount = params.data.allocated_amount_edit || params.data.amount;
        }

        // Get allocation amount
        if (params.colDef.field === 'allocated_amount_edit') {
          allocationAmount = params.newValue || 0;
          params.data.allocated_amount_edit = params.newValue;
          
          // 既存の予算項目を維持（allocationsから取得するか、params.dataから取得）
          const currentAllocation = allocations[params.data.id];
          const currentBudgetItem = currentAllocation?.budget_item || params.data.budget_item;
          
          if (currentBudgetItem) {
            const selectedItem = budgetItems.find(item => 
              (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === currentBudgetItem
            );
            budgetItemId = selectedItem?.id || 0;
            // 予算項目をparameters.dataにも設定して表示を維持
            params.data.budget_item = currentBudgetItem;
          }
        }

        console.log('Debug - budgetItemId:', budgetItemId, 'allocationAmount:', allocationAmount);
        console.log('Debug - params.data.budget_item:', params.data.budget_item);
        
        // 予算項目と金額の両方が設定されている場合のみAPIリクエスト送信
        if (budgetItemId > 0 && allocationAmount > 0 && params.data.budget_item && params.data.budget_item !== '未割当') {
          const allocation = {
            transaction_id: params.data.id,
            budget_item_id: budgetItemId,
            amount: allocationAmount
          };

          console.log('Creating allocation:', allocation);
          const result = await api.createAllocation(allocation);
          console.log('Allocation result:', result);
          
          // Update display fields
          params.data.allocated_budget_item = params.data.budget_item;
          params.data.allocated_amount = allocationAmount;
          
          // ローカルストレージに保存
          // 割当情報はAPIから取得済み
          const savedAllocations = null;
          const localAllocations = savedAllocations ? JSON.parse(savedAllocations) : {};
          
          // 既存の割り当て情報があれば保持
          const existingAllocation = localAllocations[params.data.id] || {};
          localAllocations[params.data.id] = {
            ...existingAllocation,
            budget_item: params.data.budget_item,
            allocated_amount_edit: params.data.allocated_amount_edit,
            allocated_budget_item: params.data.allocated_budget_item,
            allocated_amount: allocationAmount
          };
          console.log('Saving to localStorage:', params.data.id, localAllocations[params.data.id]);
          // 割当情報はAPI経由で管理
          
          // React状態も更新
          setAllocations(prev => ({
            ...prev,
            [params.data.id]: localAllocations[params.data.id]
          }));
          
          // 特定のセルのみリフレッシュ
          params.api.refreshCells({ 
            rowNodes: [params.node], 
            columns: ['allocated_amount_edit'], 
            force: true 
          });
          
          console.log('予算項目が正常に割り当てられました');
        } else {
          // 予算項目が未設定でも、割当金額の変更はローカルに保存
          if (params.colDef.field === 'allocated_amount_edit') {
            const newAllocations = { ...allocations };
            if (!newAllocations[params.data.id]) {
              newAllocations[params.data.id] = {};
            }
            // 既存の予算項目情報を保持
            const existingAllocation = allocations[params.data.id];
            if (existingAllocation) {
              newAllocations[params.data.id] = { ...existingAllocation };
            }
            newAllocations[params.data.id].allocated_amount_edit = allocationAmount;
            setAllocations(newAllocations);
            // 割当情報はAPI経由で管理
            
            // 予算項目列も一緒にリフレッシュして表示を維持
            setTimeout(() => {
              params.api.refreshCells({ 
                rowNodes: [params.node], 
                columns: ['budget_item', 'allocated_amount_edit'], 
                force: true 
              });
            }, 10);
            
            console.log('割当金額のみ更新しました:', allocationAmount);
          }
        }
        
      } catch (error) {
        console.error('Failed to allocate budget item:', error);
        alert('予算項目の割り当てに失敗しました: ' + error.message);
        // Revert changes on error
        params.api.refreshCells({ rowNodes: [params.node], force: true });
      }
    }
  };

  const onGridSelectionChanged = () => {
    if (gridRef.current) {
      const selectedRows = gridRef.current.api.getSelectedRows();
      setSelectedRows(selectedRows);
      if (onSelectionChangedProp) {
        onSelectionChangedProp(selectedRows);
      }
    }
  };


  const saveFilter = () => {
    if (!gridRef.current) return;

    const name = prompt('フィルター名を入力してください');
    if (name) {
      const filterState = {
        name,
        filters: gridRef.current.api.getFilterModel()
      };
      const updated = [...savedFilters, filterState];
      setSavedFilters(updated);
      sessionStorage.setItem('savedFilters', JSON.stringify(updated));
    }
  };

  const loadFilter = (filterName: string) => {
    const filter = savedFilters.find(f => f.name === filterName);
    if (filter && gridRef.current) {
      gridRef.current.api.setFilterModel(filter.filters);
    }
  };

  const clearFilters = () => {
    if (gridRef.current) {
      gridRef.current.api.setFilterModel(null);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="text-lg">データを読み込み中...</div>
      </div>
    );
  }

  return (
    <div className="w-full flex flex-col">

      {/* フィルター操作 */}
      <div className="flex gap-2 items-center flex-wrap flex-shrink-0" style={{ marginBottom: '4px' }}>
        <select
          className="p-1 border rounded text-sm"
          onChange={(e) => {
            if (e.target.value) {
              loadFilter(e.target.value);
            }
          }}
        >
          <option value="">保存したフィルター</option>
          {savedFilters.map(f => (
            <option key={f.name} value={f.name}>{f.name}</option>
          ))}
        </select>
        <button
          className="px-2 py-1 bg-green-500 text-white rounded hover:bg-green-600 text-sm"
          onClick={saveFilter}
        >
          フィルター保存
        </button>
        <button
          className="px-2 py-1 bg-gray-500 text-white rounded hover:bg-gray-600 text-sm"
          onClick={clearFilters}
        >
          クリア
        </button>
        <button
          className="px-2 py-1 bg-blue-500 text-white rounded hover:bg-blue-600 text-sm"
          onClick={loadData}
        >
          再読込
        </button>
      </div>

      {/* グリッド */}
      <div style={{ height: 'calc(100vh - 200px)', width: '100%' }}>
        <AgGridReact
          ref={gridRef}
          rowData={rowData}
          columnDefs={columnDefs}
          theme={themeAlpine}
          defaultColDef={{
            sortable: true,
            filter: true,
            resizable: true,
            floatingFilter: true,
            minWidth: 80
          }}
          rowHeight={28}
          suppressHorizontalScroll={false}
          rowSelection="multiple"
          getRowStyle={(params) => {
            return params.node.rowIndex % 2 === 0 
              ? { backgroundColor: '#f3f4f6' } 
              : { backgroundColor: '#ffffff' };
          }}
          onSelectionChanged={onGridSelectionChanged}
          onCellValueChanged={onCellValueChanged}
          onGridReady={onGridReady}
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
  );
});

TransactionGrid.displayName = 'TransactionGrid';

export default TransactionGrid;