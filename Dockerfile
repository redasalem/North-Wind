# Monolith: Vite frontend + Express API. Build from repo root
# Single builder stage to reduce peak memory on constrained hosts (e.g. Railway free tier)

# --- Stage 1: build everything sequentially ---
FROM node:22-bookworm-slim AS builder
RUN corepack enable && corepack prepare pnpm@9 --activate
ENV NODE_OPTIONS=--max-old-space-size=384

# Build frontend first
WORKDIR /app/frontend
COPY frontend/package.json frontend/pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY frontend/ ./
ENV VITE_API_URL=
ARG VITE_CLERK_PUBLISHABLE_KEY
ENV VITE_CLERK_PUBLISHABLE_KEY=$VITE_CLERK_PUBLISHABLE_KEY
RUN pnpm run build

# Clean up frontend node_modules to free memory before backend build
RUN rm -rf node_modules

# Build backend
WORKDIR /app/backend
COPY backend/package.json backend/pnpm-lock.yaml backend/pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile
COPY backend/ ./
RUN pnpm run build

# --- Stage 2: runtime image (only prod deps + built assets) ---
FROM node:22-bookworm-slim AS runner
RUN corepack enable && corepack prepare pnpm@9 --activate
WORKDIR /app
ENV NODE_ENV=production

COPY backend/package.json backend/pnpm-lock.yaml backend/pnpm-workspace.yaml ./
RUN pnpm install --prod --frozen-lockfile && pnpm store prune

COPY --from=builder /app/backend/dist ./dist
COPY --from=builder /app/frontend/dist ./public

EXPOSE 3001
USER node

CMD ["node", "dist/index.js"]