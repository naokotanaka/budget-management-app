// システム設定
export const CONFIG = {
  // デフォルト表示期間（年度：2025/4/1～2026/3/31）
  DEFAULT_DATE_RANGE: {
    START: '2025-04-01',
    END: '2026-03-31',
  },
  
  // 年度の開始月
  FISCAL_YEAR_START_MONTH: 4,
} as const;

// 年度の開始日と終了日を取得
export const getCurrentFiscalYear = () => {
  const now = new Date();
  const currentYear = now.getFullYear();
  const currentMonth = now.getMonth() + 1; // 0ベースなので+1
  
  let fiscalYear: number;
  
  // 4月以降なら当年度、3月以前なら前年度
  if (currentMonth >= CONFIG.FISCAL_YEAR_START_MONTH) {
    fiscalYear = currentYear;
  } else {
    fiscalYear = currentYear - 1;
  }
  
  return {
    start: `${fiscalYear}-04-01`,
    end: `${fiscalYear + 1}-03-31`,
  };
};

// 統一されたAPI URL設定（Mixed Content強制対応版）
const getApiUrl = (): string => {
  console.log('🔍 getApiUrl called');
  console.log('🔍 NEXT_PUBLIC_API_URL:', process.env.NEXT_PUBLIC_API_URL);
  console.log('🔍 window:', typeof window);
  
  // 環境変数が明示的に設定されている場合はそれを使用
  if (process.env.NEXT_PUBLIC_API_URL) {
    console.log('🔍 Using env var:', process.env.NEXT_PUBLIC_API_URL);
    return process.env.NEXT_PUBLIC_API_URL;
  }

  // 本番環境では常にHTTPS APIを使用（Mixed Content完全回避）
  const url = 'https://nagaiku.top/budget';
  console.log('🔍 Using default HTTPS URL:', url);
  return url;
};

export const API_CONFIG = {
  BASE_URL: getApiUrl(),
  TIMEOUT: 30000,
  RETRY_COUNT: 3
} as const;

// キャッシュバスター用のタイムスタンプ
export const CONFIG_VERSION = Date.now();

// 設定確認用のユーティリティ
export const debugApiConfig = () => {
  console.table({
    'API Base URL': API_CONFIG.BASE_URL,
    'Environment': process.env.NODE_ENV,
    'Config Version': CONFIG_VERSION,
    'Timestamp': new Date().toISOString()
  });
};