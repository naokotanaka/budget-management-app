'use client';

import React, { useState, useEffect, useMemo, useRef } from 'react';
import { AgGridReact } from 'ag-grid-react';
import { ColDef } from 'ag-grid-community';
import { api } from '@/lib/api';
import { CONFIG } from '@/lib/config';
import '@/lib/ag-grid-setup';

interface WamReportItem {
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
  const [wamData, setWamData] = useState<WamReportItem[]>([]);
  const [wamCategories, setWamCategories] = useState<string[]>([]);
  const [selectedGrantId, setSelectedGrantId] = useState<number>(() => {
    // ローカルストレージから前回の値を取得、なければ1をデフォルト
    if (typeof window !== 'undefined') {
      return parseInt(localStorage.getItem('selectedGrantId') || '1');
    }
    return 1;
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [startDate, setStartDate] = useState<string>(CONFIG.DEFAULT_DATE_RANGE.START);
  const [endDate, setEndDate] = useState<string>(CONFIG.DEFAULT_DATE_RANGE.END);
  const [exporting, setExporting] = useState(false);
  const [showMappingSettings, setShowMappingSettings] = useState(false);
  const [mappings, setMappings] = useState<WamMapping[]>([]);
  const [accountPatterns, setAccountPatterns] = useState<string[]>([]);
  const [editingMapping, setEditingMapping] = useState<number | null>(null);
  const [importing, setImporting] = useState(false);
  const [newMapping, setNewMapping] = useState({
    account_pattern: '',
    wam_category: '賃金（職員）',
    priority: 100
  });
  const gridRef = useRef<AgGridReact>(null);

  useEffect(() => {
    loadWamCategories();
    loadWamData();
  }, []);

  useEffect(() => {
    if (showMappingSettings) {
      loadMappings();
      loadAccountPatterns();
    }
  }, [showMappingSettings]);

  const loadWamCategories = async () => {
    try {
      const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
        (process.env.NODE_ENV === 'production' 
          ? 'http://160.251.170.97:8000'  // 本番環境
          : 'http://160.251.170.97:8001'  // 開発環境
        );
      const response = await fetch(`${API_BASE_URL}/api/wam-report/categories`);
      const data = await response.json();
      setWamCategories(data.categories);
    } catch (error) {
      console.error('Failed to load WAM categories:', error);
    }
  };

  const loadWamData = async () => {
    if (!startDate || !endDate) return;

    try {
      setLoading(true);
      setError(null);
      
      const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
        (process.env.NODE_ENV === 'production' 
          ? 'http://160.251.170.97:8000'  // 本番環境
          : 'http://160.251.170.97:8001'  // 開発環境
        );
      const params = new URLSearchParams({
        start_date: startDate,
        end_date: endDate
      });
      
      // 常に助成金ID=1を指定
      params.append('grant_id', selectedGrantId.toString());
      
      const response = await fetch(
        `${API_BASE_URL}/api/wam-report/data?${params.toString()}`
      );
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      
      const result = await response.json();
      setWamData(result.data);
    } catch (err) {
      console.error('Failed to load WAM data:', err);
      setError(err instanceof Error ? err.message : 'データの読み込みに失敗しました');
    } finally {
      setLoading(false);
    }
  };

  const handleExportCSV = async () => {
    try {
      setExporting(true);
      
      const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
        (process.env.NODE_ENV === 'production' 
          ? 'http://160.251.170.97:8000'  // 本番環境
          : 'http://160.251.170.97:8001'  // 開発環境
        );
      const response = await fetch(`${API_BASE_URL}/api/wam-report/export`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(wamData),
      });
      
      if (!response.ok) {
        throw new Error('CSV出力に失敗しました');
      }
      
      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      
      const timestamp = new Date().toISOString().slice(0, 19).replace(/[-:T]/g, '');
      a.download = `wam_report_${timestamp}.csv`;
      
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    } catch (error) {
      console.error('Export failed:', error);
      alert('CSV出力に失敗しました');
    } finally {
      setExporting(false);
    }
  };

  const columnDefs: ColDef[] = useMemo(() => [
    {
      field: '支出年月日',
      headerName: '支出年月日',
      filter: 'agDateColumnFilter',
      editable: true,
      width: 120,
      minWidth: 100,
      pinned: 'left'
    },
    {
      field: '科目',
      headerName: '科目',
      filter: 'agTextColumnFilter',
      editable: true,
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: {
        values: wamCategories
      },
      width: 150,
      minWidth: 120,
      cellStyle: (params) => {
        // 自動推測された項目は背景色を変更
        return params.data._auto_mapped ? { backgroundColor: '#e3f2fd' } : undefined;
      }
    },
    {
      field: '支払いの相手方',
      headerName: '支払いの相手方',
      filter: 'agTextColumnFilter',
      editable: true,
      width: 200,
      minWidth: 150
    },
    {
      field: '摘要',
      headerName: '摘要',
      filter: 'agTextColumnFilter',
      editable: true,
      width: 300,
      minWidth: 200,
      tooltipField: '摘要'
    },
    {
      field: '金額',
      headerName: '金額',
      filter: 'agNumberColumnFilter',
      editable: true,
      valueFormatter: (params) => params.value?.toLocaleString() || '0',
      cellClass: 'text-right',
      width: 120,
      minWidth: 100
    },
    {
      field: '_original_account',
      headerName: '元勘定科目',
      filter: 'agTextColumnFilter',
      width: 150,
      minWidth: 120,
      cellStyle: { color: '#666', fontSize: '12px' }
    }
  ], [wamCategories]);

  const loadAccountPatterns = async () => {
    try {
      const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
        (process.env.NODE_ENV === 'production' 
          ? 'http://160.251.170.97:8000'
          : 'http://160.251.170.97:8001'
        );
      
      const response = await fetch(`${API_BASE_URL}/api/account-patterns`);
      
      if (!response.ok) {
        if (response.status === 404) {
          setAccountPatterns([]);
          return;
        }
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      
      const result = await response.json();
      console.log('Account patterns response:', result); // デバッグ用
      setAccountPatterns(result.clean_accounts || []);
      console.log('Set account patterns:', result.clean_accounts || []); // デバッグ用
    } catch (err) {
      console.error('Failed to load account patterns:', err);
      setAccountPatterns([]);
    }
  };

  const loadMappings = async () => {
    try {
      const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
        (process.env.NODE_ENV === 'production' 
          ? 'http://160.251.170.97:8000'
          : 'http://160.251.170.97:8001'
        );
      
      const response = await fetch(`${API_BASE_URL}/api/wam-mappings`);
      
      if (!response.ok) {
        // 404の場合は空の配列を設定（APIが未実装の場合）
        if (response.status === 404) {
          setMappings([]);
          return;
        }
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      
      const result = await response.json();
      setMappings(result.mappings || []);
    } catch (err) {
      console.error('Failed to load WAM mappings:', err);
      setMappings([]);
    }
  };

  const handleCreateMapping = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!newMapping.account_pattern.trim() || !newMapping.wam_category) {
      alert('勘定科目パターンとWAM科目を入力してください');
      return;
    }

    try {
      const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
        (process.env.NODE_ENV === 'production' 
          ? 'http://160.251.170.97:8000'
          : 'http://160.251.170.97:8001'
        );

      const formData = new FormData();
      formData.append('account_pattern', newMapping.account_pattern);
      formData.append('wam_category', newMapping.wam_category);
      formData.append('priority', newMapping.priority.toString());

      const response = await fetch(`${API_BASE_URL}/api/wam-mappings`, {
        method: 'POST',
        body: formData,
      });

      if (!response.ok) {
        throw new Error('マッピング作成に失敗しました');
      }

      setNewMapping({
        account_pattern: '',
        wam_category: wamCategories[0] || '',
        priority: 100
      });
      loadMappings();
      loadWamData(); // WAMデータを再読み込み
    } catch (error) {
      console.error('Create mapping failed:', error);
      alert('マッピング作成に失敗しました');
    }
  };

  const handleUpdateMapping = async (mapping: WamMapping) => {
    try {
      const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
        (process.env.NODE_ENV === 'production' 
          ? 'http://160.251.170.97:8000'
          : 'http://160.251.170.97:8001'
        );

      const formData = new FormData();
      formData.append('account_pattern', mapping.account_pattern);
      formData.append('wam_category', mapping.wam_category);
      formData.append('priority', mapping.priority.toString());

      const response = await fetch(`${API_BASE_URL}/api/wam-mappings/${mapping.id}`, {
        method: 'PUT',
        body: formData,
      });

      if (!response.ok) {
        throw new Error('マッピング更新に失敗しました');
      }

      setEditingMapping(null);
      loadMappings();
      loadWamData(); // WAMデータを再読み込み
    } catch (error) {
      console.error('Update mapping failed:', error);
      alert('マッピング更新に失敗しました');
    }
  };

  const handleDeleteMapping = async (id: number) => {
    if (!confirm('このマッピングルールを削除しますか？')) {
      return;
    }

    try {
      const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
        (process.env.NODE_ENV === 'production' 
          ? 'http://160.251.170.97:8000'
          : 'http://160.251.170.97:8001'
        );

      const response = await fetch(`${API_BASE_URL}/api/wam-mappings/${id}`, {
        method: 'DELETE',
      });

      if (!response.ok) {
        throw new Error('マッピング削除に失敗しました');
      }

      loadMappings();
      loadWamData(); // WAMデータを再読み込み
    } catch (error) {
      console.error('Delete mapping failed:', error);
      alert('マッピング削除に失敗しました');
    }
  };

  const handleExportMappings = async () => {
    try {
      const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
        (process.env.NODE_ENV === 'production' 
          ? 'http://160.251.170.97:8000'
          : 'http://160.251.170.97:8001'
        );

      const response = await fetch(`${API_BASE_URL}/api/wam-mappings/export`);

      if (!response.ok) {
        throw new Error('CSVエクスポートに失敗しました');
      }

      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `wam_mappings_${new Date().toISOString().slice(0, 19).replace(/[-:T]/g, '')}.csv`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    } catch (error) {
      console.error('Export failed:', error);
      alert('CSVエクスポートに失敗しました');
    }
  };

  const handleImportMappings = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    try {
      setImporting(true);
      
      const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
        (process.env.NODE_ENV === 'production' 
          ? 'http://160.251.170.97:8000'
          : 'http://160.251.170.97:8001'
        );

      const formData = new FormData();
      formData.append('file', file);

      const response = await fetch(`${API_BASE_URL}/api/wam-mappings/import`, {
        method: 'POST',
        body: formData,
      });

      if (!response.ok) {
        throw new Error('CSVインポートに失敗しました');
      }

      const result = await response.json();
      
      if (result.errors && result.errors.length > 0) {
        alert(`インポート完了: ${result.imported_count}件\nエラー:\n${result.errors.join('\n')}`);
      } else {
        alert(`${result.imported_count}件のマッピングルールをインポートしました`);
      }

      loadMappings();
      loadWamData(); // WAMデータを再読み込み
    } catch (error) {
      console.error('Import failed:', error);
      alert('CSVインポートに失敗しました');
    } finally {
      setImporting(false);
      // ファイル選択をリセット
      event.target.value = '';
    }
  };

