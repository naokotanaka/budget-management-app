/** @type {import('next').NextConfig} */
const nextConfig = {
  // 本番環境でサブパス設定
  basePath: process.env.NODE_ENV === 'production' ? '/budget' : '',
  trailingSlash: false,
  
  env: {
    // 環境変数から直接取得、なければデフォルト値を使用
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL || 'http://160.251.170.97:8000'
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  experimental: {
    allowedDevOrigins: ['160.251.170.97:3000']
  },
  // CORS対応
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: `${process.env.NEXT_PUBLIC_API_URL || 'http://160.251.170.97:8000'}/api/:path*`,
      },
    ]
  },
  
  // nginx側でリダイレクト処理されるため、Next.js側でのリダイレクトは不要
}

module.exports = nextConfig
