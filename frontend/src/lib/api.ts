import { API_CONFIG } from './config';

// 統一されたAPI URL設定を使用
const API_BASE_URL = API_CONFIG.BASE_URL;

export interface Transaction {
  id: string;
  journal_number: number;
  journal_line_number: number;
  date: string;
  description: string;
  amount: number;
  account: string;
  supplier: string;
  item: string;
  memo: string;
  remark: string;
  department: string;
  management_number: string;
  created_at: string;
  budget_item?: BudgetItem | string;
  allocated_amount?: number;
  allocated_amount_edit?: number;
  allocated_budget_item?: string;
}

export interface BudgetItem {
  id: number;
  name: string;
  category: string;
  budgeted_amount: number;
  grant_id: number;
  grant_name?: string;
  display_name?: string;
  grant_status?: 'active' | 'completed' | 'applied';
  remarks?: string;
}

export interface Grant {
  id: number;
  name: string;
  total_amount: number;
  start_date: string;
  end_date: string;
  status?: 'active' | 'completed' | 'applied';
  grant_code?: string;
}

export interface Allocation {
  id?: number;
  transaction_id: string;
  budget_item_id: number;
  amount: number;
  created_at?: string;
}

export interface AllocationDetail {
  id: number;
  transaction_id: string;
  budget_item_id: number;
  amount: number;
  created_at: string;
  transaction?: {
    id: string;
    date: string;
    description: string;
    amount: number;
    supplier: string;
  };
  budget_item?: {
    id: number;
    name: string;
    category: string;
    grant_name: string;
  };
}

export interface Category {
  id: number;
  name: string;
  description?: string;
  created_at: string;
  updated_at: string;
  is_active: boolean;
}

export interface FreeeSync {
  id: number;
  sync_type: string;
  start_date: string;
  end_date: string;
  status: 'pending' | 'processing' | 'completed' | 'failed';
  total_records: number;
  processed_records: number;
  created_records: number;
  updated_records: number;
  error_message?: string;
  created_at: string;
  completed_at?: string;
}

export interface GitHubCommit {
  sha: string;
  commit: {
    author: {
      name: string;
      email: string;
      date: string;
    };
    message: string;
  };
  html_url: string;
  author?: {
    login: string;
    avatar_url: string;
  };
}

export interface GitHubRelease {
  tag_name: string;
  name: string;
  body: string;
  published_at: string;
  html_url: string;
  prerelease: boolean;
}

