'use client';

import React, { useState, useCallback } from 'react';
import { useDropzone } from 'react-dropzone';
import { api } from '@/lib/api';

const ImportPage: React.FC = () => {
  const [previewData, setPreviewData] = useState<any>(null);
  const [importResult, setImportResult] = useState<any>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const onDrop = useCallback(async (acceptedFiles: File[]) => {
    if (acceptedFiles.length === 0) return;

    const file = acceptedFiles[0];
    setIsLoading(true);
    setError(null);

    try {
      // まずプレビューを取得
      const preview = await api.previewTransactions(file);
      setPreviewData(preview);
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'ファイルの読み込みに失敗しました。CSVファイルか確認してください。';
      setError(errorMessage);
      console.error('Preview error:', err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'text/csv': ['.csv'],
      'application/vnd.ms-excel': ['.xls'],
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': ['.xlsx']
    },
    maxFiles: 1
  });

  const handleImport = async () => {
    if (!previewData) return;

    setIsLoading(true);
    setError(null);

    try {
      // 同じファイルを再度取得してインポート
      const fileInput = document.querySelector('input[type="file"]') as HTMLInputElement;
      const file = fileInput?.files?.[0];
      
      if (!file) {
        setError('ファイルが見つかりません。再度ファイルを選択してください。');
        return;
      }

      const result = await api.importTransactions(file);
      setImportResult(result);
      setPreviewData(null); // プレビューをクリア
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'インポートに失敗しました。';
      setError(errorMessage);
      console.error('Import error:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const resetState = () => {
    setPreviewData(null);
    setImportResult(null);
    setError(null);
  };

  return (
    <div className="px-4 py-6 sm:px-0">
      <div className="border-b border-gray-200 pb-4 mb-6">
        <h1 className="text-2xl font-bold text-gray-900">CSV取込</h1>
        <p className="mt-2 text-sm text-gray-600">
          freeeから出力したCSVファイルを取り込みます。【事】【管】で始まる勘定科目のみが取り込まれます。
        </p>
      </div>

      {/* ファイルドロップエリア */}
      <div className="mb-8">
        <div
          {...getRootProps()}
          className={`border-2 border-dashed rounded-lg p-8 text-center cursor-pointer transition-colors ${
            isDragActive 
              ? 'border-blue-400 bg-blue-50' 
              : 'border-gray-300 hover:border-gray-400'
          }`}
        >
          <input {...getInputProps()} />
          <div className="space-y-2">
            <svg className="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
              <path
                d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
            <div className="text-lg font-medium text-gray-900">
              {isDragActive ? 'ファイルをドロップしてください' : 'freeeのCSVファイルをドロップ'}
            </div>
            <p className="text-sm text-gray-600">
              またはクリックしてファイルを選択
            </p>
            <p className="text-xs text-gray-500">
              CSV, XLS, XLSX ファイルに対応
            </p>
          </div>
        </div>
      </div>

      {/* ローディング */}
      {isLoading && (
        <div className="text-center py-8">
          <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          <p className="mt-2 text-sm text-gray-600">処理中...</p>
        </div>
      )}

      {/* エラー */}
      {error && (
        <div className="bg-red-50 border border-red-200 rounded-md p-4 mb-6">
          <div className="flex">
            <svg className="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
            </svg>
            <div className="ml-3">
              <p className="text-sm text-red-800">{error}</p>
            </div>
          </div>
        </div>
      )}

      {/* プレビューデータ */}
      {previewData && (
        <div className="bg-white shadow rounded-lg mb-6">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-medium text-gray-900">プレビュー</h3>
            <p className="mt-1 text-sm text-gray-600">
              全 {previewData.total_rows} 行中、{previewData.filtered_rows} 行が取り込み対象です（【事】【管】のみ）
            </p>
          </div>
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    ID
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    取引日
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    取引内容
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    金額
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    勘定科目
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    取引先
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {previewData.preview.map((row: any, index: number) => (
                  <tr key={index} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {row.id}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {row.date}
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {row.description}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right">
                      {row.amount.toLocaleString()}円
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {row.account}
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {row.supplier}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className="px-6 py-4 border-t border-gray-200 flex justify-end space-x-3">
            <button
              onClick={resetState}
              className="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50"
            >
              キャンセル
            </button>
            <button
              onClick={handleImport}
              disabled={isLoading}
              className="px-4 py-2 bg-blue-600 text-white rounded-md text-sm font-medium hover:bg-blue-700 disabled:opacity-50"
            >
              {isLoading ? '取込中...' : '取り込み実行'}
            </button>
          </div>
        </div>
      )}

      {/* インポート結果 */}
      {importResult && (
        <div className="bg-green-50 border border-green-200 rounded-md p-4">
          <div className="flex">
            <svg className="h-5 w-5 text-green-400" viewBox="0 0 20 20" fill="currentColor">
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            <div className="ml-3">
              <p className="text-sm text-green-800 font-medium">
                取り込み完了！
              </p>
              <p className="text-sm text-green-700 mt-1">
                {importResult.message}
              </p>
              <div className="mt-3">
                <a
                  href="/transactions"
                  className="text-sm text-green-600 hover:text-green-500 font-medium"
                >
                  取引一覧を確認する →
                </a>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ImportPage;