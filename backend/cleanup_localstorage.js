// localStorageクリーンアップスクリプト
// このスクリプトはブラウザのコンソールで実行することで、
// 古いlocalStorageデータをクリアします

// すべてのlocalStorageデータをクリア
localStorage.clear();

// sessionStorageもクリア（念のため）
sessionStorage.clear();

console.log('すべてのストレージデータをクリアしました。');
console.log('ページをリロードしてください。');