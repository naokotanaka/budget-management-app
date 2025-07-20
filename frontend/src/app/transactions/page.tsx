'use client';

import React from 'react';
import TransactionGrid from '@/components/TransactionGrid';

const TransactionsPage: React.FC = () => {

  return (
    <div className="w-full flex flex-col">
        <div className="border-b border-gray-200 pb-1 mb-1 px-2 pt-1 flex-shrink-0" style={{ height: '40px' }}>
          <h1 className="text-sm font-bold text-gray-900">取引一覧</h1>
        </div>
        
        <div className="flex flex-1 min-h-0">
          <div className="flex-1 min-w-0">
            <TransactionGrid />
          </div>
        </div>
    </div>
  );
};

export default TransactionsPage;