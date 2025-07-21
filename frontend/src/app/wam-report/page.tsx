'use client';

import React, { useState, useEffect, useRef } from 'react';
import { AgGridReact } from 'ag-grid-react';
import { ColDef, ModuleRegistry, AllCommunityModule, GridApi } from 'ag-grid-community';
import { api, Grant } from '@/lib/api';
import { API_CONFIG } from '@/lib/config';

interface WamData {
  支出年月日: string;
  科目: string;
  支払いの相手方: string;
  摘要: string;
  金額: number;
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

  useEffect(() => {
    ModuleRegistry.registerModules([AllCommunityModule]);
    loadInitialData();
  }, []);

  const loadInitialData = async () => {
    try {
      const [grantsData, categoriesData, mappingsData] = await Promise.all([
        api.getGrants(),
        fetchWamCategories(),
        fetchWamMappings()
      ]);
      setGrants(grantsData);
      setCategories(categoriesData);
      setMappings(mappingsData);
      
      // デフォルト期間設定
      const now = new Date();
      const currentYear = now.getFullYear();
      setStartDate(`${currentYear}-04-01`);
      setEndDate(`${currentYear + 1}-03-31`);
    } catch (error) {
      console.error('Failed to load initial data:', error);
      alert('初期データの読み込みに失敗しました');
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
      }

      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-report/data?${params}`);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      
      const result = await response.json();
      setWamData(result.data);
    } catch (error) {
      console.error('Failed to load WAM data:', error);
      alert('WAMデータの読み込みに失敗しました');
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

  const createMapping = async () => {
    if (!newMapping.account_pattern || !newMapping.wam_category) {
      alert('勘定科目パターンとWAM科目を入力してください');
      return;
    }

    try {
      const response = await fetch(`${API_CONFIG.BASE_URL}/api/wam-mappings`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newMapping)
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
    { field: '_original_account', headerName: '元勘定科目', width: 150, sortable: true }
  ];

  const mappingColumnDefs: ColDef[] = [
    { field: 'account_pattern', headerName: '勘定科目パターン', width: 200, editable: true },
    { 
      field: 'wam_category', 
      headerName: 'WAM科目', 
      width: 150, 
      editable: true,
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: { values: categories }
    },
    { field: 'priority', headerName: '優先順位', width: 100, editable: true },
    { 
      field: 'is_active', 
      headerName: '有効', 
      width: 80,
      cellRenderer: (params: any) => params.value ? '✓' : '✗',
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
          className="text-red-600 hover:text-red-800 text-sm"
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
          取引データをWAM報告書形式に変換し、CSVエクスポートします。
        </p>
      </div>

      {/* 期間設定とフィルター */}
      <div className="bg-white p-6 rounded-lg shadow mb-6">
        <h3 className="text-lg font-medium mb-4">期間・条件設定</h3>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
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
            <label className="block text-sm font-medium text-gray-700 mb-1">助成金</label>
            <select
              value={selectedGrantId || ''}
              onChange={(e) => setSelectedGrantId(e.target.value ? parseInt(e.target.value) : null)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">全助成金</option>
              {grants.map(grant => (
                <option key={grant.id} value={grant.id}>{grant.name}</option>
              ))}
            </select>
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
          onClick={() => setShowMappings(!showMappings)}
          className="px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700"
        >
          {showMappings ? 'マッピング設定を閉じる' : 'マッピング設定'}
        </button>
      </div>

      {/* マッピング設定 */}
      {showMappings && (
        <div className="bg-white p-6 rounded-lg shadow mb-6">
          <h3 className="text-lg font-medium mb-4">WAM科目マッピング設定</h3>
          
          {/* 新規マッピング作成 */}
          <div className="mb-4 p-4 bg-gray-50 rounded">
            <h4 className="font-medium mb-2">新規マッピングルール作成</h4>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <input
                type="text"
                placeholder="勘定科目パターン"
                value={newMapping.account_pattern}
                onChange={(e) => setNewMapping({...newMapping, account_pattern: e.target.value})}
                className="px-3 py-2 border border-gray-300 rounded-md"
              />
              <select
                value={newMapping.wam_category}
                onChange={(e) => setNewMapping({...newMapping, wam_category: e.target.value})}
                className="px-3 py-2 border border-gray-300 rounded-md"
              >
                <option value="">WAM科目を選択</option>
                {categories.map(category => (
                  <option key={category} value={category}>{category}</option>
                ))}
              </select>
              <input
                type="number"
                placeholder="優先順位"
                value={newMapping.priority}
                onChange={(e) => setNewMapping({...newMapping, priority: parseInt(e.target.value) || 1})}
                className="px-3 py-2 border border-gray-300 rounded-md"
              />
              <button
                onClick={createMapping}
                className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
              >
                作成
              </button>
            </div>
          </div>

          {/* マッピングルール一覧 */}
          <div className="ag-theme-alpine" style={{ height: 300 }}>
            <AgGridReact
              columnDefs={mappingColumnDefs}
              rowData={mappings}
              onCellValueChanged={onMappingCellValueChanged}
              suppressRowClickSelection={true}
            />
          </div>
        </div>
      )}

      {/* WAMデータ表示 */}
      <div className="bg-white p-6 rounded-lg shadow">
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-lg font-medium">WAM報告書データ</h3>
          <span className="text-sm text-gray-600">
            {wamData.length}件のデータ
          </span>
        </div>
        
        <div className="ag-theme-alpine" style={{ height: 600 }}>
          <AgGridReact
            ref={gridRef}
            columnDefs={wamColumnDefs}
            rowData={wamData}
            suppressRowClickSelection={true}
            enableRangeSelection={true}
            pagination={true}
            paginationPageSize={50}
          />
        </div>
      </div>
    </div>
  );
};

export default WamReportPage; 