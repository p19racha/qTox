#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Interactive launcher for qTox Modern UI preview applications

set -e

BUILD_DIR="/home/racha/qTox/build-preview"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear

cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║              qTox Modern UI - Interactive Launcher            ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF

echo ""
echo -e "${CYAN}Choose an application to launch:${NC}"
echo ""
echo -e "  ${GREEN}1)${NC} Chat Interface Demo (qml_preview)"
echo -e "     └─ Modern chat UI with theme toggle (Ctrl+T)"
echo ""
echo -e "  ${GREEN}2)${NC} Settings Page (settings_preview)"
echo -e "     └─ 6 complete settings categories"
echo ""
echo -e "  ${GREEN}3)${NC} Dialog System (dialogs_preview)"
echo -e "     └─ Test all dialogs with Ctrl+1-4"
echo ""
echo -e "  ${GREEN}4)${NC} Run All Tests (verify_build.sh)"
echo -e "     └─ Automated build verification"
echo ""
echo -e "  ${YELLOW}5)${NC} Show Quick Reference"
echo ""
echo -e "  ${YELLOW}0)${NC} Exit"
echo ""
echo -n "Enter your choice [0-5]: "

read choice

case $choice in
    1)
        echo ""
        echo -e "${BLUE}🚀 Launching Chat Interface Demo...${NC}"
        echo -e "${YELLOW}💡 Press Ctrl+T to toggle theme, Ctrl+Q to quit${NC}"
        echo ""
        sleep 1
        cd "$BUILD_DIR" && ./qml_preview
        ;;
    2)
        echo ""
        echo -e "${BLUE}🚀 Launching Settings Page...${NC}"
        echo -e "${YELLOW}💡 Press Ctrl+Q to quit${NC}"
        echo ""
        sleep 1
        cd "$BUILD_DIR" && ./settings_preview
        ;;
    3)
        echo ""
        echo -e "${BLUE}🚀 Launching Dialog System Demo...${NC}"
        echo -e "${YELLOW}💡 Press Ctrl+1-4 for dialogs, Ctrl+Q to quit${NC}"
        echo ""
        sleep 1
        cd "$BUILD_DIR" && ./dialogs_preview
        ;;
    4)
        echo ""
        echo -e "${BLUE}🧪 Running Build Verification...${NC}"
        echo ""
        sleep 1
        /home/racha/qTox/verify_build.sh
        echo ""
        echo -e "${GREEN}Press Enter to continue...${NC}"
        read
        exec "$0"
        ;;
    5)
        echo ""
        /home/racha/qTox/QUICK_REFERENCE.sh
        echo ""
        echo -e "${GREEN}Press Enter to continue...${NC}"
        read
        exec "$0"
        ;;
    0)
        echo ""
        echo -e "${GREEN}✨ Thanks for testing qTox Modern UI!${NC}"
        echo ""
        exit 0
        ;;
    *)
        echo ""
        echo -e "${YELLOW}Invalid choice. Please try again.${NC}"
        sleep 2
        exec "$0"
        ;;
esac