  const onCellValueChanged = (event: any) => {
    // セルの値が変更された時の処理
    const updatedData = [...wamData];
    const rowIndex = event.rowIndex;
    updatedData[rowIndex] = { ...updatedData[rowIndex], [event.colDef.field]: event.newValue };
    setWamData(updatedData);
  };

  return (
    <div className="px-4 py-6 sm:px-0">
      <div className="border-b border-gray-200 pb-4 mb-6">
        <div className="flex justify-between items-start">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">WAM報告書作成</h1>
            <p className="mt-2 text-sm text-gray-600">
              取引データをWAM報告書形式に変換してCSV出力
            </p>
          </div>
        </div>
      </div>

      {/* エラー表示 */}
      {error && (
        <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
          <div className="flex items-center">
            <div className="text-red-500 text-xl mr-3">⚠️</div>
            <p className="text-red-800 font-medium">{error}</p>
          </div>
        </div>
      )}

      {/* コントロールパネル */}
      <div className="bg-white shadow rounded-lg p-6 mb-6">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-medium text-gray-900">設定</h2>
          <button
            onClick={() => setShowMappingSettings(true)}
            className="bg-gray-600 text-white px-4 py-2 rounded-md hover:bg-gray-700 text-sm"
          >
            ⚙️ マッピング設定
          </button>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-5 gap-4 items-end">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              助成金ID
            </label>
            <input
              type="number"
              value={selectedGrantId}
              onChange={(e) => {
                const newId = parseInt(e.target.value) || 1;
                setSelectedGrantId(newId);
                // ローカルストレージに保存
                localStorage.setItem('selectedGrantId', newId.toString());
              }}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              min="1"
              placeholder="1"
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              開始日
            </label>
            <input
              type="date"
              value={startDate}
              onChange={(e) => setStartDate(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              終了日
            </label>
            <input
              type="date"
              value={endDate}
              onChange={(e) => setEndDate(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          
          <div>
            <button
              onClick={loadWamData}
              disabled={loading || !startDate || !endDate}
              className="w-full bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 disabled:opacity-50"
            >
              {loading ? 'データ読み込み中...' : 'データ更新'}
            </button>
          </div>
          
          <div>
            <button
              onClick={handleExportCSV}
              disabled={exporting || wamData.length === 0}
              className="w-full bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 disabled:opacity-50"
            >
              {exporting ? 'CSV出力中...' : 'CSV出力'}
            </button>
          </div>
        </div>
      </div>

      {/* 説明パネル */}
      <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
        <h3 className="text-sm font-medium text-blue-900 mb-2">💡 使い方</h3>
        <ul className="text-sm text-blue-800 space-y-1">
          <li>• 背景色が青い項目は勘定科目から自動推測されました</li>
          <li>• セルをダブルクリックして内容を編集できます</li>
          <li>• 科目はプルダウンから選択できます</li>
          <li>• 編集後「CSV出力」でWAM報告書をダウンロードできます</li>
        </ul>
      </div>

      {/* データテーブル */}
      <div className="bg-white shadow rounded-lg">
        <div className="px-6 py-4 border-b border-gray-200">
          <h2 className="text-lg font-medium text-gray-900">
            WAM報告書データ ({wamData.length} 件)
          </h2>
        </div>
        
        <div className="p-6">
          <div className="ag-theme-alpine" style={{ height: 600, width: '100%' }}>
            <AgGridReact
              ref={gridRef}
              columnDefs={columnDefs}
              rowData={wamData}
              defaultColDef={{
                sortable: true,
                filter: true,
                resizable: true,
                cellStyle: { fontSize: '14px' }
              }}
              onCellValueChanged={onCellValueChanged}
              suppressRowClickSelection={true}
              domLayout="normal"
              animateRows={true}
              pagination={true}
              paginationPageSize={50}
              getRowStyle={(params) => {
                // 自動推測された行は薄い背景色
                if (params.data._auto_mapped) {
                  return { backgroundColor: '#f8f9fa' };
                }
                return undefined;
              }}
            />
          </div>
        </div>
      </div>

      {/* マッピング設定モーダル */}
      {showMappingSettings && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-4xl max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-bold text-gray-900">WAMマッピング設定</h2>
              <div className="flex items-center space-x-2">
                <button
                  onClick={handleExportMappings}
                  className="bg-green-600 text-white px-3 py-1 rounded text-sm hover:bg-green-700"
                >
                  📥 CSVエクスポート
                </button>
                <label className="bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700 cursor-pointer">
                  📤 CSVインポート
                  <input
                    type="file"
                    accept=".csv"
                    onChange={handleImportMappings}
                    className="hidden"
                    disabled={importing}
                  />
                </label>
                <button
                  onClick={() => setShowMappingSettings(false)}
                  className="text-gray-500 hover:text-gray-700 text-2xl"
                >
                  ×
                </button>
              </div>
            </div>

            {/* 新規作成フォーム */}
            <div className="bg-gray-50 p-4 rounded-lg mb-6">
              <h3 className="text-md font-medium text-gray-900 mb-3">新しいマッピングルール</h3>
              <form onSubmit={handleCreateMapping} className="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    勘定科目パターン
                  </label>
                  <select
                    value={newMapping.account_pattern}
                    onChange={(e) => setNewMapping({ ...newMapping, account_pattern: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    required
                  >
                    <option value="">勘定科目を選択してください</option>
                    {accountPatterns.map(pattern => (
                      <option key={pattern} value={pattern}>{pattern}</option>
                    ))}
                  </select>
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    WAM科目
                  </label>
                  <select
                    value={newMapping.wam_category}
                    onChange={(e) => setNewMapping({ ...newMapping, wam_category: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    {wamCategories.map(category => (
                      <option key={category} value={category}>{category}</option>
                    ))}
                  </select>
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    優先順位
                  </label>
                  <input
                    type="number"
                    value={newMapping.priority}
                    onChange={(e) => setNewMapping({ ...newMapping, priority: parseInt(e.target.value) || 100 })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    min="1"
                    max="999"
                  />
                </div>
                
                <div>
                  <button
                    type="submit"
                    className="w-full bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700"
                  >
                    追加
                  </button>
                </div>
              </form>
            </div>

            {/* マッピングルール一覧 */}
            <div className="bg-white border border-gray-200 rounded-lg">
              <div className="px-4 py-3 border-b border-gray-200">
                <h3 className="text-md font-medium text-gray-900">
                  現在のマッピングルール ({mappings.length} 件)
                </h3>
              </div>
              
              <div className="max-h-80 overflow-y-auto">
                {mappings.length === 0 ? (
                  <div className="p-4 text-center text-gray-500">
                    マッピングルールがありません
                  </div>
                ) : (
                  <table className="w-full">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-4 py-2 text-left text-sm font-medium text-gray-700">勘定科目パターン</th>
                        <th className="px-4 py-2 text-left text-sm font-medium text-gray-700">WAM科目</th>
                        <th className="px-4 py-2 text-left text-sm font-medium text-gray-700">優先順位</th>
                        <th className="px-4 py-2 text-left text-sm font-medium text-gray-700">操作</th>
                      </tr>
                    </thead>
                    <tbody>
                      {mappings.map((mapping) => (
                        <tr key={mapping.id} className="border-b border-gray-100">
                          <td className="px-4 py-2">
                            {editingMapping === mapping.id ? (
                              <select
                                value={mapping.account_pattern}
                                onChange={(e) => {
                                  const updatedMappings = mappings.map(m => 
                                    m.id === mapping.id ? { ...m, account_pattern: e.target.value } : m
                                  );
                                  setMappings(updatedMappings);
                                }}
                                className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
                              >
                                <option value="">勘定科目を選択</option>
                                {accountPatterns.map(pattern => (
                                  <option key={pattern} value={pattern}>{pattern}</option>
                                ))}
                              </select>
                            ) : (
                              <span className="text-sm">{mapping.account_pattern}</span>
                            )}
                          </td>
                          <td className="px-4 py-2">
                            {editingMapping === mapping.id ? (
                              <select
                                value={mapping.wam_category}
                                onChange={(e) => {
                                  const updatedMappings = mappings.map(m => 
                                    m.id === mapping.id ? { ...m, wam_category: e.target.value } : m
                                  );
                                  setMappings(updatedMappings);
                                }}
                                className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
                              >
                                <option value="">WAM科目を選択</option>
                                {wamCategories.map(category => (
                                  <option key={category} value={category}>{category}</option>
                                ))}
                              </select>
                            ) : (
                              <span className="text-sm">{mapping.wam_category}</span>
                            )}
                          </td>
                          <td className="px-4 py-2">
                            {editingMapping === mapping.id ? (
                              <input
                                type="number"
                                value={mapping.priority}
                                onChange={(e) => {
                                  const updatedMappings = mappings.map(m => 
                                    m.id === mapping.id ? { ...m, priority: parseInt(e.target.value) || 100 } : m
                                  );
                                  setMappings(updatedMappings);
                                }}
                                className="w-full px-2 py-1 text-sm border border-gray-300 rounded"
                                min="1"
                                max="999"
                              />
                            ) : (
                              <span className="text-sm">{mapping.priority}</span>
                            )}
                          </td>
                          <td className="px-4 py-2">
                            <div className="flex space-x-2">
                              {editingMapping === mapping.id ? (
                                <>
                                  <button
                                    onClick={() => handleUpdateMapping(mapping)}
                                    className="text-blue-600 hover:text-blue-800 text-sm"
                                  >
                                    保存
                                  </button>
                                  <button
                                    onClick={() => {
                                      setEditingMapping(null);
                                      loadMappings(); // 元に戻す
                                    }}
                                    className="text-gray-600 hover:text-gray-800 text-sm"
                                  >
                                    キャンセル
                                  </button>
                                </>
                              ) : (
                                <>
                                  <button
                                    onClick={() => setEditingMapping(mapping.id)}
                                    className="text-blue-600 hover:text-blue-800 text-sm"
                                  >
                                    編集
                                  </button>
                                  <button
                                    onClick={() => handleDeleteMapping(mapping.id)}
                                    className="text-red-600 hover:text-red-800 text-sm"
                                  >
                                    削除
                                  </button>
                                </>
                              )}
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                )}
              </div>
            </div>

            {/* 説明 */}
            <div className="mt-4 p-3 bg-blue-50 border border-blue-200 rounded-lg">
              <p className="text-sm text-blue-800">
                💡 勘定科目パターンは部分一致で動作します。優先順位が小さいほど優先されます。
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default WamReportPage; 