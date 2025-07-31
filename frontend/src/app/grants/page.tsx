'use client';

import React, { useState, useEffect, useRef, useMemo } from 'react';
import { AgGridReact } from 'ag-grid-react';
import { ColDef, ModuleRegistry, AllCommunityModule } from 'ag-grid-community';
import { api, Grant, BudgetItem, Allocation, Category } from '@/lib/api';

const GrantsPage: React.FC = () => {
  const [grants, setGrants] = useState<Grant[]>([]);
  const [budgetItems, setBudgetItems] = useState<BudgetItem[]>([]);
  const [allocations, setAllocations] = useState<Allocation[]>([]);
  const [loading, setLoading] = useState(true);
  const [showNewGrantForm, setShowNewGrantForm] = useState(false);
  const [showNewBudgetItemForm, setShowNewBudgetItemForm] = useState(false);
  const [selectedGrantId, setSelectedGrantId] = useState<number | null>(null);
  const [showReportedBudgetItems, setShowReportedBudgetItems] = useState(false);
  const [showReportedGrants, setShowReportedGrants] = useState(false);
  const [editingGrantId, setEditingGrantId] = useState<number | null>(null);
  const [categories, setCategories] = useState<Category[]>([]);
  const [showCategoryManager, setShowCategoryManager] = useState(false);
  const [newCategoryName, setNewCategoryName] = useState('');
  const [newCategoryDescription, setNewCategoryDescription] = useState('');
  const [showPreview, setShowPreview] = useState(false);
  const [previewData, setPreviewData] = useState<any>(null);
  const [previewFile, setPreviewFile] = useState<File | null>(null);
  const [gridKey, setGridKey] = useState(0); // AG-Grid強制再描画用
  const [editGrant, setEditGrant] = useState({
    name: '',
    total_amount: '',
    start_date: '',
    end_date: '',
    status: 'active',
    grant_code: ''
  });

  const budgetGridRef = useRef<AgGridReact>(null);

  const [newGrant, setNewGrant] = useState({
    name: '',
    total_amount: '',
    start_date: '',
    end_date: '',
    status: 'active',
    grant_code: ''
  });

  const [newBudgetItem, setNewBudgetItem] = useState({
    name: '',
    category: '',
    budgeted_amount: '',
    grant_id: '',
    remarks: '',
    planned_start_date: '',
    planned_end_date: ''
  });

  useEffect(() => {
    ModuleRegistry.registerModules([AllCommunityModule]);

    // カテゴリをAPIから読み込み
    loadCategories();

    loadData();
  }, []);

  const budgetColumnDefs: ColDef[] = useMemo(() => [
    {
      field: 'id',
      headerName: 'ID',
      filter: 'agNumberColumnFilter',
      width: 70,
      minWidth: 60
    },
    {
      field: 'grant_name',
      headerName: '助成金',
      filter: 'agTextColumnFilter',
      width: 200,
      minWidth: 150,
      cellRenderer: (params: any) => {
        const grant = grants.find(g => g.id === params.data.grant_id);
        return grant?.name || '不明';
      }
    },
    {
      field: 'grant_code',
      headerName: '助成金コード',
      filter: 'agTextColumnFilter',
      width: 120,
      minWidth: 100,
      cellRenderer: (params: any) => {
        const grant = grants.find(g => g.id === params.data.grant_id);
        return grant?.grant_code || '';
      }
    },
    {
      field: 'name',
      headerName: '予算項目名',
      filter: 'agTextColumnFilter',
      editable: true,
      width: 200,
      minWidth: 150,
      cellStyle: { backgroundColor: '#ffffff' }
    },
    {
      field: 'category',
      headerName: 'カテゴリ',
      filter: 'agTextColumnFilter',
      editable: true,
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: {
        values: categories.map(cat => cat.name)
      },
      width: 150,
      minWidth: 120,
      cellStyle: { backgroundColor: '#ffffff' }
    },
    {
      field: 'remarks',
      headerName: '備考',
      filter: 'agTextColumnFilter',
      editable: true,
      width: 200,
      minWidth: 150,
      cellStyle: { backgroundColor: '#ffffff' }
    },
    {
      field: 'planned_start_date',
      headerName: '予定開始日',
      filter: 'agDateColumnFilter',
      editable: true,
      width: 130,
      minWidth: 120,
      cellStyle: { backgroundColor: '#ffffff' },
      cellEditor: 'agDateCellEditor',
      valueFormatter: (params) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        return date.toLocaleDateString('ja-JP', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit'
        });
      },
      valueParser: (params) => {
        if (!params.newValue || params.newValue === '') return null;
        // 日付文字列をそのまま返す（YYYY-MM-DD形式）
        if (typeof params.newValue === 'string') {
          return params.newValue.trim() === '' ? null : params.newValue;
        }
        // Date オブジェクトの場合は ISO 文字列に変換
        if (params.newValue instanceof Date) {
          return params.newValue.toISOString().split('T')[0];
        }
        return params.newValue;
      }
    },
    {
      field: 'planned_end_date',
      headerName: '予定終了日',
      filter: 'agDateColumnFilter',
      editable: true,
      width: 130,
      minWidth: 120,
      cellStyle: { backgroundColor: '#ffffff' },
      cellEditor: 'agDateCellEditor',
      valueFormatter: (params) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        return date.toLocaleDateString('ja-JP', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit'
        });
      },
      valueParser: (params) => {
        if (!params.newValue || params.newValue === '') return null;
        // 日付文字列をそのまま返す（YYYY-MM-DD形式）
        if (typeof params.newValue === 'string') {
          return params.newValue.trim() === '' ? null : params.newValue;
        }
        // Date オブジェクトの場合は ISO 文字列に変換
        if (params.newValue instanceof Date) {
          return params.newValue.toISOString().split('T')[0];
        }
        return params.newValue;
      }
    },
    {
      field: 'budgeted_amount',
      headerName: '予算額',
      filter: 'agNumberColumnFilter',
      editable: true,
      cellEditor: 'agNumberCellEditor',
      valueFormatter: (params) => params.value ? params.value.toLocaleString() + '円' : '0円',
      cellClass: 'text-right',
      width: 120,
      minWidth: 100,
      cellStyle: { backgroundColor: '#ffffff' }
    },
    {
      field: 'allocated_amount',
      headerName: '割当額',
      filter: 'agNumberColumnFilter',
      valueGetter: (params) => getAllocatedAmountForBudgetItem(params.data.id),
      valueFormatter: (params) => params.value ? params.value.toLocaleString() + '円' : '0円',
      cellClass: 'text-right',
      width: 120,
      minWidth: 100,
      cellStyle: { backgroundColor: '#f0f9ff', color: '#1e40af' } as any
    },
    {
      field: 'remaining_amount',
      headerName: '残額',
      filter: 'agNumberColumnFilter',
      valueGetter: (params) => getRemainingAmountForBudgetItem(params.data),
      valueFormatter: (params) => params.value ? params.value.toLocaleString() + '円' : '0円',
      cellClass: 'text-right',
      width: 120,
      minWidth: 100,
      cellStyle: ((params) => {
        const remaining = params.value || 0;
        return remaining > 0
          ? { backgroundColor: '#fef2f2', color: '#dc2626', fontWeight: 'bold' }
          : { color: '#374151' };
      }) as any
    }
  ], [grants, categories, allocations]);

  const loadData = async () => {
    try {
      setLoading(true);
      console.log('📥 API からデータを取得中...');
      const [grantsData, budgetItemsData, allocationsData] = await Promise.all([
        api.getGrants(),
        api.getBudgetItems(),
        api.getAllocations().catch(() => {
          // APIが未実装の場合はダミーデータで表示をテスト
          return [
            { transaction_id: '1', budget_item_id: 1, amount: 50000 },
            { transaction_id: '2', budget_item_id: 1, amount: 30000 },
            { transaction_id: '3', budget_item_id: 2, amount: 75000 }
          ];
        })
      ]);

      console.log('📋 取得した予算項目データ:', budgetItemsData);
      setGrants(grantsData);
      setBudgetItems(budgetItemsData);
      setAllocations(allocationsData);
      console.log('✅ Reactステートを更新完了');
    } catch (error) {
      console.error('Failed to load data:', error);
      alert('データの読み込みに失敗しました');
    } finally {
      setLoading(false);
    }
  };

  // データ更新専用の関数（AG-Grid対応）
  const refreshData = async () => {
    try {
      console.log('🔄 データリフレッシュ開始...');
      const [grantsData, budgetItemsData, allocationsData] = await Promise.all([
        api.getGrants(),
        api.getBudgetItems(),
        api.getAllocations().catch(() => [])
      ]);

      console.log('📋 新しい予算項目データ:', budgetItemsData);
      console.log('📋 現在の予算項目データ:', budgetItems);
      
      // Reactステートを更新
      console.log('🔄 Reactステートを更新中...');
      setGrants(grantsData);
      setBudgetItems(budgetItemsData);
      setAllocations(allocationsData);
      console.log('✅ Reactステート更新完了');
      
      // AG-Gridの更新処理
      setTimeout(() => {
        console.log('🔄 AG-Grid更新処理開始...');
        
        // 方法1: API経由での更新
        if (budgetGridRef.current?.api) {
          try {
            budgetGridRef.current.api.refreshCells({ force: true });
            budgetGridRef.current.api.redrawRows();
            console.log('✅ AG-Grid API更新完了');
          } catch (apiError) {
            console.warn('AG-Grid API更新失敗:', apiError);
          }
        }
        
        // 方法2: 完全再描画（フォールバック）
        console.log('🔄 グリッド完全再描画実行...');
        setGridKey(prev => prev + 1);
        console.log('✅ 全更新処理完了');
        
      }, 100); // React stateの更新を待つ
      
    } catch (error) {
      console.error('データリフレッシュエラー:', error);
    }
  };

  const loadCategories = async () => {
    try {
      const categoriesData = await api.getCategories();
      setCategories(categoriesData);
    } catch (error) {
      console.error('Failed to load categories:', error);
      // フォールバック: デフォルトカテゴリを設定
      setCategories([]);
    }
  };

  const handleCreateGrant = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      await api.createGrant({
        name: newGrant.name,
        total_amount: parseInt(newGrant.total_amount),
        start_date: newGrant.start_date,
        end_date: newGrant.end_date,
        status: newGrant.status,
        grant_code: newGrant.grant_code
      });

      setNewGrant({ name: '', total_amount: '', start_date: '', end_date: '', status: 'active', grant_code: '' });
      setShowNewGrantForm(false);
      await loadData();
    } catch (error) {
      console.error('Failed to create grant:', error);
      alert('助成金の作成に失敗しました');
    }
  };

  const handleCreateBudgetItem = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      await api.createBudgetItem({
        name: newBudgetItem.name,
        category: newBudgetItem.category,
        budgeted_amount: parseInt(newBudgetItem.budgeted_amount),
        grant_id: parseInt(newBudgetItem.grant_id),
        remarks: newBudgetItem.remarks,
        planned_start_date: newBudgetItem.planned_start_date || null,
        planned_end_date: newBudgetItem.planned_end_date || null
      });

      setNewBudgetItem({ name: '', category: '', budgeted_amount: '', grant_id: '', remarks: '', planned_start_date: '', planned_end_date: '' });
      setShowNewBudgetItemForm(false);
      await loadData();
    } catch (error) {
      console.error('Failed to create budget item:', error);
      alert('予算項目の作成に失敗しました');
    }
  };

  const getBudgetItemsByGrant = (grantId: number) => {
    return budgetItems.filter(item => item.grant_id === grantId);
  };

  const getTotalBudgetedAmount = (grantId: number) => {
    return getBudgetItemsByGrant(grantId)
      .reduce((total, item) => total + (item.budgeted_amount || 0), 0);
  };

  const getAllocatedAmountForBudgetItem = (budgetItemId: number) => {
    return allocations
      .filter(allocation => allocation.budget_item_id === budgetItemId)
      .reduce((total, allocation) => total + (allocation.amount || 0), 0);
  };

  const getAllocatedAmountForGrant = (grantId: number) => {
    const grantBudgetItems = getBudgetItemsByGrant(grantId);
    return grantBudgetItems.reduce((total, item) => {
      return total + getAllocatedAmountForBudgetItem(item.id);
    }, 0);
  };

  const getRemainingAmountForBudgetItem = (budgetItem: BudgetItem) => {
    return (budgetItem.budgeted_amount || 0) - getAllocatedAmountForBudgetItem(budgetItem.id);
  };

  const getRemainingAmountForGrant = (grant: Grant) => {
    return (grant.total_amount || 0) - getAllocatedAmountForGrant(grant.id);
  };

  const getDisplayedBudgetTotal = () => {
    const displayedItems = budgetItems.filter(item => !selectedGrantId || item.grant_id === selectedGrantId);
    return displayedItems.reduce((total, item) => total + (item.budgeted_amount || 0), 0);
  };

  const getDisplayedAllocatedTotal = () => {
    const displayedItems = budgetItems.filter(item => !selectedGrantId || item.grant_id === selectedGrantId);
    return displayedItems.reduce((total, item) => total + getAllocatedAmountForBudgetItem(item.id), 0);
  };

  const getDisplayedRemainingTotal = () => {
    const displayedItems = budgetItems.filter(item => !selectedGrantId || item.grant_id === selectedGrantId);
    return displayedItems.reduce((total, item) => total + getRemainingAmountForBudgetItem(item), 0);
  };

  const handleStatusChange = async (grantId: number, newStatus: string) => {
    try {
      await api.updateGrant(grantId, { status: newStatus });
      await loadData();
    } catch (error) {
      console.error('Failed to update grant status:', error);
      alert('ステータスの更新に失敗しました');
    }
  };

  const startEdit = (grant: Grant) => {
    setEditingGrantId(grant.id);
    setEditGrant({
      name: grant.name || '',
      total_amount: grant.total_amount ? grant.total_amount.toString() : '',
      start_date: grant.start_date || '',
      end_date: grant.end_date || '',
      status: grant.status || 'active',
      grant_code: grant.grant_code || ''
    });
  };

  const handleUpdateGrant = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingGrantId) return;

    const updateData = {
      name: editGrant.name,
      total_amount: editGrant.total_amount ? parseInt(editGrant.total_amount) : 0,
      start_date: editGrant.start_date,
      end_date: editGrant.end_date,
      status: editGrant.status as 'active' | 'completed' | 'applied',
      grant_code: editGrant.grant_code
    };

    try {
      await api.updateGrant(editingGrantId, updateData);
      setEditingGrantId(null);
      setEditGrant({ name: '', total_amount: '', start_date: '', end_date: '', status: 'active', grant_code: '' });
      await loadData();
    } catch (error) {
      console.error('Failed to update grant:', error);
      alert('助成金の更新に失敗しました');
    }
  };

  const cancelEdit = () => {
    setEditingGrantId(null);
    setEditGrant({ name: '', total_amount: '', start_date: '', end_date: '', status: 'active', grant_code: '' });
  };

  const onBudgetCellValueChanged = async (params: any) => {
    try {
      console.log('🔄 予算項目セル値変更:', {
        field: params.colDef.field,
        oldValue: params.oldValue,
        newValue: params.newValue,
        itemId: params.data.id,
        itemName: params.data.name,
        fullRowData: params.data
      });

      // 日付データをYYYY-MM-DD形式に変換
      const formatDateForAPI = (dateValue: any) => {
        if (!dateValue) return null;
        if (typeof dateValue === 'string') {
          // ISO形式の文字列の場合は日付部分のみ抽出
          if (dateValue.includes('T')) {
            return dateValue.split('T')[0];
          }
          return dateValue;
        }
        if (dateValue instanceof Date) {
          return dateValue.toISOString().split('T')[0];
        }
        return null;
      };

      const updatedData = {
        name: params.data.name,
        category: params.data.category,
        budgeted_amount: params.data.budgeted_amount,
        grant_id: params.data.grant_id,
        remarks: params.data.remarks,
        planned_start_date: formatDateForAPI(params.data.planned_start_date),
        planned_end_date: formatDateForAPI(params.data.planned_end_date)
      };

      console.log('📤 API送信データ:', updatedData);

      // 新しい行（一時的なID）の場合は作成、既存の行は更新
      const isNewRow = params.data.id > 1000000000000; // Date.now()で生成されたIDは13桁以上

      if (isNewRow) {
        // 新規作成
        console.log('📝 新規予算項目を作成中...');
        const newItem = await api.createBudgetItem(updatedData);
        // 一時的なIDを実際のIDに更新
        params.data.id = newItem.id;
        console.log('✅ 予算項目作成完了:', newItem);
      } else {
        // 既存の更新
        console.log('🔄 既存予算項目を更新中... ID:', params.data.id);
        const result = await api.updateBudgetItem(params.data.id, updatedData);
        console.log('✅ 予算項目更新完了:', result);
      }

      // データ更新後の処理を分離
      console.log('🔄 データを再読み込み中...');
      await refreshData();
      console.log('✅ データ再読み込み完了');

      // 成功時の視覚的フィードバック
      const toast = document.createElement('div');
      toast.style.cssText = 'position:fixed;top:20px;right:20px;background:#d4edda;color:#155724;padding:10px;border-radius:4px;z-index:1000;border:1px solid #c3e6cb;';
      toast.textContent = isNewRow ? '予算項目を作成しました' : '予算項目を更新しました';
      document.body.appendChild(toast);
      setTimeout(() => document.body.removeChild(toast), 3000);

    } catch (error) {
      console.error('Failed to update budget item:', error);
      alert('予算項目の' + (params.data.id > 1000000000000 ? '作成' : '更新') + 'に失敗しました: ' + (error as Error).message);
      // エラー時は元の値に戻す
      params.api.refreshCells({ rowNodes: [params.node], force: true });
    }
  };

  const addNewBudgetRow = () => {
    const newRow = {
      id: Date.now(), // 一時的なID
      name: '',
      category: '',
      budgeted_amount: 0,
      grant_id: selectedGrantId || (grants.length > 0 ? grants[0].id : 1),
      remarks: '',
      planned_start_date: null,
      planned_end_date: null
    };

    const updatedItems = [...budgetItems, newRow];
    setBudgetItems(updatedItems);
  };

  const handleDeleteSelected = async () => {
    if (!budgetGridRef.current) return;

    const selectedRows = budgetGridRef.current.api.getSelectedRows();
    if (selectedRows.length === 0) {
      alert('削除する行を選択してください');
      return;
    }

    if (confirm(`${selectedRows.length}件の予算項目を削除しますか？`)) {
      try {
        // 新規作成された行（一時的なID）と既存の行を分離
        const existingRows = selectedRows.filter(row => row.id < 1000000000000);
        const newRows = selectedRows.filter(row => row.id >= 1000000000000);

        // 既存の行はAPIで削除
        for (const row of existingRows) {
          await api.deleteBudgetItem(row.id);
        }

        // 新規作成された行はローカル状態から削除
      const selectedIds = selectedRows.map(row => row.id);
      const updatedItems = budgetItems.filter(item => !selectedIds.includes(item.id));
      setBudgetItems(updatedItems);

        // 成功メッセージを表示
        const toast = document.createElement('div');
        toast.style.cssText = 'position:fixed;top:20px;right:20px;background:#d4edda;color:#155724;padding:10px;border-radius:4px;z-index:1000;border:1px solid #c3e6cb;';
        toast.textContent = `${selectedRows.length}件の予算項目を削除しました`;
        document.body.appendChild(toast);
        setTimeout(() => document.body.removeChild(toast), 3000);

        // データを再読み込み（既存の行が削除された場合のみ）
        if (existingRows.length > 0) {
          await loadData();
        }
      } catch (error) {
        console.error('Failed to delete budget items:', error);
        alert('予算項目の削除に失敗しました: ' + (error as Error).message);
      }
    }
  };

  // カテゴリ管理機能
  const addCategory = async () => {
    if (!newCategoryName.trim()) {
      alert('カテゴリ名を入力してください');
      return;
    }

    if (categories.some(cat => cat.name === newCategoryName.trim())) {
      alert('このカテゴリは既に存在します');
      return;
    }

    try {
      await api.createCategory({
        name: newCategoryName.trim(),
        description: newCategoryDescription.trim() || undefined
      });
      setNewCategoryName('');
      setNewCategoryDescription('');
      await loadCategories();
    } catch (error) {
      console.error('Failed to create category:', error);
      alert('カテゴリの作成に失敗しました');
    }
  };

  const deleteCategory = async (categoryId: number, categoryName: string) => {
    if (confirm(`カテゴリ「${categoryName}」を削除しますか？`)) {
      try {
        await api.deleteCategory(categoryId);
        await loadCategories();
      } catch (error) {
        console.error('Failed to delete category:', error);
        alert('カテゴリの削除に失敗しました');
      }
    }
  };

  const editCategory = async (categoryId: number, oldName: string) => {
    const newName = prompt('新しいカテゴリ名を入力してください:', oldName);
    if (newName && newName.trim() && newName.trim() !== oldName) {
      if (categories.some(cat => cat.name === newName.trim())) {
        alert('このカテゴリは既に存在します');
        return;
      }

      try {
        await api.updateCategory(categoryId, { name: newName.trim() });
        await loadCategories();
      } catch (error) {
        console.error('Failed to update category:', error);
        alert('カテゴリの更新に失敗しました');
      }
    }
  };


  const handleConfirmImport = async () => {
    if (!previewFile) return;

    try {
      const result = await api.importGrantsBudgetAllocations(previewFile);
      alert(`CSVインポートが完了しました: ${result.imported_count}件のデータが処理されました`);
      loadData(); // データを再読み込み
      setShowPreview(false);
      setPreviewData(null);
      setPreviewFile(null);
    } catch (error) {
      console.error('CSV import error:', error);
      alert('CSVインポートに失敗しました: ' + (error as Error).message);
    }
  };

  const handleCancelImport = () => {
    setShowPreview(false);
    setPreviewData(null);
    setPreviewFile(null);
  };


  if (loading) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="text-lg">データを読み込み中...</div>
      </div>
    );
  }

  return (
    <div className="px-4 py-6 sm:px-0">
      <div className="border-b border-gray-200 pb-4 mb-6">
        <div className="flex justify-between items-start">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">助成金管理</h1>
            <p className="mt-2 text-sm text-gray-600">
              助成金と予算項目の管理
            </p>
          </div>
          <a
            href="https://apps.powerapps.com/play/e/default-72eba3a1-ac06-457f-8658-f999d5e9a204/a/b7c7cb0c-fafa-4262-a8f2-a67788a330c9?tenantId=72eba3a1-ac06-457f-8658-f999d5e9a204&hint=e74e463f-4725-4e38-b7d6-5fdb7391bd5a&source=sharebutton&sourcetime=1750581325001"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center px-4 py-2 bg-indigo-800 text-white text-sm font-medium rounded-md hover:bg-indigo-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-600"
          >
            <svg className="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
            </svg>
            助成金管理システム (Power Apps)
          </a>
        </div>
      </div>

      {/* 助成金一覧 */}
      <div className="mb-8">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold text-gray-900">助成金一覧</h2>
          <button
            onClick={() => setShowNewGrantForm(true)}
            className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
          >
            新規助成金を追加
          </button>
        </div>

        {/* 新規助成金フォーム */}
        {showNewGrantForm && (
          <div className="bg-white p-6 rounded-lg shadow mb-6">
            <h3 className="text-lg font-medium mb-4">新規助成金</h3>
            <form onSubmit={handleCreateGrant} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  助成金名
                </label>
                <input
                  type="text"
                  value={newGrant.name}
                  onChange={(e) => setNewGrant({ ...newGrant, name: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  助成金コード
                </label>
                <input
                  type="text"
                  value={newGrant.grant_code}
                  onChange={(e) => setNewGrant({ ...newGrant, grant_code: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  総額
                </label>
                <input
                  type="number"
                  value={newGrant.total_amount}
                  onChange={(e) => setNewGrant({ ...newGrant, total_amount: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    開始日
                  </label>
                  <input
                    type="date"
                    value={newGrant.start_date}
                    onChange={(e) => setNewGrant({ ...newGrant, start_date: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    終了日
                  </label>
                  <input
                    type="date"
                    value={newGrant.end_date}
                    onChange={(e) => setNewGrant({ ...newGrant, end_date: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  ステータス
                </label>
                <select
                  value={newGrant.status}
                  onChange={(e) => setNewGrant({ ...newGrant, status: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  <option value="active">実行中</option>
                  <option value="completed">終了</option>
                  <option value="applied">報告済み</option>
                </select>
              </div>
              <div className="flex justify-end space-x-3">
                <button
                  type="button"
                  onClick={() => setShowNewGrantForm(false)}
                  className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
                >
                  キャンセル
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                >
                  作成
                </button>
              </div>
            </form>
          </div>
        )}

        {/* アクティブな助成金カード */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-4">
          {grants
            .filter(g => g.status !== 'applied')
            .sort((a, b) => {
              // 終了期間の順（昇順）でソート
              const dateA = new Date(a.end_date || '9999-12-31');
              const dateB = new Date(b.end_date || '9999-12-31');
              return dateA.getTime() - dateB.getTime();
            })
            .map((grant) => {
            const getStatusColor = (status: string) => {
              switch (status) {
                case 'active': return 'bg-green-100 text-green-800';
                case 'completed': return 'bg-gray-100 text-gray-800';
                case 'applied': return 'bg-blue-100 text-blue-800';
                default: return 'bg-gray-100 text-gray-800';
              }
            };

            const getStatusText = (status: string) => {
              switch (status) {
                case 'active': return '実行中';
                case 'completed': return '終了';
                case 'applied': return '報告済み';
                default: return '不明';
              }
            };

            return (
              <div key={grant.id} className="bg-white p-6 rounded-lg shadow">
                {editingGrantId === grant.id ? (
                  // 編集モード
                  <form onSubmit={handleUpdateGrant} className="space-y-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">助成金名</label>
                      <input
                        type="text"
                        value={editGrant.name}
                        onChange={(e) => setEditGrant({ ...editGrant, name: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">助成金コード</label>
                      <input
                        type="text"
                        value={editGrant.grant_code}
                        onChange={(e) => setEditGrant({ ...editGrant, grant_code: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">総額</label>
                      <input
                        type="number"
                        value={editGrant.total_amount}
                        onChange={(e) => setEditGrant({ ...editGrant, total_amount: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">開始日</label>
                        <input
                          type="date"
                          value={editGrant.start_date}
                          onChange={(e) => setEditGrant({ ...editGrant, start_date: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">終了日</label>
                        <input
                          type="date"
                          value={editGrant.end_date}
                          onChange={(e) => setEditGrant({ ...editGrant, end_date: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">ステータス</label>
                      <select
                        value={editGrant.status}
                        onChange={(e) => setEditGrant({ ...editGrant, status: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      >
                        <option value="active">実行中</option>
                        <option value="completed">終了</option>
                        <option value="applied">報告済み</option>
                      </select>
                    </div>
                    <div className="flex justify-end space-x-3">
                      <button
                        type="button"
                        onClick={cancelEdit}
                        className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
                      >
                        キャンセル
                      </button>
                      <button
                        type="submit"
                        className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                      >
                        更新
                      </button>
                    </div>
                  </form>
                ) : (
                  // 表示モード
                  <>
                    <div className="flex justify-between items-start mb-2">
                      <div>
                        <h3 className="text-lg font-semibold text-gray-900">
                          {grant.name}
                        </h3>
                        <div className="text-xs text-gray-500 space-y-1">
                          <div>ID: {grant.id}</div>
                          {grant.grant_code && (
                            <div>助成金コード: {grant.grant_code}</div>
                          )}
                        </div>
                      </div>
                      <span className={`px-2 py-1 rounded-full text-xs font-medium whitespace-nowrap ${getStatusColor(grant.status || 'active')}`}>
                        {getStatusText(grant.status || 'active')}
                      </span>
                    </div>
                    <div className="space-y-2 text-sm text-gray-600">
                      <div className="flex justify-between">
                        <span>総額:</span>
                        <span className="font-medium">
                          {grant.total_amount?.toLocaleString() || 0}円
                        </span>
                      </div>
                      <div className="flex justify-between">
                        <span>予算配分:</span>
                        <span className="font-medium">
                          {getTotalBudgetedAmount(grant.id).toLocaleString()}円
                        </span>
                      </div>
                      <div className="flex justify-between">
                        <span>割当済み:</span>
                        <span className="font-medium text-blue-600">
                          {getAllocatedAmountForGrant(grant.id).toLocaleString()}円
                        </span>
                      </div>
                      <div className="flex justify-between">
                        <span>残額:</span>
                        <span className={`font-medium ${getRemainingAmountForGrant(grant) > 0 ? 'text-red-600 font-bold' : 'text-gray-900'}`}>
                          {getRemainingAmountForGrant(grant).toLocaleString()}円
                        </span>
                      </div>
                      <div className="flex justify-between">
                        <span>期間:</span>
                        <span>{grant.start_date} ~ {grant.end_date}</span>
                      </div>
                    </div>
                    <div className="mt-4">
                      <div className="flex justify-between items-center">
                        <button
                          onClick={() => setSelectedGrantId(grant.id)}
                          className="text-blue-600 hover:text-blue-800 text-sm font-medium"
                        >
                          予算項目を管理
                        </button>
                        <button
                          onClick={() => startEdit(grant)}
                          className="text-gray-600 hover:text-gray-800 text-sm font-medium"
                        >
                          編集
                        </button>
                      </div>
                    </div>
                  </>
                )}
              </div>
            );
          })}
        </div>

        {/* 報告済み助成金アコーディオン */}
        {grants.filter(g => g.status === 'applied').length > 0 && (
          <div className="mt-8">
            <div
              className="bg-gray-50 p-4 rounded-lg shadow cursor-pointer hover:bg-gray-100 transition-colors"
              onClick={() => setShowReportedGrants(!showReportedGrants)}
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <svg className={`w-5 h-5 transition-transform ${showReportedGrants ? 'rotate-90' : ''}`} fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                  </svg>
                  <h3 className="text-lg font-medium text-gray-700">
                    報告済み助成金 ({grants.filter(g => g.status === 'applied').length}件)
                  </h3>
                </div>
                <span className="text-sm text-gray-500">クリックして{showReportedGrants ? '閉じる' : '開く'}</span>
              </div>
            </div>

            {showReportedGrants && (
              <div className="mt-4 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-4">
                {grants
                  .filter(g => g.status === 'applied')
                  .sort((a, b) => {
                    // 終了期間の順（昇順）でソート
                    const dateA = new Date(a.end_date || '9999-12-31');
                    const dateB = new Date(b.end_date || '9999-12-31');
                    return dateA.getTime() - dateB.getTime();
                  })
                  .map((grant) => {
                  const getStatusColor = (status: string) => {
                    switch (status) {
                      case 'active': return 'bg-green-100 text-green-800';
                      case 'completed': return 'bg-gray-100 text-gray-800';
                      case 'applied': return 'bg-blue-100 text-blue-800';
                      default: return 'bg-gray-100 text-gray-800';
                    }
                  };

                  const getStatusText = (status: string) => {
                    switch (status) {
                      case 'active': return '実行中';
                      case 'completed': return '終了';
                      case 'applied': return '報告済み';
                      default: return '不明';
                    }
                  };

                  return (
                    <div key={grant.id} className="bg-white p-6 rounded-lg shadow">
                      {editingGrantId === grant.id ? (
                        // 編集モード
                        <form onSubmit={handleUpdateGrant} className="space-y-4">
                          <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">助成金名</label>
                            <input
                              type="text"
                              value={editGrant.name}
                              onChange={(e) => setEditGrant({ ...editGrant, name: e.target.value })}
                              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                              required
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">助成金コード</label>
                            <input
                              type="text"
                              value={editGrant.grant_code}
                              onChange={(e) => setEditGrant({ ...editGrant, grant_code: e.target.value })}
                              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                            />
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">総額</label>
                            <input
                              type="number"
                              value={editGrant.total_amount}
                              onChange={(e) => setEditGrant({ ...editGrant, total_amount: e.target.value })}
                              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                            />
                          </div>
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <label className="block text-sm font-medium text-gray-700 mb-1">開始日</label>
                              <input
                                type="date"
                                value={editGrant.start_date}
                                onChange={(e) => setEditGrant({ ...editGrant, start_date: e.target.value })}
                                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                              />
                            </div>
                            <div>
                              <label className="block text-sm font-medium text-gray-700 mb-1">終了日</label>
                              <input
                                type="date"
                                value={editGrant.end_date}
                                onChange={(e) => setEditGrant({ ...editGrant, end_date: e.target.value })}
                                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                              />
                            </div>
                          </div>
                          <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">ステータス</label>
                            <select
                              value={editGrant.status}
                              onChange={(e) => setEditGrant({ ...editGrant, status: e.target.value })}
                              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                            >
                              <option value="active">実行中</option>
                              <option value="completed">終了</option>
                              <option value="applied">報告済み</option>
                            </select>
                          </div>
                          <div className="flex justify-end space-x-3">
                            <button
                              type="button"
                              onClick={cancelEdit}
                              className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
                            >
                              キャンセル
                            </button>
                            <button
                              type="submit"
                              className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                            >
                              更新
                            </button>
                          </div>
                        </form>
                      ) : (
                        // 表示モード
                        <>
                          <div className="flex justify-between items-start mb-2">
                            <div>
                              <h3 className="text-lg font-semibold text-gray-900">
                                {grant.name}
                              </h3>
                              <div className="text-xs text-gray-500 space-y-1">
                                <div>ID: {grant.id}</div>
                                {grant.grant_code && (
                                  <div>助成金コード: {grant.grant_code}</div>
                                )}
                              </div>
                            </div>
                            <span className={`px-2 py-1 rounded-full text-xs font-medium whitespace-nowrap ${getStatusColor(grant.status || 'active')}`}>
                              {getStatusText(grant.status || 'active')}
                            </span>
                          </div>
                          <div className="space-y-2 text-sm text-gray-600">
                            <div className="flex justify-between">
                              <span>総額:</span>
                              <span className="font-medium">
                                {grant.total_amount?.toLocaleString() || 0}円
                              </span>
                            </div>
                            <div className="flex justify-between">
                              <span>予算配分:</span>
                              <span className="font-medium">
                                {getTotalBudgetedAmount(grant.id).toLocaleString()}円
                              </span>
                            </div>
                            <div className="flex justify-between">
                              <span>割当済み:</span>
                              <span className="font-medium text-blue-600">
                                {getAllocatedAmountForGrant(grant.id).toLocaleString()}円
                              </span>
                            </div>
                            <div className="flex justify-between">
                              <span>残額:</span>
                              <span className={`font-medium ${getRemainingAmountForGrant(grant) > 0 ? 'text-red-600 font-bold' : 'text-gray-900'}`}>
                                {getRemainingAmountForGrant(grant).toLocaleString()}円
                              </span>
                            </div>
                            <div className="flex justify-between">
                              <span>期間:</span>
                              <span>{grant.start_date} ~ {grant.end_date}</span>
                            </div>
                          </div>
                          <div className="mt-4">
                            <div className="flex justify-between items-center">
                              <button
                                onClick={() => setSelectedGrantId(grant.id)}
                                className="text-blue-600 hover:text-blue-800 text-sm font-medium"
                              >
                                予算項目を管理
                              </button>
                              <button
                                onClick={() => startEdit(grant)}
                                className="text-gray-600 hover:text-gray-800 text-sm font-medium"
                              >
                                編集
                              </button>
                            </div>
                          </div>
                        </>
                      )}
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        )}
      </div>

      {/* 予算項目管理 */}
      <div>
        <div className="flex justify-between items-center mb-4">
          <div>
            <h2 className="text-lg font-semibold text-gray-900">
              {selectedGrantId ?
                `${grants.find(g => g.id === selectedGrantId)?.name || ''}の予算項目` :
                '予算項目一覧'
              }
              <div className="ml-4 text-sm font-normal flex flex-wrap gap-4">
                <span className="text-gray-600">
                  予算合計: {getDisplayedBudgetTotal().toLocaleString()}円
                </span>
                <span className="text-blue-600">
                  割当合計: {getDisplayedAllocatedTotal().toLocaleString()}円
                </span>
                <span className={`${getDisplayedRemainingTotal() > 0 ? 'text-red-600 font-bold' : 'text-gray-900'}`}>
                  残額合計: {getDisplayedRemainingTotal().toLocaleString()}円
                </span>
              </div>
            </h2>
            {selectedGrantId && (
              <button
                onClick={() => setSelectedGrantId(null)}
                className="text-sm text-blue-600 hover:text-blue-800 mt-1"
              >
                ← 全ての予算項目を表示
              </button>
            )}
          </div>
          <div className="flex gap-2 flex-wrap">
            <button
              onClick={addNewBudgetRow}
              className="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700"
            >
              新規行を追加
            </button>
            <button
              onClick={handleDeleteSelected}
              className="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700"
            >
              選択行を削除
            </button>
            <button
              onClick={() => setShowCategoryManager(!showCategoryManager)}
              className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
            >
              カテゴリ管理
            </button>
          </div>
        </div>

        {/* カテゴリ管理パネル */}
        {showCategoryManager && (
          <div className="bg-white p-6 rounded-lg shadow mb-6">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-medium">カテゴリ管理</h3>
              <button
                onClick={() => setShowCategoryManager(false)}
                className="px-3 py-1 bg-gray-500 text-white rounded-md hover:bg-gray-600 text-sm"
              >
                閉じる
              </button>
            </div>

            {/* 新規カテゴリ追加 */}
            <div className="mb-4">
              <div className="flex gap-2 mb-2">
                <input
                  type="text"
                  value={newCategoryName}
                  onChange={(e) => setNewCategoryName(e.target.value)}
                  placeholder="新しいカテゴリ名"
                  className="flex-1 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  onKeyPress={(e) => e.key === 'Enter' && addCategory()}
                />
                <button
                  onClick={addCategory}
                  className="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700"
                >
                  追加
                </button>
              </div>
              <input
                type="text"
                value={newCategoryDescription}
                onChange={(e) => setNewCategoryDescription(e.target.value)}
                placeholder="説明（オプション）"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            {/* カテゴリ一覧 */}
            <div className="space-y-2">
              <h4 className="font-medium text-gray-700">現在のカテゴリ</h4>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-2">
                {categories.map((category) => (
                  <div key={category.id} className="flex items-center justify-between bg-gray-100 px-3 py-2 rounded">
                    <div className="flex-1">
                      <span className="text-sm font-medium">{category.name}</span>
                      {category.description && (
                        <span className="text-xs text-gray-500 block">{category.description}</span>
                      )}
                    </div>
                    <div className="flex gap-1">
                      <button
                        onClick={() => editCategory(category.id, category.name)}
                        className="text-blue-600 hover:text-blue-800 text-xs"
                      >
                        編集
                      </button>
                      <button
                        onClick={() => deleteCategory(category.id, category.name)}
                        className="text-red-600 hover:text-red-800 text-xs"
                      >
                        削除
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* 報告済みフィルタ */}
        <div className="mb-4">
          <label className="flex items-center">
            <input
              type="checkbox"
              checked={showReportedBudgetItems}
              onChange={(e) => setShowReportedBudgetItems(e.target.checked)}
              className="mr-2"
            />
            <span className="text-sm text-gray-600">報告済みの予算項目を表示</span>
          </label>
        </div>

        {/* 予算項目グリッド */}
        <div style={{ height: '400px', width: '100%' }}>
          <AgGridReact
            key={gridKey} // 強制再描画用キー
            ref={budgetGridRef}
            rowData={(() => {
              const filteredData = budgetItems.filter(item => {
                const grant = grants.find(g => g.id === item.grant_id);
                const isReported = grant?.status === 'applied';
                const result = (!selectedGrantId || item.grant_id === selectedGrantId) && (showReportedBudgetItems || !isReported);
                return result;
              });
              console.log('🔍 AG-Grid表示データ:', filteredData.length, '件');
              console.log('🔍 表示データ詳細 (最初の3件):', filteredData.slice(0, 3));
              return filteredData;
            })()}
            columnDefs={budgetColumnDefs}
            className="ag-theme-alpine"
            defaultColDef={{
              sortable: true,
              filter: true,
              resizable: true,
              floatingFilter: true,
              minWidth: 100
            }}
            rowHeight={28}
            suppressHorizontalScroll={false}
            rowSelection={{
              mode: 'multiRow',
              checkboxes: true,
              headerCheckbox: true
            }}
            onCellValueChanged={onBudgetCellValueChanged}
            getRowId={(params) => params.data.id.toString()} // 行IDを明示的に設定
            suppressClickEdit={false} // 編集を有効にする
            stopEditingWhenCellsLoseFocus={true} // フォーカスが外れたら編集を終了
            localeText={{
              filterOoo: 'フィルター...',
              equals: '等しい',
              notEqual: '等しくない',
              contains: '含む',
              notContains: '含まない',
              startsWith: 'で始まる',
              endsWith: 'で終わる',
              noRowsToShow: '表示するデータがありません'
            }}
          />
        </div>
      </div>

      {/* CSVプレビューモーダル */}
      {showPreview && previewData && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-xl max-w-4xl w-full mx-4 max-h-[80vh] overflow-hidden">
            <div className="p-6 border-b">
              <h3 className="text-lg font-semibold">CSVインポートプレビュー</h3>
              <p className="text-sm text-gray-600 mt-1">
                ファイル: {previewData.file_name} ({previewData.total_rows}件のデータ)
              </p>
            </div>

            <div className="p-6 overflow-y-auto max-h-[60vh]">
              {previewData.preview && previewData.preview.length > 0 ? (
                <div className="space-y-4">
                  {['助成金', '予算項目', '割当'].map(section => {
                    const sectionData = previewData.preview.filter((item: any) => item.section === section);
                    if (sectionData.length === 0) return null;

                    return (
                      <div key={section} className="border rounded-lg overflow-hidden">
                        <div className="bg-gray-50 px-4 py-2 border-b">
                          <h4 className="font-medium">{section}データ ({sectionData.length}件)</h4>
                        </div>
                        <div className="overflow-x-auto">
                          <table className="w-full text-sm">
                            <thead className="bg-gray-100">
                              <tr>
                                <th className="px-3 py-2 text-left">行番号</th>
                                {sectionData[0] && Object.keys(sectionData[0].data).map((key: string) => (
                                  <th key={key} className="px-3 py-2 text-left">{key}</th>
                                ))}
                              </tr>
                            </thead>
                            <tbody>
                              {sectionData.map((item: any, index: number) => (
                                <tr key={index} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                                  <td className="px-3 py-2">{item.row_number}</td>
                                  {Object.values(item.data).map((value: any, idx: number) => (
                                    <td key={idx} className="px-3 py-2">{value}</td>
                                  ))}
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                      </div>
                    );
                  })}
                </div>
              ) : (
                <p className="text-gray-500">プレビューデータがありません</p>
              )}
            </div>

            <div className="p-6 border-t bg-gray-50 flex justify-end space-x-3">
              <button
                onClick={handleCancelImport}
                className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
              >
                キャンセル
              </button>
              <button
                onClick={handleConfirmImport}
                className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
              >
                インポート実行
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default GrantsPage;