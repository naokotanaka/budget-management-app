'use client';

import { useEffect, useState } from 'react';

const EnvironmentBanner = () => {
  const [isDevDatabase, setIsDevDatabase] = useState(false);
  const [databaseInfo, setDatabaseInfo] = useState<string>('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // データベース情報を取得して判定
    const fetchDatabaseInfo = async () => {
      try {
        // APIから環境情報を取得
        const response = await fetch('/budget/api/system-info', { method: 'GET' });
        if (response.ok) {
          const data = await response.json();
          // database_nameで開発環境かどうかを判定
          const isDevDb = data.database_name && data.database_name.includes('_dev');
          setIsDevDatabase(isDevDb);
          
          if (isDevDb) {
            setDatabaseInfo(`開発DB (${data.database_name})`);
          } else if (data.database_name) {
            setDatabaseInfo(`本番DB (${data.database_name})`);
          } else {
            setDatabaseInfo(data.mode || '不明');
          }
        }
      } catch (error) {
        console.error('Failed to fetch database info:', error);
        // API取得に失敗した場合は安全のため開発環境として扱う
        setIsDevDatabase(true);
        setDatabaseInfo('データベース情報取得失敗（安全のため開発環境表示）');
      } finally {
        setLoading(false);
      }
    };

    fetchDatabaseInfo();
  }, []);

  // データベースが開発用でない場合は表示しない
  if (loading) {
    // ローディング中は一瞬も本番と誤認させないため開発環境表示
    return (
      <div className="bg-red-600 text-white text-center py-1 px-4 text-sm font-medium border-b-2 border-red-700">
        <div className="flex items-center justify-center space-x-2">
          <span>🚧</span>
          <span>【環境確認中...】</span>
          <span>🚧</span>
        </div>
      </div>
    );
  }

  if (!isDevDatabase) {
    return null;
  }

  return (
    <div className="bg-red-600 text-white text-center py-1 px-4 text-sm font-medium border-b-2 border-red-700">
      <div className="flex items-center justify-center space-x-2">
        <span>🚧</span>
        <span>【開発環境】{databaseInfo}</span>
        <span>🚧</span>
      </div>
    </div>
  );
};

export default EnvironmentBanner;