'use client';

import React, { useState, useEffect } from 'react';
import { api, Transaction, BudgetItem, Grant } from '@/lib/api';

interface TransactionDetailPanelProps {
  transaction: Transaction;
  onClose: () => void;
  onUpdate: (updatedTransaction: Transaction) => void;
}

const TransactionDetailPanel: React.FC<TransactionDetailPanelProps> = ({ 
  transaction, 
  onClose, 
  onUpdate 
}) => {
  const [budgetItems, setBudgetItems] = useState<BudgetItem[]>([]);
  const [grants, setGrants] = useState<Grant[]>([]);
  const [allocations, setAllocations] = useState<any[]>([]);
  const [selectedBudgetItem, setSelectedBudgetItem] = useState<string>('');
  const [allocatedAmount, setAllocatedAmount] = useState<number>(0);
  const [saving, setSaving] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState<string>('');
  const [receipts, setReceipts] = useState<any[]>([]);
  const [loadingReceipts, setLoadingReceipts] = useState<boolean>(false);
  const [freeeConnectionStatus, setFreeeConnectionStatus] = useState<{connected: boolean; message: string} | null>(null);

  // 初期データの読み込み
  useEffect(() => {
    const loadData = async () => {
      try {
        const [itemsData, grantsData, allocationsData] = await Promise.all([
          api.getBudgetItems(),
          api.getGrants(),
          api.getAllocations()
        ]);
        setBudgetItems(itemsData);
        setGrants(grantsData);
        setAllocations(allocationsData);
      } catch (error) {
        console.error('Failed to load data:', error);
      }
    };
    loadData();
    
    // Freee接続状態を取得
    const loadFreeeStatus = async () => {
      try {
        const response = await fetch('/budget/api/freee/status');
        if (response.ok) {
          const status = await response.json();
          setFreeeConnectionStatus(status);
        }
      } catch (error) {
        console.error('Failed to load freee status:', error);
        setFreeeConnectionStatus({ connected: false, message: 'Freee接続状態の取得に失敗しました' });
      }
    };
    
    loadFreeeStatus();
  }, []);

  // 選択された取引の割当情報を初期化
  useEffect(() => {
    setSelectedBudgetItem(transaction.budget_item || '');
    setAllocatedAmount(transaction.allocated_amount_edit || transaction.amount || 0);
  }, [transaction]);

  // Freeeファイルボックス情報を取得（Deal APIから取引詳細を取得）
  useEffect(() => {
    const loadReceipts = async () => {
      if (transaction.freee_deal_id) {
        setLoadingReceipts(true);
        try {
          // Freee Deal APIから取引詳細を取得
          console.log('Loading receipts for deal ID:', transaction.freee_deal_id);
          const dealDetail = await api.getFreeeDealDetail(transaction.freee_deal_id.toString());
          console.log('Deal detail received:', dealDetail);
          
          if (dealDetail && dealDetail.deal && dealDetail.deal.receipts && dealDetail.deal.receipts.length > 0) {
            // receipts配列にはすでにファイルの詳細情報が含まれている
            const receipts = dealDetail.deal.receipts;
            console.log('Receipts found:', receipts);
            setReceipts(receipts);
          } else {
            console.log('No receipts found for this deal');
            setReceipts([]);
          }
        } catch (error) {
          console.error('ファイルボックス情報の取得に失敗しました:', error);
          setReceipts([]);
        } finally {
          setLoadingReceipts(false);
        }
      }
    };
    
    loadReceipts();
  }, [transaction.freee_deal_id]);

  // 残額の色を決定する関数（他のページと同じルール）
  const getRemainingAmountColor = (remaining: number, endDate?: string) => {
    if (remaining <= 0) return 'text-gray-900';
    if (!endDate) return 'text-green-600 font-bold';
    
    const today = new Date();
    const end = new Date(endDate);
    const diffTime = end.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays < 0) return 'text-gray-400'; // 終了済み
    if (diffDays <= 30) return 'text-red-600 font-bold'; // 30日以下
    if (diffDays <= 60) return 'text-blue-600 font-bold'; // 60日以下
    return 'text-green-600 font-bold'; // それ以上
  };

  // 現在選択されている予算項目の情報を取得
  const getCurrentBudgetItemInfo = () => {
    if (!selectedBudgetItem || selectedBudgetItem === '未割当') return null;
    
    const budgetItem = budgetItems.find(item => 
      (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === selectedBudgetItem
    );
    
    if (!budgetItem) return null;
    
    const grant = grants.find(g => g.id === budgetItem.grant_id);
    
    // 予算項目の残額を計算
    const budgetItemAllocations = allocations.filter(a => a.budget_item_id === budgetItem.id);
    const allocatedAmount = budgetItemAllocations.reduce((sum, a) => sum + (a.amount || 0), 0);
    const budgetItemRemaining = budgetItem.budgeted_amount - allocatedAmount;
    
    // 助成金の残額を計算
    let grantRemaining = 0;
    if (grant) {
      const grantBudgetItems = budgetItems.filter(item => item.grant_id === grant.id);
      const totalGrantBudget = grantBudgetItems.reduce((sum, item) => sum + item.budgeted_amount, 0);
      const grantAllocations = allocations.filter(a => 
        grantBudgetItems.some(item => item.id === a.budget_item_id)
      );
      const totalGrantAllocated = grantAllocations.reduce((sum, a) => sum + a.amount, 0);
      grantRemaining = totalGrantBudget - totalGrantAllocated;
    }
    
    return {
      budgetItem,
      grant,
      budgetItemRemaining,
      grantRemaining
    };
  };

  // 割当を保存
  const saveAllocation = async () => {
    if (!selectedBudgetItem) {
      alert('予算項目を選択してください');
      return;
    }

    setSaving(true);
    try {
      const budgetItem = budgetItems.find(item => 
        (item.display_name || `${item.grant_name || '不明'}-${item.name}`) === selectedBudgetItem
      );

      if (!budgetItem) {
        alert('予算項目が見つかりません');
        return;
      }

      // 既存の割当を確認
      const currentAllocations = await api.getAllocations();
      const existingAllocation = currentAllocations.find(a => a.transaction_id === transaction.id);

      let result;
      if (existingAllocation) {
        // 更新
        result = await api.updateAllocation(existingAllocation.id, {
          budget_item_id: budgetItem.id,
          amount: allocatedAmount
        });
      } else {
        // 新規作成
        result = await api.createAllocation({
          transaction_id: transaction.id,
          budget_item_id: budgetItem.id,
          amount: allocatedAmount
        });
      }

      // 割当データを更新（残額情報を即座に反映するため）
      const updatedAllocations = await api.getAllocations();
      setAllocations(updatedAllocations);

      // 更新された取引データを親に通知
      const updatedTransaction = {
        ...transaction,
        budget_item: selectedBudgetItem,
        allocated_amount_edit: allocatedAmount
      };
      onUpdate(updatedTransaction);
    } catch (error) {
      console.error('Failed to save allocation:', error);
      alert('割当の保存に失敗しました');
    } finally {
      setSaving(false);
    }
  };

  // 割当を削除
  const removeAllocation = async () => {
    if (!confirm('この取引の割当を削除しますか？')) return;

    setSaving(true);
    try {
      const currentAllocations = await api.getAllocations();
      const existingAllocation = currentAllocations.find(a => a.transaction_id === transaction.id);

      if (existingAllocation) {
        await api.deleteAllocation(existingAllocation.id);
        
        // 割当データを更新（残額情報を即座に反映するため）
        const updatedAllocations = await api.getAllocations();
        setAllocations(updatedAllocations);
        
        // クリアされた取引データを親に通知
        const updatedTransaction = {
          ...transaction,
          budget_item: '',
          allocated_amount_edit: 0
        };
        onUpdate(updatedTransaction);

        setSelectedBudgetItem('');
        setAllocatedAmount(0);
      }
    } catch (error) {
      console.error('Failed to remove allocation:', error);
      alert('割当の削除に失敗しました');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="w-1/4 border-l border-gray-200 bg-gray-50 p-4 overflow-y-auto">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-lg font-semibold text-gray-900">取引詳細</h2>
        <button
          onClick={onClose}
          className="text-gray-400 hover:text-gray-600"
        >
          ✕
        </button>
      </div>

      {/* 予算割当編集 */}
      <div className="bg-white p-4 rounded-lg shadow-sm mb-4">
        <h3 className="text-sm font-medium text-gray-700 mb-3">予算割当</h3>
        
        <div className="space-y-3">
          <div>
            <label className="block text-sm text-gray-600 mb-1">カテゴリ</label>
            <select
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
              className="w-full p-2 border border-gray-300 rounded text-sm"
              disabled={saving}
            >
              <option value="">全てのカテゴリ</option>
              {/* ユニークなカテゴリリストを生成 */}
              {Array.from(new Set(budgetItems
                .filter(item => item.grant_status !== 'applied' && item.category)
                .map(item => item.category)
              )).sort().map(category => (
                <option key={category} value={category}>
                  {category}
                </option>
              ))}
            </select>
          </div>
          
          <div>
            <label className="block text-sm text-gray-600 mb-1">予算項目</label>
            <select
              value={selectedBudgetItem}
              onChange={(e) => setSelectedBudgetItem(e.target.value)}
              className="w-full p-2 border border-gray-300 rounded text-sm"
              disabled={saving}
              style={{
                fontFamily: 'monospace',
                color: '#374151'
              }}
            >
              <option value="">未割当</option>
              {budgetItems
                .filter(item => {
                  // 報告済みの助成金は除外
                  if (item.grant_status === 'applied') return false;
                  // カテゴリが選択されている場合はそのカテゴリのみ表示
                  if (selectedCategory && item.category !== selectedCategory) return false;
                  return true;
                })
                .map(item => {
                  // 残額を計算
                  const itemAllocations = allocations.filter(a => a.budget_item_id === item.id);
                  const allocatedAmount = itemAllocations.reduce((sum, a) => sum + (a.amount || 0), 0);
                  const remaining = item.budgeted_amount - allocatedAmount;
                  
                  // 助成金の終了日を取得
                  const grant = grants.find(g => g.id === item.grant_id);
                  const endDate = grant?.end_date;
                  
                  // 残額の色を決定（統一ルール）
                  const getRemainingColor = () => {
                    if (remaining <= 0) return '#9ca3af'; // gray-400
                    if (!endDate) return '#059669'; // green-600
                    
                    const today = new Date();
                    const end = new Date(endDate);
                    const diffTime = end.getTime() - today.getTime();
                    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                    
                    if (diffDays < 0) return '#9ca3af'; // gray-400 終了済み
                    if (diffDays <= 30) return '#dc2626'; // red-600 30日以下
                    if (diffDays <= 60) return '#2563eb'; // blue-600 60日以下
                    return '#059669'; // green-600 それ以上
                  };
                  
                  // 表示名を構築
                  const displayName = item.display_name || `${item.grant_name || '不明'}-${item.name}`;
                  const remainingText = `¥${remaining.toLocaleString()}`;
                  const endDateText = endDate ? endDate.substring(5) : ''; // YYYY-MM-DD から MM-DD を取得
                  
                  const fullDisplayName = `${displayName} (${remainingText}${endDateText ? `/${endDateText}` : ''})`;
                  
                  return (
                    <option 
                      key={item.id} 
                      value={displayName}
                      style={{
                        color: getRemainingColor(),
                        fontWeight: 'bold'
                      }}
                    >
                      {fullDisplayName}
                    </option>
                  );
                })}
            </select>
          </div>
          
          <div>
            <label className="block text-sm text-gray-600 mb-1">割当金額</label>
            <input
              type="number"
              value={allocatedAmount}
              onChange={(e) => setAllocatedAmount(parseFloat(e.target.value) || 0)}
              className="w-full p-2 border border-gray-300 rounded text-sm font-mono text-right"
              disabled={saving}
            />
          </div>

          {/* 残額情報 */}
          {(() => {
            const info = getCurrentBudgetItemInfo();
            if (!info) return null;

            return (
              <div className="bg-blue-50 p-3 rounded border space-y-2">
                <h4 className="text-sm font-medium text-blue-700">残額情報</h4>
                <div className="space-y-1 text-sm">
                  <div className="flex justify-between">
                    <span className="text-gray-600">予算項目残額:</span>
                    <span className={`font-mono ${getRemainingAmountColor(info.budgetItemRemaining, info.grant?.end_date)}`}>
                      ¥{info.budgetItemRemaining.toLocaleString()}
                    </span>
                  </div>
                  {info.grant && (
                    <div className="flex justify-between">
                      <span className="text-gray-600">助成金残額:</span>
                      <span className={`font-mono ${getRemainingAmountColor(info.grantRemaining, info.grant.end_date)}`}>
                        ¥{info.grantRemaining.toLocaleString()}
                      </span>
                    </div>
                  )}
                  {info.grant && (
                    <div className="text-xs text-gray-500 mt-1">
                      {info.grant.name}
                    </div>
                  )}
                </div>
              </div>
            );
          })()}
          
          <div className="flex gap-2">
            <button
              onClick={saveAllocation}
              disabled={saving || !selectedBudgetItem}
              className="flex-1 px-3 py-2 bg-blue-600 text-white rounded text-sm hover:bg-blue-700 disabled:opacity-50"
            >
              {saving ? '保存中...' : '保存'}
            </button>
            <button
              onClick={removeAllocation}
              disabled={saving}
              className="px-3 py-2 bg-red-600 text-white rounded text-sm hover:bg-red-700 disabled:opacity-50"
            >
              削除
            </button>
          </div>
          
          <button
            onClick={() => {
              setSelectedBudgetItem(transaction.budget_item || '');
              setAllocatedAmount(transaction.amount || 0);
            }}
            className="w-full px-3 py-2 bg-gray-600 text-white rounded text-sm hover:bg-gray-700"
          >
            取引金額をコピー
          </button>
        </div>
      </div>
      
      <div className="bg-white p-4 rounded-lg shadow-sm space-y-3">
        <div className="space-y-2 text-sm">
          <div className="flex justify-between items-center">
            <span className="text-gray-600">仕訳番号:</span>
            <div className="flex items-center space-x-2">
              <span className="font-mono">{transaction.journal_number}</span>
              {transaction.freee_deal_id && (
                <button
                  onClick={() => window.open(`https://secure.freee.co.jp/deals/standards?txn_number=${transaction.journal_number}`, '_blank')}
                  className="px-2 py-1 text-xs bg-blue-500 text-white rounded hover:bg-blue-600 transition-colors"
                  title="Freeeの取引を開く"
                >
                  開く
                </button>
              )}
            </div>
          </div>
          <div className="flex justify-between">
            <span className="text-gray-600">行番号:</span>
            <span className="font-mono">{transaction.journal_line_number}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-gray-600">日付:</span>
            <span className="font-mono">{transaction.date}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-gray-600">金額:</span>
            <span className="font-mono font-bold">¥{transaction.amount?.toLocaleString()}</span>
          </div>
          
          <hr className="my-3" />
          
          <div>
            <span className="text-gray-600">摘要:</span>
            <p className="mt-1 text-gray-900">{transaction.description}</p>
          </div>
          <div className="flex justify-between">
            <span className="text-gray-600">勘定科目:</span>
            <span>{transaction.account}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-gray-600">取引先:</span>
            <span>{transaction.supplier}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-gray-600">品目:</span>
            <span>{transaction.item}</span>
          </div>
          
          {(transaction.memo || transaction.remark) && (
            <>
              <hr className="my-3" />
              {transaction.memo && (
                <div>
                  <span className="text-gray-600">メモ:</span>
                  <p className="mt-1 text-gray-900">{transaction.memo}</p>
                </div>
              )}
              {transaction.remark && (
                <div>
                  <span className="text-gray-600">備考:</span>
                  <p className="mt-1 text-gray-900">{transaction.remark}</p>
                </div>
              )}
            </>
          )}
          
          {/* ファイルボックス情報 */}
          <>
            <hr className="my-3" />
            <div>
              <span className="text-gray-600">添付ファイル:</span>
              {!freeeConnectionStatus?.connected ? (
                // Freeeシステム未接続の場合
                <div className="mt-2 bg-yellow-50 border border-yellow-200 rounded-lg p-3">
                  <p className="text-sm text-gray-600 mb-3">
                    Freeeとの接続ができていないため、添付ファイルを表示できません。
                  </p>
                  <p className="text-xs text-gray-500 mb-3">
                    {freeeConnectionStatus?.message || '接続状態を確認中...'}
                  </p>
                  <button
                    onClick={() => window.open('/budget/freee', '_blank')}
                    className="w-full px-3 py-2 bg-blue-600 text-white rounded text-sm hover:bg-blue-700 transition-colors"
                  >
                    Freee接続ページを開く
                  </button>
                </div>
              ) : transaction.freee_deal_id ? (
                // Freee連携済みの場合
                loadingReceipts ? (
                  <p className="mt-1 text-gray-500">読み込み中...</p>
                ) : receipts.length > 0 ? (
                  <div className="mt-2 space-y-4">
                    {receipts.map((receipt: any, index: number) => (
                      <div key={receipt.id || index} className="bg-gray-50 rounded-lg p-3">
                        <div className="flex items-center justify-between mb-3">
                          <div className="flex-1">
                            <p className="text-sm font-medium">
                              {receipt.receipt_metadatum?.partner_name || receipt.description || `${receipt.mime_type?.split('/')[1] || 'ファイル'}`}
                            </p>
                            <p className="text-xs text-gray-500">
                              {receipt.receipt_metadatum?.issue_date || new Date(receipt.created_at).toLocaleDateString('ja-JP')}
                              {receipt.receipt_metadatum?.amount && ` - ¥${receipt.receipt_metadatum.amount.toLocaleString()}`}
                            </p>
                          </div>
                          <div className="flex space-x-2">
                            <span className="px-2 py-1 text-xs bg-blue-100 text-blue-800 rounded">
                              {receipt.mime_type?.split('/')[1] || 'file'}
                            </span>
                            <button
                              onClick={() => window.open(`https://secure.freee.co.jp/receipts/${receipt.id}`, '_blank')}
                              className="px-2 py-1 text-xs bg-green-500 text-white rounded hover:bg-green-600 transition-colors"
                              title="Freeeでファイルを表示"
                            >
                              表示
                            </button>
                          </div>
                        </div>
                        
                        {/* 画像の場合は直接表示 */}
                        {receipt.mime_type?.startsWith('image/') && receipt.file_src && (
                          <div className="mt-2">
                            <img 
                              src={receipt.file_src}
                              alt={`${receipt.receipt_metadatum?.partner_name || 'Receipt'} - ${receipt.receipt_metadatum?.issue_date || ''}`}
                              className="max-w-full h-auto max-h-[48rem] rounded border shadow-sm cursor-pointer hover:shadow-md transition-shadow"
                              onClick={() => window.open(receipt.file_src, '_blank')}
                              onError={(e) => {
                                console.error('Image failed to load:', receipt.file_src);
                                // 画像読み込み失敗時は非表示
                                (e.target as HTMLImageElement).style.display = 'none';
                              }}
                            />
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                ) : (
                  <p className="mt-1 text-gray-500">添付ファイルはありません</p>
                )
              ) : (
                // 取引がFreee未連携の場合
                <p className="mt-1 text-gray-500">この取引はFreeeと連携されていません</p>
              )}
            </div>
          </>
        </div>
      </div>
    </div>
  );
};

export default TransactionDetailPanel;