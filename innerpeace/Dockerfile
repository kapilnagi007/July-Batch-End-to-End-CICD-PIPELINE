#Stage 1

# Build the react application
FROM node:20-alpine AS builder

WORKDIR /app


# Copy package files
COPY package.*json ./

# Install dependencies
RUN npm ci --legacy-peer-deps

# Copy application source
COPY . .


# Build React app

ENV DISABLE_ESLINT_PLUGIN=true
RUN npm run build


# --------------------------------


# Stage 2
FROM nginx:alpine


# Copy builder output
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port
EXPOSE 80


# Start Nginx
CMD [ "nginx", "-g", "daemon off;" ]


