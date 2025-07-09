'use client';

import React, { useState } from 'react';
import { CONFIG } from '@/lib/config';

interface DateRangeFilterProps {
  onApplyFilter: (startDate: string, endDate: string) => void;
  onClearFilter: () => void;
  initialStartDate?: string;
  initialEndDate?: string;
}

const DateRangeFilter: React.FC<DateRangeFilterProps> = ({
  onApplyFilter,
  onClearFilter,
  initialStartDate = '',
  initialEndDate = ''
}) => {
  const [startDate, setStartDate] = useState(initialStartDate);
  const [endDate, setEndDate] = useState(initialEndDate);
  const [isExpanded, setIsExpanded] = useState(false);

  const handleApply = () => {
    if (startDate && endDate) {
      onApplyFilter(startDate, endDate);
      setIsExpanded(false);
    }
  };

  const handleClear = () => {
    setStartDate('');
    setEndDate('');
    onClearFilter();
    setIsExpanded(false);
  };

  const setDefaultRange = () => {
    setStartDate(CONFIG.DEFAULT_DATE_RANGE.START);
    setEndDate(CONFIG.DEFAULT_DATE_RANGE.END);
  };

  const setCurrentFiscalYear = () => {
    const now = new Date();
    const currentYear = now.getFullYear();
    const currentMonth = now.getMonth() + 1;
    
    // 4月始まりの年度計算
    const fiscalYear = currentMonth >= 4 ? currentYear : currentYear - 1;
    const fiscalStart = `${fiscalYear}-04-01`;
    const fiscalEnd = `${fiscalYear + 1}-03-31`;
    
    setStartDate(fiscalStart);
    setEndDate(fiscalEnd);
  };

  return (
    <div className="bg-white border rounded-lg p-4 mb-4">
      <div className="flex items-center justify-between">
        <h3 className="text-sm font-medium text-gray-900">期間フィルター</h3>
        <button
          onClick={() => setIsExpanded(!isExpanded)}
          className="text-blue-600 hover:text-blue-800 text-sm"
        >
          {isExpanded ? '閉じる' : '設定'}
        </button>
      </div>
      
      {isExpanded && (
        <div className="mt-4 space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                開始日
              </label>
              <input
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
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
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>
          
          <div className="flex flex-wrap gap-2">
            <button
              onClick={setDefaultRange}
              className="px-3 py-1 text-xs bg-blue-100 text-blue-700 rounded hover:bg-blue-200"
            >
              デフォルト期間 (2025/4-2026/3)
            </button>
            <button
              onClick={setCurrentFiscalYear}
              className="px-3 py-1 text-xs bg-green-100 text-green-700 rounded hover:bg-green-200"
            >
              今年度
            </button>
          </div>
          
          <div className="flex justify-end space-x-2">
            <button
              onClick={handleClear}
              className="px-4 py-2 text-sm text-gray-600 hover:text-gray-800"
            >
              クリア
            </button>
            <button
              onClick={handleApply}
              disabled={!startDate || !endDate}
              className="px-4 py-2 text-sm bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              適用
            </button>
          </div>
        </div>
      )}
      
      {(startDate && endDate) && !isExpanded && (
        <div className="mt-2 text-sm text-gray-600">
          適用中: {startDate} ～ {endDate}
        </div>
      )}
    </div>
  );
};

export default DateRangeFilter;