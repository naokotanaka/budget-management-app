/** @type {import('next').NextConfig} */
const nextConfig = {
  // 本番環境でサブパス設定
  basePath: process.env.NODE_ENV === 'production' ? '/budget' : '',
  trailingSlash: false,
  
  env: {
    // 環境変数から直接取得、なければデフォルト値を使用
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL || 
      (process.env.NODE_ENV === 'production' 
        ? 'http://160.251.170.97:8000'
        : 'http://160.251.170.97:8001')
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  experimental: {
    allowedDevOrigins: ['160.251.170.97:3001']
  },
  // CORS対応
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: `${process.env.NEXT_PUBLIC_API_URL || 'http://160.251.170.97:8001'}/api/:path*`,
      },
    ]
  },
}

module.exports = nextConfig
