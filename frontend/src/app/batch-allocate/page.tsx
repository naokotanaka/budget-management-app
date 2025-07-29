'use client';

import React, { useState, useRef } from 'react';
import TransactionGrid from '@/components/TransactionGrid';
import BatchAllocationPanel from '@/components/BatchAllocationPanel';
import { Transaction } from '@/lib/api';

const BatchAllocatePage: React.FC = () => {
  const [selectedRows, setSelectedRows] = useState<Transaction[]>([]);
  const [dateFilter, setDateFilter] = useState<{ start_date: string; end_date: string } | null>(null);
  const [selectedBudgetItem, setSelectedBudgetItem] = useState<any>(null);
  const [lastProcessedTransactionIds, setLastProcessedTransactionIds] = useState<number[]>([]);
  const transactionGridRef = useRef<any>(null);

  console.log('BatchAllocatePage render, current dateFilter:', dateFilter);

  const handleSelectionChanged = (rows: Transaction[]) => {
    setSelectedRows(rows);
  };

  const handleAllocationComplete = () => {
    // 処理された取引IDを取得
    const processedTransactionIds = selectedRows.map(row => row.id);
    setLastProcessedTransactionIds(processedTransactionIds);
    
    // 全データ再読み込みの代わりに、処理された行のみを更新
    if (transactionGridRef.current?.refreshSelectedRows) {
      transactionGridRef.current.refreshSelectedRows(processedTransactionIds);
    }

    // 取引一覧の選択のみを解除（予算項目の選択は保持）
    if (transactionGridRef.current?.clearSelection) {
      transactionGridRef.current.clearSelection();
    }
    setSelectedRows([]);
  };

  const handleBudgetItemSelected = (grant: { start_date: string; end_date: string } | null) => {
    console.log('BatchAllocatePage received dateFilter:', grant);
    setDateFilter(grant);
  };

  const handleSelectedBudgetItemChange = (budgetItem: any) => {
    setSelectedBudgetItem(budgetItem);
  };

  return (
    <div className="w-full flex flex-col">
      <div className="border-b border-gray-200 pb-1 mb-1 px-2 pt-1 flex-shrink-0" style={{ height: '40px' }}>
        <h1 className="text-sm font-bold text-gray-900">一括割当</h1>
      </div>

      <div className="flex flex-1 min-h-0">
        <div className="w-96 flex-shrink-0 pr-2">
          <BatchAllocationPanel
            selectedRows={selectedRows}
            onAllocationComplete={handleAllocationComplete}
            onBudgetItemSelected={handleBudgetItemSelected}
            onSelectedBudgetItemChange={handleSelectedBudgetItemChange}
          />
        </div>
        <div className="flex-1 min-w-0 pl-2">
          <TransactionGrid
            ref={transactionGridRef}
            onSelectionChanged={handleSelectionChanged}
            enableBatchAllocation={true}
            dateFilter={dateFilter}
            selectedBudgetItem={selectedBudgetItem}
          />
        </div>
      </div>
    </div>
  );
};

export default BatchAllocatePage;