import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import "@/lib/ag-grid-setup";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "NPO予算管理システム - ながいく",
  description: "NPO法人ながいくの予算管理システム",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ja">
      <body className={inter.className}>
        <div className="min-h-screen bg-gray-50">
          <nav className="bg-white shadow-sm border-b">
            <div className="w-[90%] mx-auto px-4">
              <div className="flex justify-between h-16">
                <div className="flex items-center">
                  <h1 className="text-xl font-semibold text-gray-900">
                    NPO予算管理システム - ながいく
                  </h1>
                </div>
                <div className="flex items-center space-x-4">
                  <a href="/" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    ダッシュボード
                  </a>
                  <a href="/transactions" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    取引一覧
                  </a>
                  <a href="/batch-allocate" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    一括割当
                  </a>
                  <a href="/allocations" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    割当データ
                  </a>
                  <a href="/grants" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    助成金管理
                  </a>
                  <a href="/csv" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    CSV管理
                  </a>
                  <a href="/freee" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    freee連携
                  </a>
                  <a href="/reports" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    レポート
                  </a>
                  <a href="/wam-report" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    WAM報告書
                  </a>
                  <a href="/settings" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    設定
                  </a>
                </div>
              </div>
            </div>
          </nav>
          <main className="w-[90%] mx-auto py-2">
            {children}
          </main>
        </div>
      </body>
    </html>
  );
}
