# Use lightweight Node image
FROM node:18-alpine
 
# Create app directory
WORKDIR /usr/src/app
 
# Copy dependency files first (for caching)
COPY package*.json ./
 
# Install dependencies
RUN npm install --only=production
 
# Copy application code
COPY . .
 
# Expose application port
EXPOSE 3000
 
# Run the app
CMD ["node", "server.js"]