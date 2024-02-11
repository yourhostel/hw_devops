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

# Expose port 3000 to allow external access to the Node.js application
EXPOSE 3000

# Command to run the Node.js application
CMD ["node", "index.js"]

