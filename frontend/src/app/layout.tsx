import type { Metadata } from "next";
import { Inter } from "next/font/google";
import Link from "next/link";
import "./globals.css";
import "@/lib/ag-grid-setup";
import EnvironmentBanner from "@/components/EnvironmentBanner";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "NPO予算管理システム - ながいく",
  description: "NPO法人ながいくの予算管理システム",
  icons: {
    icon: '/budget/favicon.ico',
  },
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
          <EnvironmentBanner />
          <nav className="bg-white shadow-sm border-b">
            <div className="w-[90%] mx-auto px-4">
              <div className="flex justify-between h-16">
                <div className="flex items-center">
                  <h1 className="text-xl font-semibold text-gray-900">
                    NPO予算管理システム - ながいく
                  </h1>
                </div>
                <div className="flex items-center space-x-4">
                  <Link href="/" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    ダッシュボード
                  </Link>
                  <Link href="/transactions" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    取引一覧
                  </Link>
                  <Link href="/batch-allocate" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    一括割当
                  </Link>
                  <Link href="/allocations" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    割当データ
                  </Link>
                  <Link href="/grants" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    助成金管理
                  </Link>
                  <Link href="/csv" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    CSV管理
                  </Link>
                  <Link href="/freee" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    freee連携
                  </Link>
                  <Link href="/reports" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    レポート
                  </Link>
                  <Link href="/wam-report" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    WAM報告書
                  </Link>
                  <Link href="/settings" className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    設定
                  </Link>
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
