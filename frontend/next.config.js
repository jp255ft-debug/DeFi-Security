/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  // Configuração para produção com domínio personalizado
  async rewrites() {
    const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';
    return [
      {
        source: '/api/:path*',
        destination: `${apiUrl}/api/v1/:path*`,
      },
    ];
  },
  images: {
    domains: ['localhost', 'h2vtrust.com.br', 'www.h2vtrust.com.br', 'h2v-trust-api.onrender.com'],
  },
  // Importante para o Render - usar hostname 0.0.0.0
  // hostname: '0.0.0.0',
};

module.exports = nextConfig;
