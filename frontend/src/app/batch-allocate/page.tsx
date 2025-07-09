'use client';

import React, { useState } from 'react';
import BatchAllocationGrid from '@/components/BatchAllocationGrid';
import { Transaction } from '@/lib/api';

const BatchAllocatePage: React.FC = () => {
  const [selectedRows, setSelectedRows] = useState<Transaction[]>([]);

  const handleSelectionChanged = (rows: Transaction[]) => {
    setSelectedRows(rows);
  };

  return (
    <div className="w-full flex flex-col">
        <div className="border-b border-gray-200 pb-1 mb-1 px-2 pt-1 flex-shrink-0" style={{ height: '40px' }}>
          <h1 className="text-sm font-bold text-gray-900">一括割当</h1>
        </div>
        
        <div className="flex-1 min-w-0 pr-2">
          <BatchAllocationGrid onSelectionChanged={handleSelectionChanged} />
        </div>
    </div>
  );
};

export default BatchAllocatePage;