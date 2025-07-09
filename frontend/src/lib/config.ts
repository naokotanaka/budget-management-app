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