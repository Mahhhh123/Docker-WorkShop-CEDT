FROM node:20.11-slim AS builder
WORKDIR /app
COPY app/package*.json ./
RUN npm ci --only=production
COPY app/ ./

FROM node:20.11-slim
WORKDIR /app
COPY --from=builder /app ./
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"
CMD ["node", "src/index.js"]
