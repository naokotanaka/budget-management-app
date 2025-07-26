// basePathヘルパー関数
// 本番環境ではNext.jsが自動的にbasePathを処理するので、ここでは追加しない
export const getBasePath = () => {
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