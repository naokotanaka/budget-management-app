'use client';

import React, { useState, useRef } from 'react';
import TransactionGrid from '@/components/TransactionGrid';
import BatchAllocationPanel from '@/components/BatchAllocationPanel';
import { Transaction } from '@/lib/api';

const BatchAllocatePage: React.FC = () => {
  const [selectedRows, setSelectedRows] = useState<Transaction[]>([]);
  const transactionGridRef = useRef<any>(null);

  const handleSelectionChanged = (rows: Transaction[]) => {
    setSelectedRows(rows);
  };

  const handleAllocationComplete = () => {
    // 割当完了後にTransactionGridのデータを再読み込み
    if (transactionGridRef.current?.reloadData) {
      transactionGridRef.current.reloadData();
    }
    
    // 選択をクリア
    setSelectedRows([]);
  };

  return (
    <div className="w-full flex flex-col">
        <div className="border-b border-gray-200 pb-1 mb-1 px-2 pt-1 flex-shrink-0" style={{ height: '40px' }}>
          <h1 className="text-sm font-bold text-gray-900">一括割当</h1>
        </div>
        
        <div className="flex flex-1 min-h-0">
          <div className="w-80 flex-shrink-0 pr-2">
            <BatchAllocationPanel 
              selectedRows={selectedRows} 
              onAllocationComplete={handleAllocationComplete}
            />
          </div>
          <div className="flex-1 min-w-0 pl-2">
            <TransactionGrid 
              ref={transactionGridRef}
              onSelectionChanged={handleSelectionChanged} 
              enableBatchAllocation={true}
            />
          </div>
        </div>
    </div>
  );
};

export default BatchAllocatePage;