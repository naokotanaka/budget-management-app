/**
 * 割り当て情報の安全な更新を行うユーティリティ関数
 * データの消失を防ぐため、既存情報を必ず保持する
 */

export interface AllocationData {
  budget_item?: string;
  allocated_amount_edit?: number;
  allocated_budget_item?: string;
  allocated_amount?: number;
  [key: string]: any; // その他の将来追加される可能性のあるフィールド
}

/**
 * 割り当て情報を安全に更新する
 * @param currentAllocations 現在の割り当て状態
 * @param transactionId 取引ID
 * @param updates 更新内容
 * @returns 更新された割り当て状態
 */
export const updateAllocationSafely = (
  currentAllocations: { [key: string]: AllocationData },
  transactionId: string,
  updates: Partial<AllocationData>
): { [key: string]: AllocationData } => {
  const newAllocations = { ...currentAllocations };
  
  // 既存の割り当て情報を取得（なければ空オブジェクト）
  const existingAllocation = currentAllocations[transactionId] || {};
  
  // 既存情報を保持して新しい情報をマージ
  newAllocations[transactionId] = {
    ...existingAllocation, // 既存情報を必ず保持
    ...updates // 新しい情報で上書き
  };
  
  console.log(`[AllocationUtils] Updated allocation for ${transactionId}:`, {
    existing: existingAllocation,
    updates,
    result: newAllocations[transactionId]
  });
  
  return newAllocations;
};

/**
 * ローカルストレージに安全に保存する
 * @param allocations 割り当て状態
 */
export const saveAllocationsToStorage = (allocations: { [key: string]: AllocationData }): void => {
  try {
    localStorage.setItem('transactionAllocations', JSON.stringify(allocations));
    console.log('[AllocationUtils] Saved to localStorage:', Object.keys(allocations).length, 'allocations');
  } catch (error) {
    console.error('[AllocationUtils] Failed to save to localStorage:', error);
  }
};

/**
 * ローカルストレージから割り当て情報を読み込む
 * @returns 割り当て状態
 */
export const loadAllocationsFromStorage = (): { [key: string]: AllocationData } => {
  try {
    const saved = localStorage.getItem('transactionAllocations');
    if (saved) {
      const parsed = JSON.parse(saved);
      console.log('[AllocationUtils] Loaded from localStorage:', Object.keys(parsed).length, 'allocations');
      return parsed;
    }
  } catch (error) {
    console.error('[AllocationUtils] Failed to load from localStorage:', error);
  }
  return {};
};

/**
 * 割り当て情報の一括更新（一括割り当て処理用）
 * @param currentAllocations 現在の割り当て状態
 * @param transactionIds 取引IDの配列
 * @param budgetItem 予算項目
 * @param amounts 金額の配列（取引IDと同じ順序）
 * @returns 更新された割り当て状態
 */
export const batchUpdateAllocations = (
  currentAllocations: { [key: string]: AllocationData },
  transactionIds: string[],
  budgetItem: string,
  amounts: number[]
): { [key: string]: AllocationData } => {
  let newAllocations = { ...currentAllocations };
  
  transactionIds.forEach((transactionId, index) => {
    const amount = amounts[index];
    newAllocations = updateAllocationSafely(newAllocations, transactionId, {
      budget_item: budgetItem,
      allocated_amount_edit: amount,
      allocated_budget_item: budgetItem,
      allocated_amount: amount
    });
  });
  
  console.log('[AllocationUtils] Batch update completed:', transactionIds.length, 'transactions');
  return newAllocations;
};