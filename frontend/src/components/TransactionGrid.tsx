'use client';

import React, { useState, useEffect, useRef, useMemo } from 'react';
import { AgGridReact } from 'ag-grid-react';
import { ColDef, GridApi, ModuleRegistry, AllCommunityModule } from 'ag-grid-community';
import dayjs from 'dayjs';
import { api, Transaction, BudgetItem, Grant } from '@/lib/api';
import { CONFIG } from '@/lib/config';
import { generateMonthlyPresets, generateYearlyPresets } from '@/lib/dateUtils';
import type { ICellRendererParams } from 'ag-grid-community';

interface TransactionGridProps {
  onSelectionChanged?: (selectedRows: Transaction[]) => void;
  enableBatchAllocation?: boolean;
  dateFilter?: { start_date: string; end_date: string } | null;
  onTransactionSelect?: (transaction: Transaction | null) => void;
  selectedTransaction?: Transaction | null;
  selectedBudgetItem?: any;
  allocations?: any[];
}

const TransactionGrid = React.forwardRef<any, TransactionGridProps>(({ onSelectionChanged: onSelectionChangedProp, enableBatchAllocation = false, dateFilter, onTransactionSelect, selectedTransaction, selectedBudgetItem, allocations: propAllocations }, ref) => {
  const [rowData, setRowData] = useState<Transaction[]>([]);
  const [budgetItems, setBudgetItems] = useState<BudgetItem[]>([]);
  const [grants, setGrants] = useState<Grant[]>([]);
  const [savedFilters, setSavedFilters] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedRows, setSelectedRows] = useState<Transaction[]>([]);
  const [allocations, setAllocations] = useState<{ [key: string]: any }>({});
  const [apiAllocations, setApiAllocations] = useState<any[]>([]);
  const [displayedRowStats, setDisplayedRowStats] = useState({ count: 0, totalAmount: 0, totalAllocatedAmount: 0 });

  const gridRef = useRef<AgGridReact>(null);

  // 親コンポーネントからのrefを設定
  React.useImperativeHandle(ref, () => ({
    api: gridRef.current?.api,
    reloadData: loadData,
    clearSelection: () => {
      if (gridRef.current?.api) {
        gridRef.current.api.deselectAll();
      }
    },
    refreshSelectedRows: (selectedTransactionIds: number[]) => {
      if (!gridRef.current?.api) return;
      
      // 最新のAPIデータを取得して、選択された行のみを更新
      const refreshRowsData = async () => {
        try {
          const [updatedAllocations] = await Promise.all([
            api.getAllocations()
          ]);
          
          // 選択された取引IDに対応するノードを見つけて更新
          const nodesToUpdate: any[] = [];
          gridRef.current?.api.forEachNode((node) => {
            if (selectedTransactionIds.includes(node.data.id)) {
              // 新しい割当データを適用
              const transactionAllocations = updatedAllocations.filter(a => a.transaction_id === node.data.id);
              if (transactionAllocations.length > 0) {
                const firstAllocation = transactionAllocations[0];
                const budgetItem = budgetItems.find(item => item.id === firstAllocation.budget_item_id);
                if (budgetItem) {
                  const displayName = budgetItem.display_name || `${budgetItem.grant_name || '不明'}-${budgetItem.name}`;
                  node.data.budget_item = displayName;
                  node.data.allocated_amount_edit = firstAllocation.amount;
                  node.data.allocated_budget_item = budgetItem.display_name || budgetItem.name;
                  node.data.allocated_amount = firstAllocation.amount;
                }
              } else {
                // 割当が削除された場合
                node.data.budget_item = '';
                node.data.allocated_amount_edit = 0;
                node.data.allocated_budget_item = '';
                node.data.allocated_amount = 0;
              }
              nodesToUpdate.push(node);
            }
          });
          
          // 選択された行のみをリフレッシュ
          if (nodesToUpdate.length > 0) {
            gridRef.current?.api.refreshCells({
              rowNodes: nodesToUpdate,
              force: true
            });
            
            // 統計を更新
            setTimeout(updateDisplayedRowStats, 100);
          }
          
        } catch (error) {
          console.error('Failed to refresh selected rows:', error);
        }
      };
      
      refreshRowsData();
    }
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

  // 割当データが変更された時に統計を更新
  useEffect(() => {
    if (!loading && apiAllocations.length >= 0) {
      setTimeout(updateDisplayedRowStats, 100);
    }
  }, [apiAllocations]);

    // dateFilterが変更された際にグリッドのフィルターを適用
  useEffect(() => {
    if (gridRef.current?.api && !loading) {
      console.log('dateFilter changed:', dateFilter);
      
      const applyDateFilter = () => {
        if (!gridRef.current?.api) return;
      
        // 現在のスクロール位置を保存
        const scrollTop = gridRef.current.api.getVerticalPixelRange()?.top || 0;
        
      // 選択状態を保存
      const selectedNodes = gridRef.current.api.getSelectedNodes();
      const selectedIds = selectedNodes.map(node => node.data.id);
      
        // 現在のフィルターモデルを取得
        const currentFilter: any = gridRef.current.api.getFilterModel() || {};
      
      if (dateFilter) {
        // 助成期間でフィルター
        console.log('Applying date filter:', dateFilter.start_date, 'to', dateFilter.end_date);
          
          // AG Gridの日付フィルター形式に変換
          // inRangeは境界値を含まないため、時刻を調整して対応
          const startDate = new Date(dateFilter.start_date);
          const endDate = new Date(dateFilter.end_date);
          
          // 開始日の00:00:00の1秒前、終了日の23:59:59の1秒後を設定
          startDate.setHours(0, 0, 0, 0);
          startDate.setTime(startDate.getTime() - 1000);
          endDate.setHours(23, 59, 59, 999);
          endDate.setTime(endDate.getTime() + 1000);
          
          const dateFromFormatted = startDate.toISOString().split('T')[0];
          const dateToFormatted = endDate.toISOString().split('T')[0];
          
          console.log('Formatted dates (adjusted for inRange):', dateFromFormatted, 'to', dateToFormatted);
          
        currentFilter['date'] = {
          filterType: 'date',
          type: 'inRange',
            dateFrom: dateFromFormatted,
            dateTo: dateToFormatted
        };
      } else {
        // 日付フィルターをクリア
        console.log('Clearing date filter');
        delete currentFilter['date'];
      }
      
        console.log('Setting filter model:', currentFilter);
      gridRef.current.api.setFilterModel(currentFilter);
      
        // 選択状態とスクロール位置を復元（少し遅延させる）
      setTimeout(() => {
          if (gridRef.current?.api) {
            // 選択状態を復元
            if (selectedIds.length > 0) {
          gridRef.current.api.forEachNode((node) => {
            if (selectedIds.includes(node.data.id)) {
              node.setSelected(true);
            }
          });
            }
            
            // スクロール位置を復元
            if (scrollTop > 0) {
              try {
                // 最初の表示行を見つけて、その行が見えるようにスクロール
                const firstVisibleRowIndex = Math.floor(scrollTop / 28); // rowHeight = 28
                gridRef.current.api.ensureIndexVisible(firstVisibleRowIndex, 'top');
              } catch (error) {
                console.log('Failed to restore scroll position:', error);
              }
            }
        }
        }, 100);
      };

      // 即座に適用
      applyDateFilter();
      
      // 追加で少し遅延させて再適用（他の処理で上書きされることを防ぐ）
      const timeouts = [200, 500, 1000].map(delay => 
        setTimeout(applyDateFilter, delay)
      );
      
      // クリーンアップ
      return () => {
        timeouts.forEach(timeout => clearTimeout(timeout));
      };
    }
  }, [dateFilter, loading]);

  // グリッドが準備完了時にデフォルトフィルターを適用
  const onGridReady = (params: any) => {
    console.log('Grid ready, dateFilter:', dateFilter);
    
    // グリッド準備完了時は基本フィルターのみ設定
    const filterModel: any = {
      'grant_status': {
        filterType: 'text',
        type: 'notEqual',
        filter: '報告済み'
      }
    };

    // dateFilterがある場合は即座に適用
    if (dateFilter) {
      // inRangeは境界値を含まないため、時刻を調整して対応
      const startDate = new Date(dateFilter.start_date);
      const endDate = new Date(dateFilter.end_date);
      
      // 開始日の00:00:00の1秒前、終了日の23:59:59の1秒後を設定
      startDate.setHours(0, 0, 0, 0);
      startDate.setTime(startDate.getTime() - 1000);
      endDate.setHours(23, 59, 59, 999);
      endDate.setTime(endDate.getTime() + 1000);
      
      const dateFromFormatted = startDate.toISOString().split('T')[0];
      const dateToFormatted = endDate.toISOString().split('T')[0];
      
      filterModel['date'] = {
        filterType: 'date',
        type: 'inRange',
        dateFrom: dateFromFormatted,
        dateTo: dateToFormatted
      };
      console.log('Applying dateFilter in onGridReady (adjusted for inRange):', dateFilter, 'formatted:', dateFromFormatted, 'to', dateToFormatted);
    }

    params.api.setFilterModel(filterModel);
    
    // デフォルトソートを設定（取引日降順）
    params.api.applyColumnState({
      state: [
        {
          colId: 'date',
          sort: 'desc'
        }
      ],
      defaultState: { sort: null }
    });
    
    // 初期フィルターを適用（少し遅延させる）
    setTimeout(() => {
      applyInitialFilters();
      updateDisplayedRowStats();
    }, 100);
  };

  // 初期フィルターを適用する関数
  const applyInitialFilters = () => {
    if (!gridRef.current?.api) return;

    const currentFilter: any = gridRef.current.api.getFilterModel();

    // dateFilterプロパティが設定されている場合はそれを最優先
    if (dateFilter) {
      console.log('Applying dateFilter from props:', dateFilter);
      // inRangeは境界値を含まないため、開始日を1日前、終了日を1日後に調整
      const startDate = new Date(dateFilter.start_date);
      startDate.setDate(startDate.getDate() - 1);
      const endDate = new Date(dateFilter.end_date);
      endDate.setDate(endDate.getDate() + 1);
      
      currentFilter['date'] = {
        filterType: 'date',
        type: 'inRange',
        dateFrom: startDate.toISOString().split('T')[0],
        dateTo: endDate.toISOString().split('T')[0]
      };
    } else {
      // dateFilterが未設定の場合のみsessionStorageから期間フィルター設定を読み込み
      const savedDateFilter = sessionStorage.getItem('transactionDateFilter');
      if (savedDateFilter) {
        try {
          const filterSettings = JSON.parse(savedDateFilter);
          if (filterSettings.startDate && filterSettings.endDate) {
            console.log('Applying saved date filter:', filterSettings);
            // inRangeは境界値を含まないため、開始日を1日前、終了日を1日後に調整
            const startDate = new Date(filterSettings.startDate);
            startDate.setDate(startDate.getDate() - 1);
            const endDate = new Date(filterSettings.endDate);
            endDate.setDate(endDate.getDate() + 1);
            
            currentFilter['date'] = {
              filterType: 'date',
              type: 'inRange',
              dateFrom: startDate.toISOString().split('T')[0],
              dateTo: endDate.toISOString().split('T')[0]
            };
          }
        } catch (error) {
          console.error('Failed to parse date filter settings:', error);
        }
      }
    }

    gridRef.current.api.setFilterModel(currentFilter);
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
      const allocationsByTransactionId: { [key: string]: any[] } = {};
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
            transaction.allocated_budget_item = budgetItem.display_name || budgetItem.name;
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

      // データ読み込み完了後にフィルターを再適用（特に日付フィルター）
      setTimeout(() => {
        if (dateFilter && gridRef.current?.api) {
          console.log('Re-applying dateFilter after data load:', dateFilter);
          const currentFilter: any = gridRef.current.api.getFilterModel();
          // inRangeは境界値を含まないため、開始日を1日前、終了日を1日後に調整
          const startDate = new Date(dateFilter.start_date);
          startDate.setDate(startDate.getDate() - 1);
          const endDate = new Date(dateFilter.end_date);
          endDate.setDate(endDate.getDate() + 1);
          
          currentFilter['date'] = {
            filterType: 'date',
            type: 'inRange',
            dateFrom: startDate.toISOString().split('T')[0],
            dateTo: endDate.toISOString().split('T')[0]
          };
          gridRef.current.api.setFilterModel(currentFilter);
        }
      }, 200);
    } catch (error) {
      console.error('Failed to load data:', error);
      alert('データの読み込みに失敗しました: ' + (error instanceof Error ? error.message : 'Unknown error'));
    } finally {
      setLoading(false);
      // データ読み込み完了後に統計を更新（遅延実行）
      setTimeout(updateDisplayedRowStats, 200);
    }
  };

  const loadSavedFilters = () => {
    // 月次プリセットフィルターを生成
    const monthlyPresets = generateMonthlyPresets();
    const yearlyPresets = generateYearlyPresets();
    
    // セッションストレージから助成金期間フィルターを確認
    const grantPeriodFilterData = sessionStorage.getItem('grantPeriodFilter');
    let grantPeriodPreset: Array<{
      id: string;
      name: string;
      startDate: string;
      endDate: string;
      isPermanent: boolean;
      isGrantPeriod: boolean;
    }> = [];
    if (grantPeriodFilterData) {
      try {
        const grantFilter = JSON.parse(grantPeriodFilterData);
        grantPeriodPreset = [{
          id: 'selected_grant_period',
          name: `${grantFilter.grantName}の期間（${grantFilter.startDate}〜${grantFilter.endDate}）`,
          startDate: grantFilter.startDate,
          endDate: grantFilter.endDate,
          isPermanent: false,
          isGrantPeriod: true
        }];
      } catch (error) {
        console.error('Failed to parse grant period filter:', error);
      }
    }
    
    // セッションストレージから保存されたカスタムフィルターを読み込む
    const saved = sessionStorage.getItem('savedFilters');
    const customFilters = saved ? JSON.parse(saved) : [];
    
    // プリセットとカスタムフィルターを結合
    setSavedFilters([...monthlyPresets, ...yearlyPresets, ...grantPeriodPreset, ...customFilters]);
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

    const columnDefs = useMemo(() => [
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
      sortable: false,
      floatingFilter: false,
      suppressFloatingFilterButton: true,
      suppressHeaderMenuButton: true
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
      cellClass: 'budget-item-cell',
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
      cellRenderer: (params: ICellRendererParams) => {
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
        const style: { [key: string]: string | number } = {
          textAlign: 'left',
          fontSize: '12px'
        };
        if (isUnallocated) {
          style.color = '#9ca3af';
        }
        if (!isUnallocated) {
          style.fontWeight = 'bold';
        }
        return style;
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
      cellStyle: { fontWeight: 'bold', fontSize: '12px', textAlign: 'right' },
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
      cellStyle: { fontSize: '12px' },
      width: 100,
      minWidth: 100,
      pinned: 'left'
    },
    {
      field: 'amount',
      headerName: '金額',
      valueFormatter: (params) => params.value?.toLocaleString() || '0',
      cellClass: 'text-right',
      cellStyle: { fontSize: '12px' },
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
      cellStyle: { fontSize: '12px' },
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
      cellStyle: { fontSize: '12px' },
      width: 200,
      minWidth: 150
    },
    {
      field: 'description',
      headerName: '取引内容',
      filter: 'agTextColumnFilter',
      cellStyle: { fontSize: '12px' },
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
      cellStyle: { fontSize: '12px' },
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
      cellStyle: { fontSize: '12px' },
      width: 200,
      minWidth: 150
    },
    {
      field: 'remark',
      headerName: '備考',
      filter: 'agTextColumnFilter',
      cellStyle: { fontSize: '12px' },
      width: 200,
      minWidth: 150,
      tooltipField: 'remark'
    },
    {
      field: 'memo',
      headerName: 'メモ',
      filter: 'agTextColumnFilter',
      cellStyle: { fontSize: '12px' },
      width: 150,
      minWidth: 100
    },
    {
      field: 'management_number',
      headerName: '管理番号',
      filter: 'agTextColumnFilter',
      cellStyle: { fontSize: '12px' },
      width: 100,
      minWidth: 80
    },
    {
      field: 'journal_number',
      headerName: '仕訳番号',
      filter: 'agNumberColumnFilter',
      cellStyle: { fontSize: '12px' },
      width: 90,
      minWidth: 70
    },
    {
      field: 'journal_line_number',
      headerName: '行番号',
      filter: 'agNumberColumnFilter',
      cellStyle: { fontSize: '12px' },
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
      cellStyle: { fontSize: '12px' },
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
      cellStyle: { fontSize: '12px' },
      width: 100,
      minWidth: 80
    },
    {
      field: 'freee_connection',
      headerName: 'Freee連携',
      cellRenderer: (params: ICellRendererParams) => {
        const freee_deal_id = params.data.freee_deal_id;
        
        // 開発環境の判定（localhost:3000またはprod URLでない場合）
        const isDevEnvironment = typeof window !== 'undefined' && 
          (window.location.hostname === 'localhost' || 
           window.location.port === '3000' ||
           !window.location.href.includes('nagaiku.top'));
        
        if (freee_deal_id) {
          return (
            '<span style="color: #059669; font-size: 12px;">✓ 連携済み</span>'
          );
        } else if (isDevEnvironment) {
          return (
            `<div style="font-size: 11px; color: #dc2626; text-align: center;">
              <div>📋 レシート未連携</div>
              <a href="/budget/freee" style="color: #2563eb; text-decoration: underline;" onclick="event.stopPropagation();">Freee連携ページ</a>
            </div>`
          );
        } else {
          return (
            `<a href="/budget/freee" style="color: #2563eb; font-size: 12px; text-decoration: underline;" onclick="event.stopPropagation();">Freee連携</a>`
          );
        }
      },
      filter: 'agTextColumnFilter',
      filterParams: {
        valueGetter: (params: any) => {
          return params.data.freee_deal_id ? '連携済み' : '未連携';
        }
      },
      cellStyle: { fontSize: '12px', textAlign: 'center' },
      width: 130,
      minWidth: 110
    }
  ] as ColDef[], [availableBudgetItems, allocations, budgetItems, grants, enableBatchAllocation]);

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

        // 「未割当」選択時は既存の割当を削除
        if (params.data.budget_item === '未割当') {
          // 既存の割当を削除
          try {
            // まず既存の割当IDを取得
            const existingAllocation = apiAllocations.find(a => a.transaction_id === params.data.id);
            if (existingAllocation) {
              await api.deleteAllocation(existingAllocation.id);
              console.log('Allocation deleted successfully');
              
              // APIから最新のアロケーションデータを再取得
              const updatedAllocations = await api.getAllocations();
              setApiAllocations(updatedAllocations);
            }

            // ローカル状態をクリア
            const newAllocations = { ...allocations };
            delete newAllocations[params.data.id];
            setAllocations(newAllocations);

            // データをクリア
            params.data.budget_item = '';
            params.data.allocated_amount_edit = 0;
            params.data.allocated_amount = 0;

            // グリッドをリフレッシュ
            params.api.refreshCells({
              rowNodes: [params.node],
              force: true
            });

            console.log('予算項目の割当を解除しました');
          } catch (error) {
            console.error('Failed to delete allocation:', error);
            alert('割当の削除に失敗しました: ' + (error as Error).message);
          }
          return;
        }

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

          // APIから最新のアロケーションデータを再取得
          const updatedAllocations = await api.getAllocations();
          setApiAllocations(updatedAllocations);

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
        alert('予算項目の割り当てに失敗しました: ' + (error as Error).message);
        // Revert changes on error
        params.api.refreshCells({ rowNodes: [params.node], force: true });
      } finally {
        // データ変更後に統計を更新
        setTimeout(updateDisplayedRowStats, 100);
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

  // 行クリック時のハンドラー
  const onRowClicked = (event: any) => {
    if (onTransactionSelect) {
      onTransactionSelect(event.data);
    }
  };


  const saveFilter = () => {
    if (!gridRef.current) return;

    const name = prompt('フィルター名を入力してください');
    if (name) {
      // 現在のフィルターモデルから日付フィルターを取得
      const currentFilterModel = gridRef.current.api.getFilterModel();
      let startDate = null;
      let endDate = null;
      
      if (currentFilterModel?.date) {
        const dateFilter = currentFilterModel.date;
        if (dateFilter.dateFrom && dateFilter.dateTo) {
          // inRangeの調整を元に戻す
          const start = new Date(dateFilter.dateFrom);
          start.setDate(start.getDate() + 1);
          startDate = start.toISOString().split('T')[0];
          
          const end = new Date(dateFilter.dateTo);
          end.setDate(end.getDate() - 1);
          endDate = end.toISOString().split('T')[0];
        }
      }
      
      const filterState = {
        name,
        filters: currentFilterModel,
        startDate,
        endDate,
        isCustom: true
      };
      // カスタムフィルターのみを保存
      const customFilters = savedFilters.filter(f => f.isCustom);
      const newCustomFilters = [...customFilters, filterState];
      sessionStorage.setItem('savedFilters', JSON.stringify(newCustomFilters));
      
      // 全体のフィルターリストを更新
      loadSavedFilters();
    }
  };

  const loadFilter = (filterIdentifier: string) => {
    const filter = savedFilters.find(f => 
      f.id === filterIdentifier || f.name === filterIdentifier
    );
    if (filter && gridRef.current) {
      // 月次・年次・助成金期間プリセットの場合は日付フィルターを適用
      if (filter.isMonthlyPreset || filter.isYearlyPreset || filter.isGrantPeriod) {
        const currentFilter = gridRef.current.api.getFilterModel() || {};
        
        // 日付をinRange用に調整
        const startDate = new Date(filter.startDate);
        startDate.setDate(startDate.getDate() - 1);
        const endDate = new Date(filter.endDate);
        endDate.setDate(endDate.getDate() + 1);
        
        currentFilter['date'] = {
          filterType: 'date',
          type: 'inRange',
          dateFrom: startDate.toISOString().split('T')[0],
          dateTo: endDate.toISOString().split('T')[0]
        };
        
        gridRef.current.api.setFilterModel(currentFilter);
        
        // 助成金期間フィルターの場合は使用後にセッションストレージから削除
        if (filter.isGrantPeriod) {
          sessionStorage.removeItem('grantPeriodFilter');
          // フィルターリストを再読み込みして助成金期間フィルターを削除
          setTimeout(() => loadSavedFilters(), 100);
        }
        
        // 統計を更新
        setTimeout(updateDisplayedRowStats, 100);
      } else {
        // カスタムフィルターの場合は保存されたフィルターをそのまま適用
        gridRef.current.api.setFilterModel(filter.filters);
      }
    }
  };

  const clearFilters = () => {
    if (gridRef.current) {
      gridRef.current.api.setFilterModel(null);
    }
  };

  // 表示されている行の統計を更新
  const updateDisplayedRowStats = () => {
    if (!gridRef.current?.api) return;

    const displayedRows: Transaction[] = [];
    gridRef.current.api.forEachNodeAfterFilterAndSort((node) => {
      if (node.data) {
        displayedRows.push(node.data);
      }
    });

    const totalAmount = displayedRows.reduce((sum, row) => sum + (row.amount || 0), 0);
    const totalAllocatedAmount = displayedRows.reduce((sum, row) => {
      const allocation = apiAllocations.find(a => a.transaction_id === row.id);
      return sum + (allocation?.amount || 0);
    }, 0);

    setDisplayedRowStats({
      count: displayedRows.length,
      totalAmount,
      totalAllocatedAmount
    });
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
      <style>{`
        .budget-item-cell {
          text-align: left !important;
        }
        .ag-cell.budget-item-cell {
          text-align: left !important;
        }
      `}</style>

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
          <optgroup label="月次">
            {savedFilters.filter(f => f.isMonthlyPreset).map(f => (
              <option key={f.id} value={f.id}>{f.name}</option>
            ))}
          </optgroup>
          <optgroup label="年度">
            {savedFilters.filter(f => f.isYearlyPreset).map(f => (
              <option key={f.id} value={f.id}>{f.name}</option>
            ))}
          </optgroup>
          {savedFilters.some(f => f.isGrantPeriod) && (
            <optgroup label="助成金期間">
              {savedFilters.filter(f => f.isGrantPeriod).map(f => (
                <option key={f.id} value={f.id}>{f.name}</option>
              ))}
            </optgroup>
          )}
          {savedFilters.some(f => f.isCustom) && (
            <optgroup label="カスタム">
              {savedFilters.filter(f => f.isCustom).map(f => (
                <option key={f.name} value={f.name}>{f.name}</option>
              ))}
            </optgroup>
          )}
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

      {/* 表示中の取引統計 */}
      <div className="flex items-center text-sm text-gray-600 mb-2">
        <span>表示中: {displayedRowStats.count}件</span>
        <span className="ml-3 font-mono">
          金額計: ¥{displayedRowStats.totalAmount.toLocaleString()}
        </span>
        <span className="ml-3 font-mono">
          割当計: ¥{displayedRowStats.totalAllocatedAmount.toLocaleString()}
        </span>
        {enableBatchAllocation && (
          <>
            <span className="ml-6 text-gray-500">|</span>
            <span className="ml-3">選択された取引 - 件数: {selectedRows.length}件</span>
            <span className="ml-3 font-mono">
              合計金額: ¥{selectedRows.reduce((sum, row) => sum + row.amount, 0).toLocaleString()}
            </span>
          </>
        )}
      </div>

      {/* 選択された予算項目の表示 */}
      {enableBatchAllocation && selectedBudgetItem && (() => {
        // 選択された予算項目の残額を計算
        const budgetItemAllocations = (propAllocations || apiAllocations).filter(a => a.budget_item_id === selectedBudgetItem.id);
        const allocatedAmount = budgetItemAllocations.reduce((sum, a) => sum + a.amount, 0);
        const budgetItemRemaining = selectedBudgetItem.budgeted_amount - allocatedAmount;
        
        // 選択された予算項目が属する助成金の情報を取得
        const grant = grants.find(g => g.id === selectedBudgetItem.grant_id);
        let grantRemaining = 0;
        
        // 残り日数を計算して色を決定する関数
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
        
        if (grant) {
          // 助成金全体の予算項目を取得
          const grantBudgetItems = budgetItems.filter(item => item.grant_id === grant.id);
          const totalGrantBudget = grantBudgetItems.reduce((sum, item) => sum + item.budgeted_amount, 0);
          
          // 助成金全体の割当済み金額を計算
          const grantAllocations = (propAllocations || apiAllocations).filter(a => 
            grantBudgetItems.some(item => item.id === a.budget_item_id)
          );
          const totalGrantAllocated = grantAllocations.reduce((sum, a) => sum + a.amount, 0);
          grantRemaining = totalGrantBudget - totalGrantAllocated;
        }
        
        return (
          <div className="bg-blue-50 p-2 rounded flex-shrink-0 mb-2">
            <div className="flex items-center gap-6 text-sm">
              <div className="font-medium text-blue-700">{selectedBudgetItem.display_name}</div>
              <div className={`flex items-center gap-1 ${getRemainingAmountColor(budgetItemRemaining, grant?.end_date)}`}>
                <span>項目残額:</span>
                <span className="font-mono">¥{budgetItemRemaining.toLocaleString()}</span>
              </div>
              {grant && (
                <div className={`flex items-center gap-1 ${getRemainingAmountColor(grantRemaining, grant.end_date)}`}>
                  <span>助成金残額:</span>
                  <span className="font-mono">¥{grantRemaining.toLocaleString()}</span>
                </div>
              )}
            </div>
          </div>
        );
      })()}

      {/* 助成期間フィルターボタン */}
      {selectedBudgetItem && (() => {
        const grant = grants.find(g => g.id === selectedBudgetItem.grant_id);
        if (grant?.start_date && grant?.end_date) {
          const today = new Date();
          const end = new Date(grant.end_date);
          const diffTime = end.getTime() - today.getTime();
          const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
          
          return (
            <div className="mb-2 flex items-center gap-2">
              <span className="text-sm text-gray-600">
                終了日: {grant.end_date} ({diffDays}日)
              </span>
              <button
                onClick={() => {
                  // 現在のフィルター状態を取得
                  const currentFilter = gridRef.current?.api?.getFilterModel() || {};
                  
                  // 日付フィルターを追加（他のフィルターは保持）
                  const startDate = new Date(grant.start_date);
                  startDate.setDate(startDate.getDate() - 1);
                  const endDate = new Date(grant.end_date);
                  endDate.setDate(endDate.getDate() + 1);
                  
                  currentFilter['date'] = {
                    type: 'inRange',
                    dateFrom: startDate.toISOString().split('T')[0],
                    dateTo: endDate.toISOString().split('T')[0]
                  };
                  
                  gridRef.current?.api?.setFilterModel(currentFilter);
                }}
                className="px-3 py-1 text-sm bg-blue-100 text-blue-700 rounded hover:bg-blue-200 transition-colors"
              >
                助成期間でフィルター
              </button>
            </div>
          );
        }
        return null;
      })()}

      {/* グリッド */}
      <div style={{ height: 'calc(100vh - 200px)', width: '100%' }}>
        <style>{`
          .ag-theme-alpine .ag-row .ag-cell {
            font-size: 11px !important;
            font-family: inherit !important;
          }
          .ag-theme-alpine .ag-cell-value {
            font-size: 11px !important;
          }
        `}</style>
        <AgGridReact
          ref={gridRef}
          rowData={rowData}
          columnDefs={columnDefs}
          className="ag-theme-alpine"
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
            return (params.node.rowIndex ?? 0) % 2 === 0
              ? { backgroundColor: '#f3f4f6' }
              : { backgroundColor: '#ffffff' };
          }}
          onSelectionChanged={onGridSelectionChanged}
          onCellValueChanged={onCellValueChanged}
          onGridReady={onGridReady}
          onFilterChanged={updateDisplayedRowStats}
          onSortChanged={updateDisplayedRowStats}
          onRowClicked={onRowClicked}
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