# Building qTox with Modern UI

## Overview

This guide covers building qTox with the new modern Qt Quick/QML UI for Ubuntu Linux.

## Prerequisites

### Ubuntu 22.04 LTS or later

```bash
# Update package lists
sudo apt update

# Install build essentials
sudo apt install -y \
    build-essential \
    cmake \
    git \
    pkg-config

# Install Qt 6 (minimum 6.5 required for best QML support)
sudo apt install -y \
    qt6-base-dev \
    qt6-tools-dev \
    qt6-tools-dev-tools \
    qt6-l10n-tools \
    libqt6svg6-dev \
    qml6-module-qtquick \
    qml6-module-qtquick-controls \
    qml6-module-qtquick-layouts \
    qml6-module-qtquick-window \
    qt6-declarative-dev \
    libqt6quick6

# Install toxcore and dependencies
sudo apt install -y \
    libtoxcore-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavformat-dev \
    libavutil-dev \
    libswscale-dev \
    libexif-dev \
    libqrencode-dev \
    libsqlcipher-dev \
    libsodium-dev \
    libopus-dev \
    libvpx-dev \
    libopenal-dev \
    libv4l-dev

# Install X11 libraries for Ubuntu integration
sudo apt install -y \
    libx11-dev \
    libxss-dev

# Optional: spell checking support
sudo apt install -y \
    libkf6sonnet-dev

# Optional: for development
sudo apt install -y \
    qtcreator \
    qml6-module-qt-labs-platform
```

## Building

### Standard Build (Full qTox)

```bash
# Clone the repository (if not already done)
cd /home/racha/qTox

# Create build directory
mkdir -p build
cd build

# Configure with CMake
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DSMILEYS=ON \
    -DSPELL_CHECK=ON \
    -DUPDATE_CHECK=ON

# Build (use -j$(nproc) for parallel build)
make -j$(nproc)

# The binary will be at: build/qtox
```

### QML Preview Build (For UI Development)

Build just the modern UI preview without the full qTox backend:

```bash
# Create build directory
mkdir -p build-preview
cd build-preview

# Configure with QML preview enabled
cmake .. \
    -DCMAKE_BUILD_TYPE=Debug \
    -DBUILD_QML_PREVIEW=ON

# Build only the preview app
make qml_preview -j$(nproc)

# Run the preview
./qml_preview
```

The preview app will show the modern UI with:
- Contact list with sample data
- Chat interface with sample messages
- Theme toggle (press Ctrl+T)
- Typing indicators
- Animations

## Development Workflow

### For UI Development

1. **Use the QML Preview** - Faster iteration without full backend:
   ```bash
   cd build-preview
   make qml_preview && ./qml_preview
   ```

2. **Edit QML files** - Changes to QML files require rebuild:
   ```bash
   # After editing src/qml/*.qml files
   make qml_preview
   ./qml_preview
   ```

3. **Use Qt Creator** - Best IDE for QML development:
   ```bash
   qtcreator ../src/qml/main.qml &
   ```

### For Backend Integration

1. **Build full qTox** with QML support
2. **Edit C++ controllers** in `src/ui/`
3. **Connect to existing logic** in `src/model/`, `src/core/`, etc.

## Testing the Modern UI

### Quick Test

```bash
# Run the QML preview
cd build-preview
./qml_preview

# Test features:
# - Click contacts in the list
# - Type in the message input
# - Press Ctrl+T to toggle dark/light theme
# - Observe smooth animations
```

### Theme Testing

The theme automatically detects Ubuntu's system theme:

```bash
# Check current GNOME theme
gsettings get org.gnome.desktop.interface color-scheme

# Set dark theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Set light theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'

# Restart preview to see changes
./qml_preview
```

## Project Structure

```
qTox/
├── src/
│   ├── qml/                    # Modern UI (QML)
│   │   ├── main.qml           # Main window
│   │   ├── components/        # Reusable components
│   │   ├── pages/             # Full screens
│   │   ├── dialogs/           # Modal dialogs
│   │   └── themes/            # Theme system
│   ├── ui/                     # C++ UI controllers
│   │   └── thememanager.*     # Theme detection & management
│   ├── core/                   # Tox protocol (unchanged)
│   ├── model/                  # Data models (unchanged)
│   ├── persistence/            # Database & settings (unchanged)
│   └── widget/                 # Old Qt Widgets UI (being phased out)
├── build/                      # Standard build
├── build-preview/              # QML preview build
└── qml_preview.cpp            # Standalone QML viewer
```

## Common Issues

### "Cannot find Qt6Qml"

Install Qt6 QML modules:
```bash
sudo apt install qt6-declarative-dev qml6-module-qtquick
```

### "QML module not found"

Check QML import paths:
```bash
qml6 --list-modules
```

Install missing modules:
```bash
sudo apt install qml6-module-qtquick-controls
```

### Theme not detected

Install GNOME settings tools:
```bash
sudo apt install gsettings-desktop-schemas
```

### Black/blank window

Enable QML debugging:
```bash
QSG_INFO=1 QT_LOGGING_RULES="qt.qml*=true" ./qml_preview
```

## Performance Tips

### Build Performance

```bash
# Use ccache for faster rebuilds
sudo apt install ccache
cmake .. -DUSE_CCACHE=ON

# Use Ninja instead of Make
sudo apt install ninja-build
cmake .. -GNinja
ninja
```

### Runtime Performance

```bash
# Enable QML compiler
export QML_DISABLE_DISK_CACHE=0

# Force OpenGL rendering (usually faster)
export QT_QUICK_BACKEND=software  # or 'opengl'
```

## Next Steps

1. **Complete platform cleanup** - Finish removing all Windows/macOS code
2. **Implement remaining pages** - Settings, Profile, etc.
3. **Create C++ controllers** - Bridge QML to backend
4. **Add Ubuntu integration** - System notifications, tray icon
5. **Performance optimization** - Virtual scrolling, caching

## Useful Commands

```bash
# Clean build
rm -rf build build-preview

# Rebuild everything
mkdir build && cd build
cmake .. && make -j$(nproc)

# Install to system
sudo make install

# Run from build directory
./qtox

# QML debugging
QT_LOGGING_RULES="*.debug=true" ./qml_preview

# Check Qt version
qmake6 --version
```

## Documentation

- **Refactoring Roadmap**: See `REFACTORING_ROADMAP.md`
- **QML Components**: See `src/qml/README.md`
- **Progress Report**: See `PROGRESS_REPORT.md`
- **Original Install Guide**: See `INSTALL.md`

## Contributing

When making changes:

1. **Test with QML preview** first
2. **Follow QML coding style** in `src/qml/README.md`
3. **Use the theme system** for consistency
4. **Add smooth animations** to all interactions
5. **Test on HiDPI displays** if possible
6. **Verify dark/light themes** work correctly

## Support

For issues related to:
- **Build errors**: Check prerequisites above
- **QML issues**: See Qt documentation
- **Backend integration**: See existing codebase docs
- **Ubuntu integration**: Test with preview app first

---

**Last Updated**: October 15, 2025  
**Minimum Qt Version**: 6.5  
**Target Platform**: Ubuntu Linux 22.04+
