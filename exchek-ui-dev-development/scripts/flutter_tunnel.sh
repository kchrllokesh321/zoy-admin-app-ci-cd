#!/bin/bash

# Flutter Web ngrok Tunnel Script
# Simple script to make Flutter web app accessible via ngrok

echo "🚀 Flutter Web ngrok Tunnel"
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to kill process on port
kill_port() {
    local port=$1
    echo -e "${YELLOW}Killing any process on port $port...${NC}"
    
    # Check OS type
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        lsof -ti:$port | xargs kill -9 2>/dev/null || true
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        lsof -ti:$port | xargs kill -9 2>/dev/null || true
    fi
}

# Default port
PORT=8080

# Check if Flutter is installed
if ! command_exists flutter; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    echo "Please install Flutter first: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check if ngrok is installed
if ! command_exists ngrok; then
    echo -e "${RED}❌ ngrok is not installed${NC}"
    echo -e "${YELLOW}Install ngrok:${NC}"
    echo "• macOS: brew install ngrok"
    echo "• Manual: https://ngrok.com/download"
    exit 1
fi

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ This doesn't appear to be a Flutter project directory${NC}"
    echo "Please run this script from your Flutter project root directory"
    exit 1
fi

echo -e "${BLUE}🧹 Cleaning Flutter project...${NC}"

# Clean Flutter project
if ! flutter clean; then
    echo -e "${RED}❌ Flutter clean failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter clean completed${NC}"

echo -e "${BLUE}📦 Getting Flutter dependencies...${NC}"

# Get Flutter dependencies
if ! flutter pub get; then
    echo -e "${RED}❌ Flutter pub get failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter dependencies retrieved${NC}"

echo -e "${BLUE}🌐 Generating internationalization files...${NC}"

# Generate internationalization files (skip if package not found)
if flutter pub run intl_utils:generate 2>/dev/null; then
    echo -e "${GREEN}✅ Internationalization files generated${NC}"
else
    echo -e "${YELLOW}⚠️ intl_utils not found or failed - skipping i18n generation${NC}"
fi

echo -e "${BLUE}🔧 Running build_runner...${NC}"

# Run build_runner (skip if package not found)
if flutter packages pub run build_runner build --delete-conflicting-outputs 2>/dev/null; then
    echo -e "${GREEN}✅ Build runner completed${NC}"
else
    echo -e "${YELLOW}⚠️ build_runner not found or failed - skipping code generation${NC}"
fi

echo -e "${BLUE}📱 Building Flutter web app...${NC}"

# Kill any existing process on the port
kill_port $PORT

# Build Flutter web app with specific target
if ! flutter build web -t lib/main/main_dev.dart; then
    echo -e "${RED}❌ Flutter build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter web build completed${NC}"

# Start HTTP server in background
echo -e "${BLUE}🌐 Starting HTTP server on port $PORT...${NC}"

cd build/web

# Start Python HTTP server
if command_exists python3; then
    echo -e "${YELLOW}Using Python3 HTTP server...${NC}"
    python3 -m http.server $PORT &
    SERVER_PID=$!
elif command_exists python; then
    echo -e "${YELLOW}Using Python HTTP server...${NC}"
    python -m http.server $PORT &
    SERVER_PID=$!
else
    echo -e "${RED}❌ Python not found${NC}"
    echo "Please install Python3"
    exit 1
fi

cd ../..

# Wait for server to start
echo -e "${YELLOW}Waiting for server to start...${NC}"
sleep 3

# Check if server is running
if ! curl -s http://localhost:$PORT >/dev/null 2>&1; then
    echo -e "${RED}❌ Server failed to start${NC}"
    kill $SERVER_PID 2>/dev/null
    exit 1
fi

echo -e "${GREEN}✅ HTTP server started successfully${NC}"

# Start ngrok tunnel
echo -e "${BLUE}🔗 Starting ngrok tunnel...${NC}"

ngrok http $PORT &
NGROK_PID=$!

# Wait for ngrok to start
sleep 5

# Get ngrok URL
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*' | grep -o 'https://[^"]*' | head -1)

if [ ! -z "$NGROK_URL" ]; then
    echo -e "${GREEN}=============================="
    echo -e "🎉 SUCCESS! Your Flutter app is live!"
    echo -e "=============================="
    echo -e "${BLUE}📱 URLs:${NC}"
    echo -e "${GREEN}Local:  http://localhost:$PORT${NC}"
    echo -e "${GREEN}Public: $NGROK_URL${NC}"
    echo -e "${YELLOW}=============================="
    echo -e "📋 Instructions:"
    echo -e "• Share the Public URL to test on any PC/mobile"
    echo -e "• Press Ctrl+C to stop all services"
    echo -e "• ngrok dashboard: http://localhost:4040"
    echo -e "=============================="
    
    # Save URL to file
    echo "$NGROK_URL" > ngrok_url.txt
    echo -e "${BLUE}💾 URL saved to: ngrok_url.txt${NC}"
else
    echo -e "${RED}❌ Failed to get ngrok URL${NC}"
    echo -e "${YELLOW}Check ngrok dashboard at: http://localhost:4040${NC}"
    echo -e "${BLUE}Local URL: http://localhost:$PORT${NC}"
fi

# Cleanup function
cleanup() {
    echo -e "\n${YELLOW}🛑 Stopping all services...${NC}"
    
    # Kill background processes
    kill $SERVER_PID 2>/dev/null && echo -e "${GREEN}✅ HTTP server stopped${NC}"
    kill $NGROK_PID 2>/dev/null && echo -e "${GREEN}✅ ngrok stopped${NC}"
    
    # Clean up files
    rm -f ngrok_url.txt
    
    echo -e "${GREEN}🎉 All services stopped successfully!${NC}"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Keep the script running
echo -e "${BLUE}🔄 Services are running... Press Ctrl+C to stop${NC}"

# Wait for user interrupt
while true; do
    sleep 1
done