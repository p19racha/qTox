#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright © 2025 qTox Ubuntu Modernization Project

# Quick build script for qTox Modern UI

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if preview mode
PREVIEW_MODE=false
CLEAN_BUILD=false
BUILD_TYPE="Release"

while [[ $# -gt 0 ]]; do
    case $1 in
        --preview)
            PREVIEW_MODE=true
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --debug)
            BUILD_TYPE="Debug"
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --preview    Build QML preview app only (fast, for UI development)"
            echo "  --clean      Clean build directories before building"
            echo "  --debug      Build in Debug mode (default: Release)"
            echo "  --help       Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                    # Build full qTox (Release)"
            echo "  $0 --preview          # Build QML preview app"
            echo "  $0 --clean --debug    # Clean build in Debug mode"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check prerequisites
print_header "Checking Prerequisites"

check_command() {
    if command -v $1 &> /dev/null; then
        print_success "$1 found"
        return 0
    else
        print_error "$1 not found"
        return 1
    fi
}

MISSING_DEPS=false

check_command cmake || MISSING_DEPS=true
check_command make || MISSING_DEPS=true
check_command pkg-config || MISSING_DEPS=true

# Check Qt6
if pkg-config --exists Qt6Core Qt6Qml Qt6Quick; then
    QT_VERSION=$(pkg-config --modversion Qt6Core)
    print_success "Qt6 found (version $QT_VERSION)"
else
    print_error "Qt6 with QML/Quick not found"
    print_warning "Install with: sudo apt install qt6-declarative-dev qml6-module-qtquick-controls"
    MISSING_DEPS=true
fi

if [ "$MISSING_DEPS" = true ]; then
    print_error "Missing dependencies. Please install required packages."
    echo ""
    echo "Run this command to install dependencies:"
    echo "  sudo apt install build-essential cmake qt6-declarative-dev qml6-module-qtquick-controls"
    exit 1
fi

# Determine build directory and options
if [ "$PREVIEW_MODE" = true ]; then
    BUILD_DIR="build-preview"
    CMAKE_OPTIONS="-DBUILD_QML_PREVIEW=ON"
    TARGET="qml_preview"
    BINARY="qml_preview"
    print_header "Building QML Preview (UI Development Mode)"
else
    BUILD_DIR="build"
    CMAKE_OPTIONS=""
    TARGET="qtox"
    BINARY="qtox"
    print_header "Building Full qTox Application"
fi

CMAKE_OPTIONS="$CMAKE_OPTIONS -DCMAKE_BUILD_TYPE=$BUILD_TYPE"

# Clean if requested
if [ "$CLEAN_BUILD" = true ]; then
    print_warning "Cleaning build directory: $BUILD_DIR"
    rm -rf "$BUILD_DIR"
fi

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure
print_header "Configuring CMake"
echo "Build type: $BUILD_TYPE"
echo "Options: $CMAKE_OPTIONS"
echo ""

if ! cmake .. $CMAKE_OPTIONS; then
    print_error "CMake configuration failed"
    exit 1
fi

print_success "CMake configuration completed"

# Build
print_header "Building"
NPROC=$(nproc)
echo "Using $NPROC parallel jobs"
echo ""

if [ "$PREVIEW_MODE" = true ]; then
    BUILD_CMD="make $TARGET -j$NPROC"
else
    BUILD_CMD="make -j$NPROC"
fi

if ! $BUILD_CMD; then
    print_error "Build failed"
    exit 1
fi

print_success "Build completed successfully"

# Summary
print_header "Build Summary"
echo "Build type: $BUILD_TYPE"
echo "Binary location: $BUILD_DIR/$BINARY"
echo ""

if [ "$PREVIEW_MODE" = true ]; then
    print_success "QML Preview app built successfully!"
    echo ""
    echo "To run the preview:"
    echo "  cd $BUILD_DIR && ./$BINARY"
    echo ""
    echo "Features:"
    echo "  - Modern UI with sample data"
    echo "  - Press Ctrl+T to toggle dark/light theme"
    echo "  - See smooth animations in action"
else
    print_success "qTox built successfully!"
    echo ""
    echo "To run qTox:"
    echo "  cd $BUILD_DIR && ./$BINARY"
    echo ""
    echo "To install system-wide:"
    echo "  cd $BUILD_DIR && sudo make install"
fi

echo ""
print_success "Done!"
