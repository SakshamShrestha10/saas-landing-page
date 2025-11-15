# --- Stage 1: Build ---
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package manifest files
COPY package*.json ./
# (If you're using yarn, copy yarn.lock instead)

# Install dependencies
RUN npm install

# Copy rest of the source code
COPY . .

# Build for production
RUN npm run build

# --- Stage 2: Serve with Nginx ---
FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# (Optional) If you have a custom nginx config, copy it
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
