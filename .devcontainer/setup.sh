#!/bin/bash
# Dev Container / Codespaces Setup Script
# Runs once when the container is first created (postCreateCommand).
set -euo pipefail

echo "🎁 Setting up Zava Gift Exchange development environment..."
echo ""

echo "📦 Installing frontend dependencies..."
npm ci || npm install
echo "✅ Frontend dependencies installed"

echo "📦 Installing API dependencies..."
(cd api && npm ci) || (cd api && npm install)
echo "✅ API dependencies installed"

echo "🔧 Creating local API settings..."
node scripts/setup-local-settings.js
echo "✅ Local settings created"

echo "🎭 Installing Playwright browsers..."
npx playwright install --with-deps chromium
echo "✅ Playwright ready"

echo ""
echo "════════════════════════════════════════════"
echo "✅ Setup complete!"
echo ""
echo "  🚀 Press F5 to start debugging"
echo "  🌐 Frontend: http://localhost:5173"
echo "  ⚡ API:      http://localhost:7071"
echo "════════════════════════════════════════════"