/** @type {import('next').NextConfig} */
const nextConfig = {
  // 開発・本番共通でサブパス設定
  basePath: '/budget',
  trailingSlash: false,
  
  env: {
    // 統一API URL設定（環境変数優先、デフォルトはHTTPS）
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL || 'https://nagaiku.top/budget'
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
  
  // 本番環境でのWebSocket無効化
  webpack: (config, { dev, isServer }) => {
    if (!dev && !isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        net: false,
        tls: false,
        crypto: false,
        stream: false,
        url: false,
        zlib: false,
        http: false,
        https: false,
        assert: false,
        os: false,
        path: false,
      };
    }
    return config;
  },
  // CORS対応
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: `${process.env.NEXT_PUBLIC_API_URL || 'https://nagaiku.top/budget'}/api/:path*`,
      },
    ]
  },
  
  // nginx側でリダイレクト処理されるため、Next.js側でのリダイレクトは不要
}

module.exports = nextConfig
