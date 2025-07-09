'use client';

import React, { useState, useEffect, useRef, useMemo } from 'react';
import { AgGridReact } from 'ag-grid-react';
import { ColDef, GridApi, ModuleRegistry, AllCommunityModule, themeAlpine } from 'ag-grid-community';
import dayjs from 'dayjs';
import { api, Transaction, BudgetItem, Grant } from '@/lib/api';

interface BatchAllocationGridProps {
  onSelectionChanged?: (selectedRows: Transaction[]) => void;
}

const BatchAllocationGrid: React.FC<BatchAllocationGridProps> = ({ onSelectionChanged: onSelectionChangedProp }) => {
  const [rowData, setRowData] = useState<Transaction[]>([]);
  const [budgetItems, setBudgetItems] = useState<BudgetItem[]>([]);
  const [grants, setGrants] = useState<Grant[]>([]);
  const [savedFilters, setSavedFilters] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedRows, setSelectedRows] = useState<Transaction[]>([]);
  const [allocations, setAllocations] = useState<{[key: string]: any}>({});
  const [selectedBudgetItem, setSelectedBudgetItem] = useState<BudgetItem | null>(null);
  const [apiAllocations, setApiAllocations] = useState<any[]>([]);

  const gridRef = useRef<AgGridReact>(null);
  const budgetGridRef = useRef<AgGridReact>(null);

  // Register AG Grid modules and load data on mount
  useEffect(() => {
    // Register AG Grid modules
    ModuleRegistry.registerModules([AllCommunityModule]);
    
    // データはAPIから取得するため、localStorageは使用しない
    
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

  useEffect(() => {
    console.log('=== Allocations state changed ===');
    console.log('Current allocations count:', Object.keys(allocations).length);
    console.log('Allocations:', allocations);
    if (Object.keys(allocations).length > 0) {
      console.log('First allocation example:', Object.entries(allocations)[0]);
    }
  }, [allocations]);

  // グリッドが準備完了時にデフォルトフィルターを適用
  const onGridReady = (params: any) => {
    // デフォルトで「報告済み」を除外するフィルターを設定
    params.api.setFilterModel({
      'grant_status': {
        filterType: 'text',
        type: 'notEqual',
        filter: '報告済み'
      }
    });
  };

  const loadData = async () => {
    try {
      setLoading(true);
      console.log('=== Loading data START ===');
      const [transactions, budgetItemsData, grantsData, apiAllocationsData] = await Promise.all([
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

      // API割当データをトランザクションに反映（localStorage使用せず）
      console.log('=== Applying API allocations to transactions ===');
      console.log('API allocations data:', apiAllocationsData);
      
      // 割当データをトランザクションIDでグループ化
      const allocationsByTransactionId = {};
      apiAllocationsData.forEach(allocation => {
        if (!allocationsByTransactionId[allocation.transaction_id]) {
          allocationsByTransactionId[allocation.transaction_id] = [];
        }
        allocationsByTransactionId[allocation.transaction_id].push(allocation);
      });
      
      // トランザクションに割当情報を追加
      transactions.forEach(transaction => {
        const transactionAllocations = allocationsByTransactionId[transaction.id] || [];
        if (transactionAllocations.length > 0) {
          const firstAllocation = transactionAllocations[0];
          const budgetItem = budgetItemsData.find(item => item.id === firstAllocation.budget_item_id);
          if (budgetItem) {
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
      console.log('API allocations data:', apiAllocationsData);

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

      setApiAllocations(apiAllocationsData);
      
      // allocations状態は空で初期化（APIからデータ取得済み）
      setAllocations({});
      
      console.log('State after setting:', {
        budgetItemsCount: budgetItemsData.length,
        grantsCount: updatedGrants.length,
        transactionsCount: transactions.length,
        apiAllocationsCount: apiAllocationsData.length
      });
    } catch (error) {
      console.error('Failed to load data:', error);
      alert('データの読み込みに失敗しました: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const loadSavedFilters = () => {
    // フィルターは一時的なUIステートのためsessionStorageを使用
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

  // 残額計算関数
  const calculateRemainingAmount = (budgetItem: BudgetItem) => {
    const allocatedAmount = apiAllocations
      .filter(allocation => allocation.budget_item_id === budgetItem.id)
      .reduce((sum, allocation) => sum + allocation.amount, 0);
    return budgetItem.budgeted_amount - allocatedAmount;
  };

  // 予算項目グリッドの列定義
  const budgetColumnDefs: ColDef[] = useMemo(() => [
    {
      field: 'display_name',
      headerName: '予算項目名',
      valueGetter: (params) => params.data.display_name || params.data.name,
      filter: 'agTextColumnFilter',
      flex: 2,
      minWidth: 200,
      pinned: 'left'
    },
    {
      field: 'remaining_amount',
      headerName: '残額',
      valueGetter: (params) => calculateRemainingAmount(params.data),
      valueFormatter: (params) => params.value?.toLocaleString() || '0',
      filter: 'agNumberColumnFilter',
      cellClass: 'text-right',
      width: 120,
      minWidth: 100,
      cellStyle: (params) => {
        const remaining = params.value;
        return {
          color: remaining < 0 ? '#dc2626' : remaining === 0 ? '#9ca3af' : '#059669'
        };
      }
    },
    {
      field: 'grant_period',
      headerName: '期間',
      valueGetter: (params) => {
        const grant = grants.find(g => g.id === params.data.grant_id);
        if (grant && grant.start_date && grant.end_date) {
          const start = new Date(grant.start_date);
          const end = new Date(grant.end_date);
          const startStr = `${start.getMonth() + 1}/${start.getDate()}`;
          const endStr = `${end.getMonth() + 1}/${end.getDate()}`;
          return `${startStr}〜${endStr}`;
        }
        return '';
      },
      filter: 'agTextColumnFilter',
      width: 120,
      minWidth: 100
    },
    {
      field: 'category',
      headerName: 'カテゴリ',
      filter: 'agTextColumnFilter',
      flex: 1,
      minWidth: 120
    }
  ], [apiAllocations, grants]);

  // 報告済み助成金を除外した予算項目データ
  const filteredBudgetItems = useMemo(() => {
    return budgetItems.filter(item => {
      const grant = grants.find(g => g.id === item.grant_id);
      return !(grant && grant.status === 'applied');
    });
  }, [budgetItems, grants]);

  const columnDefs: ColDef[] = useMemo(() => [
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
        // localStorageは使用せず、状態管理のみ
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
            const displayName = value.display_name || value.name || '';
            return displayName;
          }
          return String(value);
        }
        
        return value;
      },
      width: 160,
      minWidth: 140,
      cellStyle: (params) => {
        const value = params.value;
        const isUnallocated = !value || value === '未割当';
        return {
          fontWeight: 'bold',
          color: isUnallocated ? '#9ca3af' : undefined
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
        // localStorageは使用せず、状態管理のみ
        
        console.log('Amount setter - preserving budget item:', currentBudgetItem);
        return true;
      },
      cellEditor: 'agNumberCellEditor',
      cellClass: 'text-right',
      width: 120,
      minWidth: 100,
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
        // APIから直接ステータスを取得（最優先）
        if (params.data.budget_item?.grant_status) {
          switch (params.data.budget_item.grant_status) {
            case 'active': return '実行中';
            case 'completed': return '終了';
            case 'applied': return '報告済み';
            default: return '不明';
          }
        }
        
        // budget_itemのIDから直接budgetItemsを検索
        if (params.data.budget_item?.id) {
          const budgetItem = budgetItems.find(item => item.id === params.data.budget_item.id);
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
        }
        
        // 割り当て状態から予算項目を取得（フォールバック）
        const allocation = allocations[params.data.id];
        const currentBudgetItem = allocation?.budget_item;
        
        // 予算項目が未割当または空の場合は空文字を返す
        if (!currentBudgetItem || currentBudgetItem === '未割当') {
          return '';
        }
        
        // budget_itemから対応するbudgetItemオブジェクトを検索
        const budgetItem = budgetItems.find(item => 
          (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === currentBudgetItem
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
        // APIから直接カテゴリを取得（最優先）
        if (params.data.budget_item?.category && params.data.budget_item.category.trim() !== '') {
          return params.data.budget_item.category;
        }
        
        // budget_itemのIDから直接budgetItemsを検索
        if (params.data.budget_item?.id) {
          const budgetItem = budgetItems.find(item => item.id === params.data.budget_item.id);
          if (budgetItem?.category && budgetItem.category.trim() !== '') {
            return budgetItem.category;
          }
        }
        
        // 割り当て状態から予算項目を取得（フォールバック）
        const allocation = allocations[params.data.id];
        const currentBudgetItem = allocation?.budget_item;
        
        // 予算項目が未割当または空の場合は空文字を返す
        if (!currentBudgetItem || currentBudgetItem === '未割当') {
          return '';
        }
        
        // budget_itemから対応するbudgetItemオブジェクトを検索
        const budgetItem = budgetItems.find(item => 
          (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === currentBudgetItem
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
            // localStorageは使用せず、状態管理のみ
            
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
          
          // 状態管理のみ（localStorageは使用しない）
          setAllocations(prev => ({
            ...prev,
            [params.data.id]: {
              budget_item: params.data.budget_item,
              allocated_amount_edit: params.data.allocated_amount_edit,
              allocated_budget_item: params.data.allocated_budget_item,
              allocated_amount: allocationAmount
            }
          }));
          
          // 特定のセルのみリフレッシュ
          params.api.refreshCells({ 
            rowNodes: [params.node], 
            columns: ['allocated_amount_edit'], 
            force: true 
          });
          
          console.log('予算項目が正常に割り当てられました');
          
          // 助成金残額を更新（非同期で実行）
          loadData().then(() => {
            if (budgetGridRef.current?.api) {
              budgetGridRef.current.api.refreshCells({ force: true });
            }
          });
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
            // localStorageは使用せず、状態管理のみ
            
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

  const onBudgetGridSelectionChanged = () => {
    if (budgetGridRef.current) {
      const selectedBudgetRows = budgetGridRef.current.api.getSelectedRows();
      if (selectedBudgetRows.length > 0) {
        setSelectedBudgetItem(selectedBudgetRows[0]);
      } else {
        setSelectedBudgetItem(null);
      }
    }
  };

  const batchAllocate = async () => {
    if (!selectedBudgetItem || selectedRows.length === 0) {
      alert('予算項目と取引を選択してください');
      return;
    }

    try {
      const apiAllocations = selectedRows.map(row => ({
        transaction_id: row.id,
        budget_item_id: selectedBudgetItem.id,
        amount: row.amount
      }));

      // API呼び出し
      await api.createBatchAllocations(apiAllocations);
      
      // ローカルストレージの情報を安全に更新
      const newAllocations = { ...allocations };
      const budgetItemDisplayName = selectedBudgetItem.display_name || selectedBudgetItem.name;
      
      selectedRows.forEach(row => {
        // 既存の割り当て情報を保持
        const existingAllocation = allocations[row.id] || {};
        
        // 新しい割り当て情報をマージ
        newAllocations[row.id] = {
          ...existingAllocation, // 既存情報を保持
          budget_item: budgetItemDisplayName,
          allocated_amount_edit: row.amount, // 金額をコピー
          allocated_budget_item: budgetItemDisplayName,
          allocated_amount: row.amount
        };
        
        // グリッドデータも更新
        row.budget_item = budgetItemDisplayName;
        row.allocated_amount_edit = row.amount;
        row.allocated_budget_item = budgetItemDisplayName;
        row.allocated_amount = row.amount;
      });
      
      // React状態のみ更新（localStorageは使用しない）
      setAllocations(newAllocations);
      
      // グリッドをリフレッシュして表示を更新
      if (gridRef.current?.api) {
        gridRef.current.api.refreshCells({ 
          columns: ['budget_item', 'allocated_amount_edit'],
          force: true 
        });
      }
      
      gridRef.current?.api.deselectAll();
      setSelectedBudgetItem(null);
      
      console.log('Batch allocation completed:', {
        count: selectedRows.length,
        budgetItem: budgetItemDisplayName,
        allocationsUpdated: Object.keys(newAllocations).length
      });
      
      // 助成金残額を更新するためにデータを再読み込み
      await loadData();
      
      // 予算項目グリッドもリフレッシュ
      if (budgetGridRef.current?.api) {
        budgetGridRef.current.api.refreshCells({ force: true });
      }
      
    } catch (error) {
      console.error('Failed to batch allocate:', error);
      alert('一括割り当てに失敗しました: ' + error.message);
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


  const handleExportAllData = async () => {
    try {
      const blob = await api.exportAllData();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `all_data_${new Date().toISOString().split('T')[0]}.csv`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
      alert('統合データCSVファイルがダウンロードされました');
    } catch (error) {
      console.error('All data export error:', error);
      alert('統合データエクスポートに失敗しました: ' + error.message);
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
    <>
      <style jsx>{`
        .budget-grid-custom .ag-cell[col-id="category"] .ag-selection-checkbox {
          display: none !important;
        }
        .budget-grid-custom .ag-header-cell[col-id="category"] .ag-selection-checkbox {
          display: none !important;
        }
        .budget-grid-custom .ag-cell-field-category .ag-selection-checkbox {
          display: none !important;
        }
        .budget-grid-custom .ag-header-cell-field-category .ag-selection-checkbox {
          display: none !important;
        }
      `}</style>
      <div className="w-full flex gap-4" style={{ height: 'calc(100vh - 100px)' }}>
        {/* 左側: 助成金・予算項目一覧 */}
      <div className="w-1/3 flex flex-col">
        <div className="mb-2 p-3 bg-blue-50 rounded flex-shrink-0">
          <h3 className="font-semibold text-blue-900 mb-2">予算項目選択</h3>
          <div className="text-sm text-gray-600 mb-2">
            予算項目を選択してください
          </div>
        </div>
        
        <div className="flex-1">
          <AgGridReact
            ref={budgetGridRef}
            rowData={filteredBudgetItems}
            columnDefs={budgetColumnDefs}
            theme={themeAlpine}
            className="budget-grid-custom"
            defaultColDef={{
              sortable: true,
              filter: true,
              resizable: true,
              floatingFilter: true,
              minWidth: 80
            }}
            rowHeight={28}
            rowSelection={{ mode: 'singleRow', checkboxes: false, enableClickSelection: true }}
            onSelectionChanged={onBudgetGridSelectionChanged}
            getRowStyle={(params) => {
              return params.node.rowIndex % 2 === 0 
                ? { backgroundColor: '#f3f4f6' } 
                : { backgroundColor: '#ffffff' };
            }}
            pagination={true}
            paginationPageSize={20}
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
              noRowsToShow: '表示するデータがありません'
            }}
          />
        </div>
      </div>

      {/* 右側: 取引一覧 */}
      <div className="w-2/3 flex flex-col">
        {/* 一括割当操作 */}
        <div className="mb-2 p-3 bg-green-50 rounded flex-shrink-0">
          <div className="flex gap-4 items-center flex-wrap">
            <span className="font-semibold text-green-900">一括割当:</span>
            <span className="text-sm text-gray-600">
              {selectedBudgetItem ? (
                <>選択中: {selectedBudgetItem.display_name || selectedBudgetItem.name}</>
              ) : (
                '予算項目を選択してください'
              )}
            </span>
            {selectedRows.length > 0 && (
              <span className="text-sm font-medium text-blue-700">
                選択合計: ¥{selectedRows.reduce((sum, row) => sum + (row.amount || 0), 0).toLocaleString()}
              </span>
            )}
            <button
              className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 disabled:bg-gray-300"
              onClick={batchAllocate}
              disabled={!selectedBudgetItem || selectedRows.length === 0}
            >
              選択した{selectedRows.length}件を一括割当
            </button>
          </div>
        </div>

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
        <div className="flex-1 w-full">
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
            rowSelection={{ mode: 'multiRow', checkboxes: true, headerCheckbox: true, enableClickSelection: false }}
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

      </div>
    </>
  );
};

export default BatchAllocationGrid;