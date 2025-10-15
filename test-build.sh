#!/bin/bash
# Test build script for qTox Ubuntu Edition
# Checks dependencies and attempts a test build

set -e  # Exit on error

echo "============================================"
echo "qTox 2.0 Ubuntu Build Test"
echo "============================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if package is installed
check_package() {
    if dpkg -l | grep -q "^ii  $1 "; then
        echo -e "${GREEN}✓${NC} $1 installed"
        return 0
    else
        echo -e "${RED}✗${NC} $1 NOT installed"
        return 1
    fi
}

# Function to check if command exists
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 found: $(which $1)"
        return 0
    else
        echo -e "${RED}✗${NC} $1 NOT found"
        return 1
    fi
}

echo "Step 1: Checking build tools..."
echo "--------------------------------"
check_command cmake
check_command gcc
check_command g++
check_command pkg-config
check_command git
echo ""

echo "Step 2: Checking Qt6 packages..."
echo "---------------------------------"
MISSING_QT=0
check_package qt6-base-dev || MISSING_QT=1
check_package qt6-declarative-dev || MISSING_QT=1
check_package qt6-multimedia-dev || MISSING_QT=1
check_package libqt6svg6-dev || MISSING_QT=1
echo ""

echo "Step 3: Checking qTox dependencies..."
echo "--------------------------------------"
MISSING_DEPS=0
check_package libtoxcore-dev || MISSING_DEPS=1
check_package libsqlcipher-dev || MISSING_DEPS=1
check_package libavcodec-dev || MISSING_DEPS=1
check_package libavformat-dev || MISSING_DEPS=1
check_package libavutil-dev || MISSING_DEPS=1
check_package libswscale-dev || MISSING_DEPS=1
check_package libopenal-dev || MISSING_DEPS=1
check_package libqrencode-dev || MISSING_DEPS=1
check_package libx11-dev || MISSING_DEPS=1
check_package libxss-dev || MISSING_DEPS=1
echo ""

if [ $MISSING_QT -eq 1 ] || [ $MISSING_DEPS -eq 1 ]; then
    echo -e "${YELLOW}⚠ Missing dependencies detected!${NC}"
    echo ""
    echo "To install missing dependencies, run:"
    echo ""
    echo -e "${GREEN}sudo apt update && sudo apt install -y \\"
    echo "    build-essential cmake pkg-config git \\"
    echo "    qt6-base-dev qt6-declarative-dev qt6-multimedia-dev \\"
    echo "    qt6-svg-dev qt6-tools-dev libqt6opengl6-dev libqt6svg6 \\"
    echo "    libtoxcore-dev libsqlcipher-dev \\"
    echo "    libavcodec-dev libavdevice-dev libavfilter-dev \\"
    echo "    libavformat-dev libavutil-dev libswscale-dev \\"
    echo "    libopenal-dev libexif-dev libqrencode-dev \\"
    echo "    libglib2.0-dev libvpx-dev libopus-dev libsodium-dev \\"
    echo "    libx11-dev libxss-dev ccache${NC}"
    echo ""
    
    read -p "Install missing dependencies now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing dependencies..."
        sudo apt update
        sudo apt install -y \
            build-essential cmake pkg-config git \
            qt6-base-dev qt6-declarative-dev qt6-multimedia-dev \
            qt6-svg-dev qt6-tools-dev libqt6opengl6-dev libqt6svg6 \
            libtoxcore-dev libsqlcipher-dev \
            libavcodec-dev libavdevice-dev libavfilter-dev \
            libavformat-dev libavutil-dev libswscale-dev \
            libopenal-dev libexif-dev libqrencode-dev \
            libglib2.0-dev libvpx-dev libopus-dev libsodium-dev \
            libx11-dev libxss-dev ccache
    else
        echo "Skipping installation. Please install dependencies manually."
        exit 1
    fi
fi

echo "Step 4: Creating test build..."
echo "-------------------------------"

# Clean up any old test builds
if [ -d "build-test" ]; then
    echo "Removing old build-test directory..."
    rm -rf build-test
fi

mkdir build-test
cd build-test

echo "Running CMake configuration..."
if cmake .. -DCMAKE_BUILD_TYPE=Debug -DUSE_CCACHE=ON 2>&1 | tee cmake-output.log; then
    echo -e "${GREEN}✓${NC} CMake configuration successful!"
else
    echo -e "${RED}✗${NC} CMake configuration failed!"
    echo "See cmake-output.log for details"
    exit 1
fi
echo ""

echo "Step 5: Attempting compilation (this may take a while)..."
echo "----------------------------------------------------------"
if make -j$(nproc) 2>&1 | tee build-output.log; then
    echo -e "${GREEN}✓${NC} Build successful!"
    echo ""
    echo "Binary location: $(pwd)/qtox"
    ls -lh qtox
else
    echo -e "${RED}✗${NC} Build failed!"
    echo "See build-output.log for details"
    exit 1
fi
echo ""

echo "Step 6: Verifying binary..."
echo "---------------------------"
if [ -f "qtox" ]; then
    echo -e "${GREEN}✓${NC} qtox binary created"
    file qtox
    echo ""
    echo "Binary size: $(du -h qtox | cut -f1)"
else
    echo -e "${RED}✗${NC} qtox binary not found!"
    exit 1
fi
echo ""

echo "============================================"
echo -e "${GREEN}✅ BUILD TEST COMPLETE!${NC}"
echo "============================================"
echo ""
echo "Summary:"
echo "  - Build directory: build-test/"
echo "  - Binary: build-test/qtox"
echo "  - Logs: build-test/{cmake,build}-output.log"
echo ""
echo "To run qTox:"
echo "  cd build-test && ./qtox"
echo ""
echo "Phase 1 validation: SUCCESS! ✨"
