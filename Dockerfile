# -------------- Build Stage --------------
FROM node:lts-alpine AS builder

WORKDIR /app

# Copy only dependency files (faster builds via caching)
COPY package*.json ./
RUN npm install

# Copy the rest of the source code
COPY . .

# Build Vite Production bundle
RUN npm run build


# -------------- Production Stage --------------
FROM nginx:stable-alpine

# Copy built files from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 for the application
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]