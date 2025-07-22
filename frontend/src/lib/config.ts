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

// API URL設定を動的に決定
const getApiUrl = (): string => {
  // デバッグ情報を詳細に出力
  console.log('🔍 API URL Detection Debug:', {
    'process.env.NEXT_PUBLIC_API_URL': process.env.NEXT_PUBLIC_API_URL,
    'process.env.NODE_ENV': process.env.NODE_ENV,
    'process.env.NEXT_PUBLIC_ENVIRONMENT': process.env.NEXT_PUBLIC_ENVIRONMENT,
    'window.location.hostname': typeof window !== 'undefined' ? window.location.hostname : 'server-side',
    'window.location.port': typeof window !== 'undefined' ? window.location.port : 'server-side',
    'window.location.href': typeof window !== 'undefined' ? window.location.href : 'server-side'
  });

  // 環境変数が明示的に設定されている場合はそれを使用
  if (process.env.NEXT_PUBLIC_API_URL) {
    console.log('🔧 Using explicit API URL from env:', process.env.NEXT_PUBLIC_API_URL);
    return process.env.NEXT_PUBLIC_API_URL;
  }

  // 本番環境判定（複数の条件でチェック）
  const isProduction = 
    process.env.NODE_ENV === 'production' ||
    process.env.NEXT_PUBLIC_ENVIRONMENT === 'production' ||
    (typeof window !== 'undefined' && window.location.hostname === '160.251.170.97');

  // フロントエンドのポートから環境を判定
  const isDevFrontend = typeof window !== 'undefined' && 
    (window.location.port === '3001' || window.location.port === '3002' || window.location.port === '3003');

  // 開発環境判定を強化
  const isDevelopment = !isProduction || isDevFrontend;

  // APIホストを取得（環境変数またはデフォルト値）
  const apiHost = process.env.NEXT_PUBLIC_API_HOST || 'nagaiku.top';
  
  // 本番環境: 8000ポート、開発環境: 8001ポート
  const apiUrl = (isProduction && !isDevFrontend)
    ? `http://${apiHost}:8000`
    : `http://${apiHost}:8001`;

  // デバッグ情報をコンソールに出力
  console.log('🌐 Environment detection result:', {
    NODE_ENV: process.env.NODE_ENV,
    NEXT_PUBLIC_ENVIRONMENT: process.env.NEXT_PUBLIC_ENVIRONMENT,
    NEXT_PUBLIC_API_HOST: process.env.NEXT_PUBLIC_API_HOST,
    apiHost,
    hostname: typeof window !== 'undefined' ? window.location.hostname : 'server',
    port: typeof window !== 'undefined' ? window.location.port : 'server',
    isProduction,
    isDevFrontend,
    isDevelopment,
    selectedApiUrl: apiUrl,
    timestamp: new Date().toISOString()
  });

  return apiUrl;
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