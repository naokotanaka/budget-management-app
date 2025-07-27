// basePathヘルパー関数
// 本番環境では/budgetのbasePathを使用
export const getBasePath = () => {
  // NODE_ENVがproductionで、かつブラウザ環境の場合はbasePathを判定
  if (typeof window !== 'undefined') {
    // ドメインベースでbasePath判定
    if (window.location.hostname === 'nagaiku.top') {
      return '/budget';
    }
  }
  // サーバーサイドまたは開発環境では空文字
  return '';
};

// リンク用のパスを生成
export const createPath = (path: string) => {
  const basePath = getBasePath();
  // パスが既にbasePathで始まっている場合は何もしない
  if (basePath && path.startsWith(basePath)) {
    return path;
  }
  return `${basePath}${path}`;
};

// Next.js Link コンポーネント用のヘルパー
export const linkPath = (href: string) => createPath(href);