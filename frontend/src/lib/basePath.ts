// basePathヘルパー関数
export const getBasePath = () => {
  // 本番環境では/budgetを追加、開発環境では何もしない
  return process.env.NODE_ENV === 'production' ? '/budget' : '';
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