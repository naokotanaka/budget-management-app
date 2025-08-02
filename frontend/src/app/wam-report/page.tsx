'use client';

import React, { useState, useEffect, useRef } from 'react';
import { AgGridReact } from 'ag-grid-react';
import { ColDef, GridApi, ModuleRegistry, AllCommunityModule } from 'ag-grid-community';
import { api, Grant } from '@/lib/api';
import { API_CONFIG } from '@/lib/config';



interface WamData {
  支出年月日: string;
  科目: string;
  支払いの相手方: string;
  摘要: string;
  金額: number;
  管理番号?: string;
  _original_transaction_id?: string;
  _original_account?: string;
  _auto_mapped?: boolean;
}

interface WamMapping {
  id: number;
  account_pattern: string;
  wam_category: string;
  priority: number;
  is_active: boolean;
}

const WamReportPage: React.FC = () => {
  const [wamData, setWamData] = useState<WamData[]>([]);
  const [grants, setGrants] = useState<Grant[]>([]);
  const [mappings, setMappings] = useState<WamMapping[]>([]);
  const [categories, setCategories] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [gridReady, setGridReady] = useState(false);
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [selectedGrantId, setSelectedGrantId] = useState<number | null>(null);
  const [showMappings, setShowMappings] = useState(false);
  const [newMapping, setNewMapping] = useState({
    account_pattern: '',
    wam_category: '',
    priority: 1,
    is_active: true
  });

  const gridRef = useRef<AgGridReact>(null);

  // Register AG Grid modules and load data on mount
  useEffect(() => {
    // Register AG Grid modules
    ModuleRegistry.registerModules([AllCommunityModule]);

    // Mark grid as ready
    setGridReady(true);

    loadInitialData();
    
    // ローカルストレージから保存された助成金IDを復元
    const savedGrantId = localStorage.getItem('wam_selected_grant_id');
    if (savedGrantId && savedGrantId !== 'null') {
      setSelectedGrantId(parseInt(savedGrantId));
    }
  }, []);

  const loadInitialData = async () => {
    try {
      const [grantsData, categoriesData, mappingsData] = await Promise.all([
        api.getGrants(),
        fetchWamCategories(),
        fetchWamMappings()
      ]);
      
      // WAMが含まれる助成金のみフィルタリング
      const wamGrants = grantsData.filter(grant => 
        grant.grant_code && grant.grant_code.toUpperCase().includes('WAM')
      );
      
      setGrants(wamGrants);
      setCategories(categoriesData);
      setMappings(mappingsData);
      
      // デフォルト期間設定
      const now = new Date();
      const currentYear = now.getFullYear();
      const defaultStartDate = `${currentYear}-04-01`;
      const defaultEndDate = `${currentYear + 1}-03-31`;
      setStartDate(defaultStartDate);
      setEndDate(defaultEndDate);

      // 最初のWAM助成金を自動選択（ローカルストレージの値がない場合）
      const savedGrantId = localStorage.getItem('wam_selected_grant_id');
      if (!savedGrantId && wamGrants.length > 0) {
        setSelectedGrantId(wamGrants[0].id);
        localStorage.setItem('wam_selected_grant_id', wamGrants[0].id.toString());
      }

      // 初期データを自動で読み込み（選択された助成金で）
      const initialGrantId = savedGrantId ? parseInt(savedGrantId) : (wamGrants.length > 0 ? wamGrants[0].id : null);
      await loadInitialWamData(defaultStartDate, defaultEndDate, initialGrantId);
    } catch (error) {
      console.error('Failed to load initial data:', error);
      alert('初期データの読み込みに失敗しました');
    }
  };

  const loadInitialWamData = async (start: string, end: string, grantId: number | null = null) => {
    try {
      setLoading(true);
      const params = new URLSearchParams({
        start_date: start,
        end_date: end
      });

      if (grantId) {
        params.append('grant_id', grantId.toString());
      }

      console.log('Initial WAM Data Request:', `${API_CONFIG.BASE_URL}/api/wam-report/data?${params}`);

      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-report/data?${params}`);
      if (!response.ok) {
        const errorText = await response.text();
        console.warn(`Initial WAM data load failed: HTTP ${response.status}: ${errorText}`);
        return; // 初期読み込み失敗は警告のみで続行
      }
      
      const result = await response.json();
      console.log('Initial WAM Data Response:', result);
      setWamData(result.data || []);
    } catch (error: any) {
      console.warn('Failed to load initial WAM data:', error);
      // 初期読み込み失敗はエラーダイアログを表示せず、コンソール警告のみ
    } finally {
      setLoading(false);
    }
  };

  const fetchWamCategories = async (): Promise<string[]> => {
    try {
      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-report/categories`);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const result = await response.json();
      return result.categories;
    } catch (error) {
      console.error('Failed to fetch WAM categories:', error);
      return [];
    }
  };

  const fetchWamMappings = async (): Promise<WamMapping[]> => {
    try {
      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-mappings`);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const result = await response.json();
      return result.mappings;
    } catch (error) {
      console.error('Failed to fetch WAM mappings:', error);
      return [];
    }
  };

  const loadWamData = async () => {
    if (!startDate || !endDate) {
      alert('開始日と終了日を設定してください');
      return;
    }

    try {
      setLoading(true);
      const params = new URLSearchParams({
        start_date: startDate,
        end_date: endDate
      });
      
      if (selectedGrantId) {
        params.append('grant_id', selectedGrantId.toString());
        // 助成金IDをローカルストレージに保存
        localStorage.setItem('wam_selected_grant_id', selectedGrantId.toString());
      } else {
        localStorage.removeItem('wam_selected_grant_id');
      }

      console.log('WAM API Request:', `${API_CONFIG.BASE_URL}/api/wam-report/data?${params}`);

      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-report/data?${params}`);
      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`HTTP ${response.status}: ${errorText}`);
      }
      
      const result = await response.json();
      console.log('WAM Data Response:', result);
      setWamData(result.data || []);
    } catch (error: any) {
      console.error('Failed to load WAM data:', error);
      alert(`WAMデータの読み込みに失敗しました: ${error?.message || 'Unknown error'}`);
    } finally {
      setLoading(false);
    }
  };

  const exportWamCsv = async () => {
    if (wamData.length === 0) {
      alert('エクスポートするデータがありません');
      return;
    }

    try {
      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-report/export`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(wamData)
      });

      if (!response.ok) throw new Error(`HTTP ${response.status}`);

      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `wam_report_${new Date().toISOString().split('T')[0]}.csv`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
      
      alert('WAM報告書CSVをエクスポートしました');
    } catch (error) {
      console.error('Export failed:', error);
      alert('エクスポートに失敗しました');
    }
  };

  const applyAutoMapping = async () => {
    if (wamData.length === 0) {
      alert('WAMデータが読み込まれていません。まず「データ取得」を実行してください。');
      return;
    }

    if (!confirm('科目マスターを元に、すべてのWAM科目を自動設定しますか？\n現在の科目設定は上書きされます。')) {
      return;
    }

    try {
      setLoading(true);
      
      // 現在のWAMデータを再処理して自動マッピングを適用
      const params = new URLSearchParams({
        start_date: startDate,
        end_date: endDate,
        force_remap: 'true'  // 強制的に再マッピングを実行
      });
      
      if (selectedGrantId) {
        params.append('grant_id', selectedGrantId.toString());
      }

      console.log('Auto Mapping Request:', `${API_CONFIG.BASE_URL}/api/wam-report/data?${params}`);

      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-report/data?${params}`);
      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`HTTP ${response.status}: ${errorText}`);
      }
      
      const result = await response.json();
      console.log('Auto Mapping Response:', result);
      setWamData(result.data || []);
      
      alert(`科目マスターを元に${result.data?.length || 0}件のWAM科目を自動設定しました。`);
    } catch (error: any) {
      console.error('Failed to apply auto mapping:', error);
      alert(`自動科目設定に失敗しました: ${error?.message || 'Unknown error'}`);
    } finally {
      setLoading(false);
    }
  };

  // 科目マスターのエクスポート
  const exportMappings = () => {
    try {
      const exportData = {
        version: '1.0',
        exported_at: new Date().toISOString(),
        mappings: mappings.map(mapping => ({
          account_pattern: mapping.account_pattern,
          wam_category: mapping.wam_category,
          priority: mapping.priority,
          is_active: mapping.is_active,
          description: (mapping as any).description || ''
        }))
      };

      const dataStr = JSON.stringify(exportData, null, 2);
      const dataBlob = new Blob([dataStr], { type: 'application/json' });
      const url = URL.createObjectURL(dataBlob);
      
      const link = document.createElement('a');
      link.href = url;
      link.download = `wam_mappings_${new Date().toISOString().split('T')[0]}.json`;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);
      
      alert('科目マスターをエクスポートしました');
    } catch (error: any) {
      alert(`エクスポートに失敗しました: ${error?.message || 'Unknown error'}`);
    }
  };

  // 科目マスターのインポート
  const handleImportMappings = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    try {
      const text = await file.text();
      const importData = JSON.parse(text);
      
      // バリデーション
      if (!importData.mappings || !Array.isArray(importData.mappings)) {
        throw new Error('無効なファイル形式です');
      }

      // 確認ダイアログ
      const confirmMessage = `${importData.mappings.length}件の科目マッピングをインポートします。\n既存のデータは置き換えられます。よろしいですか？`;
      if (!confirm(confirmMessage)) {
        return;
      }

      setLoading(true);

      // 既存のマッピングを削除
      for (const mapping of mappings) {
        await fetch(`${API_CONFIG.BASE_URL}/api/wam-mappings/${mapping.id}`, {
          method: 'DELETE'
        });
      }

      // 新しいマッピングを作成
      const createdMappings = [];
      for (const mappingData of importData.mappings) {
        const formData = new FormData();
        formData.append('account_pattern', mappingData.account_pattern || '');
        formData.append('wam_category', mappingData.wam_category || '');
        formData.append('priority', mappingData.priority?.toString() || '1');
        formData.append('is_active', mappingData.is_active?.toString() || 'true');
        formData.append('description', mappingData.description || '');

        const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-mappings`, {
          method: 'POST',
          body: formData
        });

        if (response.ok) {
          const newMapping = await response.json();
          createdMappings.push(newMapping);
        }
      }

      setMappings(createdMappings);
      alert(`${createdMappings.length}件の科目マッピングをインポートしました`);
      
    } catch (error: any) {
      alert(`インポートに失敗しました: ${error?.message || 'Unknown error'}`);
    } finally {
      setLoading(false);
      // ファイル入力をリセット
      event.target.value = '';
    }
  };

  const createMapping = async () => {
    if (!newMapping.account_pattern || !newMapping.wam_category) {
      alert('勘定科目パターンとWAM科目を入力してください');
      return;
    }

    try {
      const formData = new FormData();
      formData.append('account_pattern', newMapping.account_pattern);
      formData.append('wam_category', newMapping.wam_category);
      formData.append('priority', newMapping.priority.toString());

      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-mappings`, {
        method: 'POST',
        body: formData
      });

      if (!response.ok) throw new Error(`HTTP ${response.status}`);

      setNewMapping({ account_pattern: '', wam_category: '', priority: 1, is_active: true });
      const updatedMappings = await fetchWamMappings();
      setMappings(updatedMappings);
      alert('マッピングルールを作成しました');
    } catch (error) {
      console.error('Failed to create mapping:', error);
      alert('マッピングルールの作成に失敗しました');
    }
  };

  const updateMapping = async (id: number, updates: Partial<WamMapping>) => {
    try {
      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-mappings/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(updates)
      });

      if (!response.ok) throw new Error(`HTTP ${response.status}`);

      const updatedMappings = await fetchWamMappings();
      setMappings(updatedMappings);
    } catch (error) {
      console.error('Failed to update mapping:', error);
      alert('マッピングルールの更新に失敗しました');
    }
  };

  const deleteMapping = async (id: number) => {
    if (!confirm('このマッピングルールを削除しますか？')) return;

    try {
      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-mappings/${id}`, {
        method: 'DELETE'
      });

      if (!response.ok) throw new Error(`HTTP ${response.status}`);

      const updatedMappings = await fetchWamMappings();
      setMappings(updatedMappings);
      alert('マッピングルールを削除しました');
    } catch (error) {
      console.error('Failed to delete mapping:', error);
      alert('マッピングルールの削除に失敗しました');
    }
  };

  const wamColumnDefs: ColDef[] = [
    { field: '支出年月日', headerName: '支出年月日', width: 120, sortable: true },
    { 
      field: '科目', 
      headerName: 'WAM科目', 
      width: 150, 
      sortable: true,
      editable: true,
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: { values: categories }
    },
    { field: '支払いの相手方', headerName: '支払先', width: 200, sortable: true, editable: true },
    { field: '摘要', headerName: '摘要', width: 250, sortable: true, editable: true },
    { 
      field: '金額', 
      headerName: '金額', 
      width: 120, 
      sortable: true,
      valueFormatter: (params) => params.value ? `¥${params.value.toLocaleString()}` : ''
    },
    { field: '管理番号', headerName: '管理番号', width: 120, sortable: true, editable: true },
    { field: '_original_account', headerName: '元勘定科目', width: 150, sortable: true },
    { 
      field: '_auto_mapped', 
      headerName: '自動設定', 
      width: 100, 
      cellRenderer: (params: any) => (
        <span className={params.value ? 'text-green-600' : 'text-gray-400'}>
          {params.value ? '✓' : '✗'}
        </span>
      ),
      tooltipValueGetter: (params: any) => 
        params.value ? '科目マスターにより自動設定' : '手動設定'
    }
  ];

  const mappingColumnDefs: ColDef[] = [
    { 
      field: 'account_pattern', 
      headerName: 'freee勘定科目', 
      width: 220, 
      editable: true,
      tooltipField: 'account_pattern'
    },
    { 
      field: 'wam_category', 
      headerName: 'WAM科目', 
      width: 180, 
      editable: true,
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: { values: categories },
      tooltipField: 'wam_category'
    },
    { 
      field: 'priority', 
      headerName: '優先順位', 
      width: 100, 
      editable: true,
      cellEditor: 'agNumericCellEditor',
      cellEditorParams: { min: 1, max: 999 }
    },
    { 
      field: 'is_active', 
      headerName: '有効', 
      width: 80,
      cellRenderer: (params: any) => (
        <span className={params.value ? 'text-green-600' : 'text-gray-400'}>
          {params.value ? '✓' : '✗'}
        </span>
      ),
      editable: true,
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: { values: [true, false] }
    },
    {
      headerName: '操作',
      width: 100,
      cellRenderer: (params: any) => (
        <button
          onClick={() => deleteMapping(params.data.id)}
          className="text-red-600 hover:text-red-800 text-sm px-2 py-1 rounded hover:bg-red-50"
          title="この科目マッピングを削除"
        >
          削除
        </button>
      )
    }
  ];

  const onMappingCellValueChanged = (params: any) => {
    const { data, colDef, newValue } = params;
    const field = colDef.field;
    updateMapping(data.id, { [field]: newValue });
  };

  return (
    <div className="container mx-auto p-6 max-w-7xl">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">WAM助成金報告書作成</h1>
        <p className="text-gray-600">
          取引データをWAM報告書形式に変換し、CSVエクスポートします。<br/>
          期間を設定後「データ取得」で更新、「自動科目設定」で科目マスターを適用できます。
        </p>
      </div>

      {/* 期間設定とフィルター */}
      <div className="bg-white p-6 rounded-lg shadow mb-6">
        <h3 className="text-lg font-medium mb-4">期間・条件設定</h3>
        <div className="grid grid-cols-1 md:grid-cols-5 gap-4 items-end">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">開始日</label>
            <input
              type="date"
              value={startDate}
              onChange={(e) => setStartDate(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">終了日</label>
            <input
              type="date"
              value={endDate}
              onChange={(e) => setEndDate(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">WAM助成金</label>
            <select
              value={selectedGrantId || ''}
              onChange={(e) => setSelectedGrantId(e.target.value ? parseInt(e.target.value) : null)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              {grants.map(grant => (
                <option key={grant.id} value={grant.id}>
                  {grant.grant_code}
                </option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">助成金ID</label>
            <input
              type="number"
              value={selectedGrantId || ''}
              onChange={(e) => setSelectedGrantId(e.target.value ? parseInt(e.target.value) : null)}
              placeholder="IDを直接入力"
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <div>
            <button
              onClick={loadWamData}
              disabled={loading}
              className="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50"
            >
              {loading ? '読み込み中...' : 'データ取得'}
            </button>
          </div>
        </div>
      </div>

      {/* アクションボタン */}
      <div className="flex gap-4 mb-6">
        <button
          onClick={exportWamCsv}
          disabled={wamData.length === 0}
          className="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 disabled:opacity-50"
        >
          CSV出力
        </button>
        <button
          onClick={applyAutoMapping}
          disabled={loading}
          className="px-4 py-2 bg-orange-600 text-white rounded-md hover:bg-orange-700 disabled:opacity-50"
        >
          {loading ? '自動科目設定中...' : '自動科目設定'}
        </button>
        <button
          onClick={() => setShowMappings(!showMappings)}
          className="px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700"
        >
          {showMappings ? '科目マスター設定を閉じる' : '科目マスター設定'}
        </button>
      </div>

      {/* 科目マスター設定 */}
      {showMappings && (
        <div className="bg-white p-6 rounded-lg shadow mb-6">
          <div className="flex justify-between items-center mb-4">
            <div>
              <h3 className="text-lg font-medium">科目マスター設定</h3>
              <p className="text-sm text-gray-600 mt-1">
                freeeの勘定科目をWAM報告書の科目に自動変換するためのマッピングルールを設定します。
              </p>
            </div>
            <div className="flex gap-2">
              <button
                onClick={exportMappings}
                className="px-3 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 text-sm"
              >
                エクスポート
              </button>
              <label className="px-3 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 text-sm cursor-pointer">
                インポート
                <input
                  type="file"
                  accept=".json"
                  onChange={handleImportMappings}
                  className="hidden"
                />
              </label>
            </div>
          </div>
          
          {/* 新規マッピング作成 */}
          <div className="mb-4 p-4 bg-gray-50 rounded">
            <h4 className="font-medium mb-2">新規科目マッピング作成</h4>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">freee勘定科目</label>
                <input
                  type="text"
                  placeholder="例: 給与手当、旅費交通費"
                  value={newMapping.account_pattern}
                  onChange={(e) => setNewMapping({...newMapping, account_pattern: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">WAM科目</label>
                <select
                  value={newMapping.wam_category}
                  onChange={(e) => setNewMapping({...newMapping, wam_category: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  <option value="">WAM科目を選択</option>
                  {categories.map(category => (
                    <option key={category} value={category}>{category}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">優先順位</label>
                <input
                  type="number"
                  placeholder="1-999"
                  min="1"
                  max="999"
                  value={newMapping.priority}
                  onChange={(e) => setNewMapping({...newMapping, priority: parseInt(e.target.value) || 1})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="flex items-end">
                <button
                  onClick={createMapping}
                  className="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  作成
                </button>
              </div>
            </div>
          </div>

          {/* 科目マスター一覧 */}
          <div className="mb-2">
            <h4 className="font-medium text-gray-900">登録済み科目マッピング一覧</h4>
            <p className="text-sm text-gray-600">
              優先順位が小さいほど優先されます。セルをクリックして直接編集できます。
            </p>
          </div>
          <div className="ag-theme-alpine" style={{ height: 400 }}>
            {gridReady ? (
              <AgGridReact
                columnDefs={mappingColumnDefs}
                rowData={mappings}
                onCellValueChanged={onMappingCellValueChanged}
                suppressRowClickSelection={true}
                pagination={true}
                paginationPageSize={20}
                defaultColDef={{
                  resizable: true,
                  sortable: true,
                  filter: true
                }}
              />
            ) : (
              <div className="flex items-center justify-center h-full">
                <div className="text-gray-500">科目マスターを読み込み中...</div>
              </div>
            )}
          </div>
        </div>
      )}

      {/* WAMデータ表示 */}
      <div className="bg-white p-6 rounded-lg shadow">
        <div className="flex justify-between items-center mb-4">
          <div>
            <h3 className="text-lg font-medium">WAM報告書データ</h3>
            {selectedGrantId && (
              <p className="text-sm text-gray-600">
                助成金: {grants.find(g => g.id === selectedGrantId)?.grant_code || 'Unknown'}
              </p>
            )}
          </div>
          <span className="text-sm text-gray-600">
            {wamData.length}件のデータ
          </span>
        </div>
        
        <div className="ag-theme-alpine" style={{ height: 600, width: '100%' }}>
          {gridReady ? (
            <AgGridReact
              ref={gridRef}
              columnDefs={wamColumnDefs}
              rowData={wamData}
              suppressRowClickSelection={true}
              pagination={true}
              paginationPageSize={50}
              defaultColDef={{
                resizable: true,
                sortable: true,
                filter: true
              }}
            />
          ) : (
            <div className="flex items-center justify-center h-full">
              <div className="text-gray-500">グリッドを初期化中...</div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default WamReportPage; 