export const api = {
  // Transactions
  async getTransactions(): Promise<Transaction[]> {
    console.log('API Base URL:', API_BASE_URL);
    try {
      const response = await fetch(`${API_BASE_URL}/api/transactions`);
      console.log('Response status:', response.status);
      console.log('Response headers:', response.headers);
      if (!response.ok) {
        const errorText = await response.text();
        console.error('Error response:', errorText);
        throw new Error(`Failed to fetch transactions: ${response.status} ${response.statusText}`);
      }
      return response.json();
    } catch (error) {
      console.error('Fetch error:', error);
      if (error instanceof TypeError && error.message.includes('Failed to fetch')) {
        throw new Error('Network error: Unable to connect to the server. Please check if the backend is running.');
      }
      throw error;
    }
  },

  async importTransactions(file: File): Promise<any> {
    console.log('Import API Base URL:', API_BASE_URL);
    const formData = new FormData();
    formData.append('file', file);

    try {
      const response = await fetch(`${API_BASE_URL}/api/transactions/import`, {
        method: 'POST',
        body: formData,
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error('Import error response:', errorText);
        throw new Error(`Failed to import transactions: ${response.status} ${response.statusText} - ${errorText}`);
      }
      return response.json();
    } catch (error) {
      console.error('Network error during import:', error);
      // Network error (e.g., CORS, connection refused, etc.)
      if (error instanceof TypeError && error.message.includes('fetch')) {
        throw new Error('ネットワークエラーが発生しました。サーバーに接続できません。');
      }
      throw error;
    }
  },

  async previewTransactions(file: File): Promise<any> {
    console.log('Preview API Base URL:', API_BASE_URL);
    const formData = new FormData();
    formData.append('file', file);

    try {
      const response = await fetch(`${API_BASE_URL}/api/transactions/preview`, {
        method: 'POST',
        body: formData,
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error('Preview error response:', errorText);
        throw new Error(`Failed to preview transactions: ${response.status} ${response.statusText} - ${errorText}`);
      }
      return response.json();
    } catch (error) {
      console.error('Network error during preview:', error);
      // Network error (e.g., CORS, connection refused, etc.)
      if (error instanceof TypeError && error.message.includes('fetch')) {
        throw new Error('ネットワークエラーが発生しました。サーバーに接続できません。');
      }
      throw error;
    }
  },

  // Budget Items
  async getBudgetItems(): Promise<BudgetItem[]> {
    console.log('Fetching budget items from:', `${API_BASE_URL}/api/budget-items`);
    try {
      const response = await fetch(`${API_BASE_URL}/api/budget-items`);
      console.log('Budget items response status:', response.status);
      if (!response.ok) {
        const errorText = await response.text();
        console.error('Budget items fetch failed:', response.status, response.statusText, errorText);
        throw new Error(`Failed to fetch budget items: ${response.status} ${response.statusText}`);
      }
      const data = await response.json();
      console.log('Budget items response:', data);
      return data;
    } catch (error) {
      console.error('Budget items fetch error:', error);
      if (error instanceof TypeError && error.message.includes('Failed to fetch')) {
        throw new Error('Network error: Unable to connect to the server for budget items.');
      }
      throw error;
    }
  },

  async createBudgetItem(data: { name: string; category: string; budgeted_amount: number; grant_id: number; remarks?: string }): Promise<BudgetItem> {
    const response = await fetch(`${API_BASE_URL}/api/budget-items`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });

    if (!response.ok) throw new Error('Failed to create budget item');
    return response.json();
  },

  async updateBudgetItem(id: number, data: { name?: string; category?: string; budgeted_amount?: number; grant_id?: number; remarks?: string }): Promise<BudgetItem> {
    try {
      const response = await fetch(`${API_BASE_URL}/api/budget-items/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error('Update budget item error:', {
          status: response.status,
          statusText: response.statusText,
          error: errorText,
          url: `${API_BASE_URL}/api/budget-items/${id}`,
          data: data
        });
        throw new Error(`Failed to update budget item: ${response.status} ${response.statusText}`);
      }
      
      return response.json();
    } catch (error) {
      console.error('Network error during budget item update:', error);
      throw error;
    }
  },

  async deleteBudgetItem(id: number): Promise<void> {
    try {
      const response = await fetch(`${API_BASE_URL}/api/budget-items/${id}`, {
        method: 'DELETE',
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error('Delete budget item error:', {
          status: response.status,
          statusText: response.statusText,
          error: errorText,
          url: `${API_BASE_URL}/api/budget-items/${id}`
        });
        throw new Error(`Failed to delete budget item: ${response.status} ${response.statusText}`);
      }
    } catch (error) {
      console.error('Network error during budget item deletion:', error);
      throw error;
    }
  },

  // Grants
  async getGrants(): Promise<Grant[]> {
    console.log('Fetching grants from:', `${API_BASE_URL}/api/grants`);
    try {
      const response = await fetch(`${API_BASE_URL}/api/grants`);
      console.log('Grants response status:', response.status);
      if (!response.ok) {
        const errorText = await response.text();
        console.error('Grants fetch failed:', response.status, response.statusText, errorText);
        throw new Error(`Failed to fetch grants: ${response.status} ${response.statusText}`);
      }
      const data = await response.json();
      console.log('Grants response:', data);
      return data;
    } catch (error) {
      console.error('Grants fetch error:', error);
      if (error instanceof TypeError && error.message.includes('Failed to fetch')) {
        throw new Error('Network error: Unable to connect to the server for grants.');
      }
      throw error;
    }
  },

  async createGrant(data: { name: string; total_amount: number; start_date: string; end_date: string; status?: string; grant_code?: string }): Promise<Grant> {
    const response = await fetch(`${API_BASE_URL}/api/grants`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });

    if (!response.ok) throw new Error('Failed to create grant');
    return response.json();
  },

  async updateGrant(id: number, data: { name?: string; total_amount?: number; start_date?: string; end_date?: string; status?: string; grant_code?: string }): Promise<Grant> {
    const response = await fetch(`${API_BASE_URL}/api/grants/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });

    if (!response.ok) throw new Error('Failed to update grant');
    return response.json();
  },

  // Categories
  async getCategories(): Promise<Category[]> {
    const response = await fetch(`${API_BASE_URL}/api/categories`);
    if (!response.ok) throw new Error('Failed to fetch categories');
    return response.json();
  },

  async createCategory(data: { name: string; description?: string }): Promise<Category> {
    const response = await fetch(`${API_BASE_URL}/api/categories`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });

    if (!response.ok) throw new Error('Failed to create category');
    return response.json();
  },

  async updateCategory(id: number, data: { name?: string; description?: string }): Promise<Category> {
    const response = await fetch(`${API_BASE_URL}/api/categories/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });

    if (!response.ok) throw new Error('Failed to update category');
    return response.json();
  },

  async deleteCategory(id: number): Promise<void> {
    const response = await fetch(`${API_BASE_URL}/api/categories/${id}`, {
      method: 'DELETE',
    });

    if (!response.ok) throw new Error('Failed to delete category');
  },

  // Allocations
  async getAllocations(): Promise<Allocation[]> {
    const response = await fetch(`${API_BASE_URL}/api/allocations`);
    if (!response.ok) throw new Error('Failed to fetch allocations');
    return response.json();
  },

  async getAllocationsWithDetails(): Promise<AllocationDetail[]> {
    const response = await fetch(`${API_BASE_URL}/api/allocations/details`);
    if (!response.ok) throw new Error('Failed to fetch allocation details');
    return response.json();
  },

  async createAllocation(data: Allocation): Promise<any> {
    try {
      console.log('Creating allocation:', data);
      console.log('API URL:', `${API_BASE_URL}/api/allocations`);
      
      const response = await fetch(`${API_BASE_URL}/api/allocations`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });
      
      console.log('Response status:', response.status);
      console.log('Response ok:', response.ok);
      
      if (!response.ok) {
        const errorText = await response.text();
        console.error('API Error Response:', errorText);
        throw new Error(`API Error: ${response.status} - ${errorText}`);
      }
      
      const result = await response.json();
      console.log('Create allocation success:', result);
      return result;
    } catch (error) {
      console.error('Create allocation error:', error);
      throw error;
    }
  },

  async createBatchAllocations(data: Allocation[]): Promise<any> {
    const response = await fetch(`${API_BASE_URL}/api/allocations/batch`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });

    if (!response.ok) throw new Error('Failed to create batch allocations');
    return response.json();
  },

  async updateAllocation(allocationId: number, data: Partial<Allocation>): Promise<any> {
    try {
      console.log('Updating allocation:', allocationId, data);
      
      const response = await fetch(`${API_BASE_URL}/api/allocations/${allocationId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });
      
      console.log('Update response status:', response.status);
      
      if (!response.ok) {
        const errorText = await response.text();
        console.error('Update API Error Response:', errorText);
        throw new Error(`Update API Error: ${response.status} - ${errorText}`);
      }
      
      const result = await response.json();
      console.log('Update allocation success:', result);
      return result;
    } catch (error) {
      console.error('Update allocation error:', error);
      throw error;
    }
  },

  async deleteAllocation(allocationId: number): Promise<any> {
    try {
      console.log('Deleting allocation:', allocationId);
      
      const response = await fetch(`${API_BASE_URL}/api/allocations/${allocationId}`, {
        method: 'DELETE',
      });
      
      console.log('Delete response status:', response.status);
      
      if (!response.ok) {
        const errorText = await response.text();
        console.error('Delete API Error Response:', errorText);
        throw new Error(`Delete API Error: ${response.status} - ${errorText}`);
      }
      
      console.log('Delete allocation success');
      return true;
    } catch (error) {
      console.error('Delete allocation error:', error);
      throw error;
    }
  },

  // Reports
  async getCrossTable(startDate: string, endDate: string): Promise<any> {
    const response = await fetch(`${API_BASE_URL}/api/reports/cross-table?start_date=${startDate}&end_date=${endDate}`);
    if (!response.ok) throw new Error('Failed to fetch cross table');
    return response.json();
  },

  async getCategoryCrossTable(startDate: string, endDate: string): Promise<any> {
    const response = await fetch(`${API_BASE_URL}/api/reports/category-cross-table?start_date=${startDate}&end_date=${endDate}`);
    if (!response.ok) throw new Error('Failed to fetch category cross table');
    return response.json();
  },

  // CSV Export/Import
  async exportGrantsBudgetAllocations(): Promise<Blob> {
    const response = await fetch(`${API_BASE_URL}/api/export/grants-budget-allocations`);
    if (!response.ok) throw new Error('Failed to export data');
    return response.blob();
  },

  async exportAllData(startDate?: string, endDate?: string): Promise<Blob> {
    const params = new URLSearchParams();
    if (startDate) params.append('start_date', startDate);
    if (endDate) params.append('end_date', endDate);
    
    const url = params.toString() 
      ? `${API_BASE_URL}/api/export/all-data?${params}` 
      : `${API_BASE_URL}/api/export/all-data`;
    
    const response = await fetch(url);
    if (!response.ok) throw new Error('Failed to export all data');
    return response.blob();
  },

  async exportAllocations(startDate?: string, endDate?: string): Promise<Blob> {
    const params = new URLSearchParams();
    if (startDate) params.append('start_date', startDate);
    if (endDate) params.append('end_date', endDate);
    
    const url = params.toString() 
      ? `${API_BASE_URL}/api/export/allocations?${params}` 
      : `${API_BASE_URL}/api/export/allocations`;
    
    const response = await fetch(url);
    if (!response.ok) throw new Error('Failed to export allocations');
    return response.blob();
  },

  async importGrantsBudgetAllocations(file: File): Promise<any> {
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(`${API_BASE_URL}/api/import/grants-budget-allocations`, {
      method: 'POST',
      body: formData,
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Failed to import data: ${response.status} ${response.statusText} - ${errorText}`);
    }
    return response.json();
  },

  async importAllocations(file: File): Promise<any> {
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(`${API_BASE_URL}/api/import/allocations`, {
      method: 'POST',
      body: formData,
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Failed to import allocations: ${response.status} ${response.statusText} - ${errorText}`);
    }
    return response.json();
  },

  // 完全置換モードでの割当インポート（差分更新方式）
  async importAllocationsReplace(file: File, previewOnly: boolean = false, backupBeforeImport: boolean = true): Promise<any> {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('preview_only', previewOnly.toString());
    formData.append('backup_before_import', backupBeforeImport.toString());

    const response = await fetch(`${API_BASE_URL}/api/import/allocations/replace`, {
      method: 'POST',
      body: formData,
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Failed to import allocations (replace mode): ${response.status} ${response.statusText} - ${errorText}`);
    }
    return response.json();
  },

  // バックアップ関連の関数
  async getAllocationBackups(): Promise<any> {
    try {
      const response = await fetch(`${API_BASE_URL}/api/allocations/backup/list`);
      if (!response.ok) {
        console.warn(`Backup API not available: ${response.status} ${response.statusText}`);
        return { backups: [] }; // 空の結果を返す
      }
      return response.json();
    } catch (error) {
      console.warn('Backup API not available:', error);
      return { backups: [] }; // エラー時も空の結果を返す
    }
  },

  async restoreAllocationBackup(backupId: string): Promise<any> {
    const response = await fetch(`${API_BASE_URL}/api/allocations/backup/restore/${backupId}`, {
      method: 'POST',
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Failed to restore allocation backup: ${response.status} ${response.statusText} - ${errorText}`);
    }
    return response.json();
  },

  async importGrantsBudget(file: File): Promise<any> {
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(`${API_BASE_URL}/api/import/grants-budget`, {
      method: 'POST',
      body: formData,
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Failed to import grants and budget items: ${response.status} ${response.statusText} - ${errorText}`);
    }
    return response.json();
  },

  // Dashboard Stats
  async getDashboardStats(): Promise<{
    totalTransactions: number;
    totalAmount: number;
    allocatedTransactions: number;
    unallocatedTransactions: number;
  }> {
    const response = await fetch(`${API_BASE_URL}/api/dashboard/stats`);
    if (!response.ok) throw new Error('Failed to fetch dashboard stats');
    return response.json();
  },

  async detectFileType(file: File): Promise<string> {
    const text = await file.text();
    
    // BOMを削除
    const cleanText = text.startsWith('\ufeff') ? text.slice(1) : text;
    
    // ファイル内容を分析してタイプを判定
    if (cleanText.includes('[助成金データ]') && cleanText.includes('[予算項目データ]')) {
      if (cleanText.includes('[割当データ]')) {
        return 'grants-budget-allocations';
      } else {
        return 'grants-budget';
      }
    } else if (cleanText.includes('ID,取引ID,予算項目ID,金額')) {
      return 'allocations';
    } else {
      return 'unknown';
    }
  },

  async previewGrantsBudgetAllocations(file: File): Promise<any> {
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(`${API_BASE_URL}/api/preview/grants-budget-allocations`, {
      method: 'POST',
      body: formData,
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Failed to preview data: ${response.status} ${response.statusText} - ${errorText}`);
    }
    return response.json();
  },

  // freee同期履歴を取得
  async getFreeSyncs(): Promise<FreeeSync[]> {
    const response = await fetch(`${API_BASE_URL}/api/freee/syncs`);
    if (!response.ok) {
      throw new Error(`Failed to fetch freee syncs: ${response.status} ${response.statusText}`);
    }
    return response.json();
  },

  // GitHubのコミット履歴を取得
  async getGitHubCommits(limit: number = 20): Promise<GitHubCommit[]> {
    try {
      const response = await fetch(`https://api.github.com/repos/tanaka-naoki/nagaiku-budget/commits?per_page=${limit}`);
      if (!response.ok) {
        if (response.status === 404) {
          // リポジトリが存在しない場合は空配列を返す
          return [];
        }
        throw new Error(`Failed to fetch GitHub commits: ${response.status} ${response.statusText}`);
      }
      return response.json();
    } catch (error) {
      console.error('GitHub commits fetch error:', error);
      return []; // エラーの場合は空配列を返す
    }
  },

  // GitHubのリリース情報を取得
  async getGitHubReleases(limit: number = 10): Promise<GitHubRelease[]> {
    try {
      const response = await fetch(`https://api.github.com/repos/tanaka-naoki/nagaiku-budget/releases?per_page=${limit}`);
      if (!response.ok) {
        if (response.status === 404) {
          // リポジトリにリリースが存在しない場合は空配列を返す
          return [];
        }
        throw new Error(`Failed to fetch GitHub releases: ${response.status} ${response.statusText}`);
      }
      return response.json();
    } catch (error) {
      console.error('GitHub releases fetch error:', error);
      return []; // エラーの場合は空配列を返す
    }
  },

  // 現在のコミットハッシュを取得（本番環境のバージョン識別用）
  async getCurrentCommit(): Promise<{
    commit: string;
    commitShort: string;
    commitDate: string;
    commitMessage: string;
    branch: string;
    timestamp: string;
  }> {
    try {
      const response = await fetch('/api/version');
      if (response.ok) {
        return await response.json();
      }
    } catch (error) {
      console.error('Failed to fetch current commit:', error);
    }
    return {
      commit: 'unknown',
      commitShort: 'unknown',
      commitDate: 'unknown',
      commitMessage: 'unknown',
      branch: 'unknown',
      timestamp: new Date().toISOString(),
    };
  },

  // Freee file box functions
  async getFreeeReceipts(dealId: string): Promise<any> {
    const response = await fetch(`${API_BASE_URL}/api/freee/receipts/${dealId}`);
    
    if (!response.ok) {
      throw new Error('ファイルボックス情報の取得に失敗しました');
    }
    
    return response.json();
  },

  async getFreeeReceiptDetail(receiptId: string): Promise<any> {
    const response = await fetch(`${API_BASE_URL}/api/freee/receipt/${receiptId}`);
    
    if (!response.ok) {
      throw new Error('ファイル詳細情報の取得に失敗しました');
    }
    
    return response.json();
  },

  async getFreeeDealDetail(dealId: string): Promise<any> {
    const response = await fetch(`${API_BASE_URL}/api/freee/deal/${dealId}`);
    
    if (!response.ok) {
      throw new Error('取引詳細情報の取得に失敗しました');
    }
    
    return response.json();
  },

  // Admin functions
  async resetAllData(): Promise<{message: string}> {
    const response = await fetch(`${API_BASE_URL}/api/admin/reset-all-data`, {
      method: 'DELETE'
    });
    
    if (!response.ok) {
      throw new Error('データのリセットに失敗しました');
    }
    
    return response.json();
  },
};