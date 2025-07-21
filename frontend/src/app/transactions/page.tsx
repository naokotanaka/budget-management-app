'use client';

import React, { useState } from 'react';
import TransactionGrid from '@/components/TransactionGrid';
import TransactionDetailPanel from '@/components/TransactionDetailPanel';

const TransactionsPage: React.FC = () => {
  const [selectedTransaction, setSelectedTransaction] = useState<any>(null);

  const gridRef = React.useRef<any>(null);

  // グリッドのデータを再読み込みする関数
  const refreshGridData = () => {
    if (gridRef.current?.reloadData) {
      gridRef.current.reloadData();
    }
  };

  return (
    <div className="w-full flex flex-col">
        <div className="border-b border-gray-200 pb-1 mb-1 px-2 pt-1 flex-shrink-0" style={{ height: '40px' }}>
          <h1 className="text-sm font-bold text-gray-900">取引一覧</h1>
        </div>
        
        <div className="flex-1 min-h-0 flex">
          {/* 取引グリッド */}
          <div className={`${selectedTransaction ? 'w-2/3' : 'w-full'} transition-all duration-300`}>
            <TransactionGrid 
              ref={gridRef}
              onTransactionSelect={setSelectedTransaction}
              selectedTransaction={selectedTransaction}
            />
          </div>
          
          {/* 選択した取引の詳細パネル */}
          {selectedTransaction && (
            <TransactionDetailPanel 
              transaction={selectedTransaction}
              onClose={() => setSelectedTransaction(null)}
              onUpdate={(updatedTransaction) => {
                setSelectedTransaction(updatedTransaction);
                // グリッドデータを再読み込みして一覧に反映
                refreshGridData();
              }}
            />
          )}
        </div>
    </div>
  );
};

export default TransactionsPage;