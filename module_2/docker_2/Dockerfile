# Use an official Node.js runtime as a parent image
ARG TAG=20
FROM node:${TAG}

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Change ownership of the application directory to the non-root user 'node'
RUN chown -R node:node /app

# Expose port 3000 to allow external access to the Node.js application
EXPOSE 3000

# Use the non-root user to run your application
USER node

# Command to run the Node.js application
CMD ["node", "index.js"]

