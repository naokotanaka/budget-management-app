import React, { useState, useMemo } from 'react';

function AdvancedTableDemo() {
  // 初期データ（より多くのサンプル）
  const [originalData] = useState([
    { id: 1, 取引日: '2025-01-15', 借方部門: '【事】子育て支援', 借方勘定科目: '【事】人件費', 借方金額: 150000, 借方取引先名: '田中太郎', 現在の割り当て: '未割り当て', selected: false },
    { id: 2, 取引日: '2025-01-16', 借方部門: '【管】管理', 借方勘定科目: '【管】事務費', 借方金額: 25000, 借方取引先名: '事務用品店', 現在の割り当て: '長久手市助成金 - 事務費', selected: false },
    { id: 3, 取引日: '2025-01-17', 借方部門: '【事】食の支援', 借方勘定科目: '【事】消耗品費', 借方金額: 45000, 借方取引先名: '食材業者', 現在の割り当て: '未割り当て', selected: false },
    { id: 4, 取引日: '2025-01-18', 借方部門: '【事】相談支援', 借方勘定科目: '【事】謝金', 借方金額: 80000, 借方取引先名: 'カウンセラー', 現在の割り当て: '県補助金 - 活動費', selected: false },
    { id: 5, 取引日: '2025-01-19', 借方部門: '【管】管理', 借方勘定科目: '【管】通信費', 借方金額: 12000, 借方取引先名: 'NTT', 現在の割り当て: '未割り当て', selected: false },
    { id: 6, 取引日: '2025-01-20', 借方部門: '【事】子育て支援', 借方勘定科目: '【事】交通費', 借方金額: 8500, 借方取引先名: '訪問活動', 現在の割り当て: '長久手市助成金 - 活動費', selected: false },
    { id: 7, 取引日: '2025-01-21', 借方部門: '【事】食の支援', 借方勘定科目: '【事】材料費', 借方金額: 35000, 借方取引先名: '食材卸', 現在の割り当て: '未割り当て', selected: false },
    { id: 8, 取引日: '2025-01-22', 借方部門: '【管】管理', 借方勘定科目: '【管】印刷費', 借方金額: 18000, 借方取引先名: '印刷会社', 現在の割り当て: '県補助金 - 広報費', selected: false }
  ]);

  const [data, setData] = useState(originalData);
  
  // フィルター状態
  const [filters, setFilters] = useState({
    取引日: '',
    借方部門: '',
    借方勘定科目: '',
    借方取引先名: '',
    現在の割り当て: '',
    金額範囲: [0, 200000],
    全体検索: ''
  });

  // 並べ替え状態
  const [sortConfig, setSortConfig] = useState({
    key: null,
    direction: 'asc'
  });

  // ページング状態
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(5);

  // 予算項目選択肢
  const budgetOptions = [
    '未割り当て',
    '長久手市助成金 - 人件費',
    '長久手市助成金 - 事務費',
    '長久手市助成金 - 活動費',
    '県補助金 - 活動費',
    '県補助金 - 広報費'
  ];

  // フィルター処理
  const filteredData = useMemo(() => {
    let filtered = [...data];

    // 各列フィルター
    Object.keys(filters).forEach(key => {
      if (filters[key] && key !== '金額範囲' && key !== '全体検索') {
        filtered = filtered.filter(item => 
          item[key]?.toString().toLowerCase().includes(filters[key].toLowerCase())
        );
      }
    });

    // 金額範囲フィルター
    filtered = filtered.filter(item => 
      item.借方金額 >= filters.金額範囲[0] && item.借方金額 <= filters.金額範囲[1]
    );

    // 全体検索
    if (filters.全体検索) {
      filtered = filtered.filter(item =>
        Object.values(item).some(value =>
          value?.toString().toLowerCase().includes(filters.全体検索.toLowerCase())
        )
      );
    }

    return filtered;
  }, [data, filters]);

  // 並べ替え処理
  const sortedData = useMemo(() => {
    if (!sortConfig.key) return filteredData;

    return [...filteredData].sort((a, b) => {
      const aVal = a[sortConfig.key];
      const bVal = b[sortConfig.key];

      if (aVal < bVal) return sortConfig.direction === 'asc' ? -1 : 1;
      if (aVal > bVal) return sortConfig.direction === 'asc' ? 1 : -1;
      return 0;
    });
  }, [filteredData, sortConfig]);

  // ページング処理
  const paginatedData = useMemo(() => {
    const startIndex = (currentPage - 1) * pageSize;
    return sortedData.slice(startIndex, startIndex + pageSize);
  }, [sortedData, currentPage, pageSize]);

  // 並べ替えハンドラー
  const handleSort = (key) => {
    setSortConfig(prev => ({
      key,
      direction: prev.key === key && prev.direction === 'asc' ? 'desc' : 'asc'
    }));
  };

  // フィルター変更ハンドラー
  const handleFilterChange = (key, value) => {
    setFilters(prev => ({ ...prev, [key]: value }));
    setCurrentPage(1); // フィルター変更時は1ページ目に戻る
  };

  // 割り当て変更処理
  const handleAllocationChange = (id, value) => {
    setData(prevData => 
      prevData.map(row => 
        row.id === id 
          ? { ...row, 現在の割り当て: value }
          : row
      )
    );
  };

  // 選択処理
  const handleSelectChange = (id, checked) => {
    setData(prevData => 
      prevData.map(row => 
        row.id === id 
          ? { ...row, selected: checked }
          : row
      )
    );
  };

  // 全選択
  const handleSelectAll = (checked) => {
    setData(prevData => 
      prevData.map(row => ({ ...row, selected: checked }))
    );
  };

  // フィルタークリア
  const clearFilters = () => {
    setFilters({
      取引日: '',
      借方部門: '',
      借方勘定科目: '',
      借方取引先名: '',
      現在の割り当て: '',
      金額範囲: [0, 200000],
      全体検索: ''
    });
    setCurrentPage(1);
  };

  const totalPages = Math.ceil(sortedData.length / pageSize);
  const selectedCount = data.filter(row => row.selected).length;

  // スタイル定義
  const tableStyle = {
    width: '100%',
    borderCollapse: 'collapse',
    fontSize: '12px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
  };

  const headerStyle = {
    backgroundColor: '#f5f5f5',
    padding: '8px 6px',
    border: '1px solid #ddd',
    fontWeight: 'bold',
    fontSize: '11px',
    textAlign: 'left',
    cursor: 'pointer',
    userSelect: 'none'
  };

  const cellStyle = {
    padding: '6px',
    border: '1px solid #ddd',
    fontSize: '11px'
  };

  const filterStyle = {
    width: '100%',
    padding: '4px',
    border: '1px solid #ccc',
    borderRadius: '3px',
    fontSize: '11px',
    marginBottom: '2px'
  };

  const getSortIcon = (key) => {
    if (sortConfig.key !== key) return ' ↕️';
    return sortConfig.direction === 'asc' ? ' ↑' : ' ↓';
  };

  return (
    <div style={{ padding: '20px' }}>
      {/* 全体検索・クイック操作 */}
      <div style={{ 
        marginBottom: '16px', 
        padding: '12px', 
        backgroundColor: '#f8f9fa', 
        borderRadius: '8px',
        display: 'flex',
        gap: '12px',
        alignItems: 'center',
        flexWrap: 'wrap'
      }}>
        <div style={{ flex: 1, minWidth: '200px' }}>
          <label style={{ fontSize: '12px', fontWeight: 'bold' }}>🔍 全体検索：</label>
          <input 
            type="text"
            value={filters.全体検索}
            onChange={(e) => handleFilterChange('全体検索', e.target.value)}
            placeholder="全列から検索..."
            style={{ ...filterStyle, width: '100%', marginLeft: '8px' }}
          />
        </div>
        <div style={{ display: 'flex', gap: '8px' }}>
          <button 
            onClick={clearFilters}
            style={{ 
              padding: '6px 12px', 
              backgroundColor: '#dc3545', 
              color: 'white', 
              border: 'none', 
              borderRadius: '4px',
              cursor: 'pointer',
              fontSize: '11px'
            }}
          >
            🔄 フィルタークリア
          </button>
          <select 
            value={pageSize} 
            onChange={(e) => {
              setPageSize(Number(e.target.value));
              setCurrentPage(1);
            }}
            style={{ padding: '6px', fontSize: '11px' }}
          >
            <option value={5}>5件表示</option>
            <option value={10}>10件表示</option>
            <option value={20}>20件表示</option>
            <option value={50}>50件表示</option>
          </select>
        </div>
      </div>

      {/* 選択状況 */}
      {selectedCount > 0 && (
        <div style={{ 
          marginBottom: '16px', 
          padding: '8px', 
          backgroundColor: '#fff3cd', 
          borderRadius: '4px',
          fontSize: '12px',
          fontWeight: 'bold'
        }}>
          🎯 {selectedCount}件選択中
        </div>
      )}

      {/* 金額範囲フィルター */}
      <div style={{ 
        marginBottom: '12px', 
        padding: '8px', 
        backgroundColor: '#e9ecef', 
        borderRadius: '4px'
      }}>
        <label style={{ fontSize: '12px', fontWeight: 'bold' }}>💰 金額範囲：</label>
        <input 
          type="range"
          min="0"
          max="200000"
          step="5000"
          value={filters.金額範囲[0]}
          onChange={(e) => handleFilterChange('金額範囲', [Number(e.target.value), filters.金額範囲[1]])}
          style={{ marginLeft: '8px', marginRight: '8px' }}
        />
        ¥{filters.金額範囲[0].toLocaleString()} ～ 
        <input 
          type="range"
          min="0"
          max="200000"
          step="5000"
          value={filters.金額範囲[1]}
          onChange={(e) => handleFilterChange('金額範囲', [filters.金額範囲[0], Number(e.target.value)])}
          style={{ marginLeft: '8px', marginRight: '8px' }}
        />
        ¥{filters.金額範囲[1].toLocaleString()}
      </div>

      {/* テーブル */}
      <table style={tableStyle}>
        <thead>
          <tr>
            <th style={headerStyle}>
              <input 
                type="checkbox" 
                onChange={(e) => handleSelectAll(e.target.checked)}
                checked={selectedCount === data.length && data.length > 0}
              />
            </th>
            <th style={headerStyle} onClick={() => handleSort('現在の割り当て')}>
              現在の割り当て{getSortIcon('現在の割り当て')}
              <br/>
              <select 
                value={filters.現在の割り当て}
                onChange={(e) => handleFilterChange('現在の割り当て', e.target.value)}
                style={filterStyle}
                onClick={(e) => e.stopPropagation()}
              >
                <option value="">全て</option>
                <option value="未割り当て">未割り当て</option>
                <option value="長久手市">長久手市助成金</option>
                <option value="県補助金">県補助金</option>
              </select>
            </th>
            <th style={headerStyle} onClick={() => handleSort('取引日')}>
              取引日{getSortIcon('取引日')}
              <br/>
              <input 
                type="date"
                value={filters.取引日}
                onChange={(e) => handleFilterChange('取引日', e.target.value)}
                style={filterStyle}
                onClick={(e) => e.stopPropagation()}
              />
            </th>
            <th style={headerStyle} onClick={() => handleSort('借方部門')}>
              借方部門{getSortIcon('借方部門')}
              <br/>
              <select 
                value={filters.借方部門}
                onChange={(e) => handleFilterChange('借方部門', e.target.value)}
                style={filterStyle}
                onClick={(e) => e.stopPropagation()}
              >
                <option value="">全て</option>
                <option value="【事】">【事】事業</option>
                <option value="【管】">【管】管理</option>
              </select>
            </th>
            <th style={headerStyle} onClick={() => handleSort('借方勘定科目')}>
              借方勘定科目{getSortIcon('借方勘定科目')}
              <br/>
              <input 
                type="text"
                value={filters.借方勘定科目}
                onChange={(e) => handleFilterChange('借方勘定科目', e.target.value)}
                placeholder="科目で絞込..."
                style={filterStyle}
                onClick={(e) => e.stopPropagation()}
              />
            </th>
            <th style={headerStyle} onClick={() => handleSort('借方金額')}>
              借方金額{getSortIcon('借方金額')}
            </th>
            <th style={headerStyle} onClick={() => handleSort('借方取引先名')}>
              借方取引先名{getSortIcon('借方取引先名')}
              <br/>
              <input 
                type="text"
                value={filters.借方取引先名}
                onChange={(e) => handleFilterChange('借方取引先名', e.target.value)}
                placeholder="取引先で絞込..."
                style={filterStyle}
                onClick={(e) => e.stopPropagation()}
              />
            </th>
          </tr>
        </thead>
        <tbody>
          {paginatedData.map(row => (
            <tr key={row.id} style={{
              backgroundColor: row.selected 
                ? '#e3f2fd' 
                : row.現在の割り当て === '未割り当て' 
                  ? '#fff3cd' 
                  : '#d4edda'
            }}>
              <td style={cellStyle}>
                <input 
                  type="checkbox" 
                  checked={row.selected}
                  onChange={(e) => handleSelectChange(row.id, e.target.checked)}
                />
              </td>
              <td style={cellStyle}>
                <select 
                  value={row.現在の割り当て}
                  onChange={(e) => handleAllocationChange(row.id, e.target.value)}
                  style={{ width: '100%', padding: '2px', fontSize: '11px' }}
                >
                  {budgetOptions.map(option => (
                    <option key={option} value={option}>
                      {option === '未割り当て' ? '⚪ ' : '✅ '}{option}
                    </option>
                  ))}
                </select>
              </td>
              <td style={cellStyle}>{row.取引日}</td>
              <td style={cellStyle}>{row.借方部門}</td>
              <td style={cellStyle}>{row.借方勘定科目}</td>
              <td style={{ ...cellStyle, textAlign: 'right', fontWeight: 'bold' }}>
                ¥{row.借方金額.toLocaleString()}
              </td>
              <td style={cellStyle}>{row.借方取引先名}</td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* ページング */}
      <div style={{ 
        marginTop: '12px', 
        display: 'flex', 
        justifyContent: 'space-between', 
        alignItems: 'center',
        fontSize: '12px'
      }}>
        <div>
          表示: {Math.min((currentPage - 1) * pageSize + 1, sortedData.length)} - {Math.min(currentPage * pageSize, sortedData.length)} / {sortedData.length}件
          （全{originalData.length}件中）
        </div>
        <div style={{ display: 'flex', gap: '4px' }}>
          <button 
            onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
            disabled={currentPage === 1}
            style={{ 
              padding: '4px 8px', 
              fontSize: '11px',
              cursor: currentPage === 1 ? 'not-allowed' : 'pointer'
            }}
          >
            ← 前
          </button>
          <span style={{ padding: '4px 8px', fontWeight: 'bold' }}>
            {currentPage} / {totalPages}
          </span>
          <button 
            onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
            disabled={currentPage === totalPages}
            style={{ 
              padding: '4px 8px', 
              fontSize: '11px',
              cursor: currentPage === totalPages ? 'not-allowed' : 'pointer'
            }}
          >
            次 →
          </button>
        </div>
      </div>

      {/* 操作ガイド */}
      <div style={{ 
        marginTop: '16px', 
        padding: '12px', 
        backgroundColor: '#f8f9fa', 
        borderRadius: '8px',
        fontSize: '12px'
      }}>
        <div style={{ fontWeight: 'bold', marginBottom: '8px' }}>📊 操作方法：</div>
        <div style={{ lineHeight: '1.5' }}>
          • **並べ替え**: 列ヘッダーをクリック（↑↓アイコン表示）<br/>
          • **フィルター**: 各列下の入力欄で絞り込み<br/>
          • **全体検索**: 上部の検索ボックスで全列検索<br/>
          • **金額範囲**: スライダーで範囲指定<br/>
          • **直接編集**: 「現在の割り当て」列のドロップダウン<br/>
          • **一括選択**: チェックボックスで複数選択可能
        </div>
      </div>
    </div>
  );
}

export default AdvancedTableDemo;