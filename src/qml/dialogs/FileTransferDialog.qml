// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../themes"
import "."

/**
 * File Transfer Dialog
 * Shows progress for sending/receiving files
 */
ModernDialog {
    id: fileTransferDialog
    
    property string fileName: "document.pdf"
    property int fileSize: 1024 * 1024 * 5 // 5 MB
    property real progress: 0.0 // 0.0 to 1.0
    property bool isReceiving: true
    property bool isPaused: false
    property bool isComplete: false
    property int transferSpeed: 0 // bytes per second
    
    title: isReceiving ? "Receiving File" : "Sending File"
    iconEmoji: isReceiving ? "📥" : "📤"
    width: 500
    height: contentLayout.implicitHeight + 160
    showCloseButton: isComplete
    
    signal cancelTransfer()
    signal pauseTransfer()
    signal resumeTransfer()
    
    // Format file size
    function formatFileSize(bytes) {
        if (bytes < 1024) return bytes + " B"
        if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " KB"
        if (bytes < 1024 * 1024 * 1024) return (bytes / (1024 * 1024)).toFixed(1) + " MB"
        return (bytes / (1024 * 1024 * 1024)).toFixed(1) + " GB"
    }
    
    // Format transfer speed
    function formatSpeed(bytesPerSec) {
        if (bytesPerSec < 1024) return bytesPerSec + " B/s"
        if (bytesPerSec < 1024 * 1024) return (bytesPerSec / 1024).toFixed(1) + " KB/s"
        return (bytesPerSec / (1024 * 1024)).toFixed(1) + " MB/s"
    }
    
    // Calculate ETA
    function formatETA() {
        if (isPaused || progress >= 1.0 || transferSpeed === 0) return ""
        
        var remaining = fileSize * (1.0 - progress)
        var seconds = Math.ceil(remaining / transferSpeed)
        
        if (seconds < 60) return seconds + " seconds remaining"
        if (seconds < 3600) return Math.ceil(seconds / 60) + " minutes remaining"
        return Math.ceil(seconds / 3600) + " hours remaining"
    }
    
    contentItem: ColumnLayout {
        id: contentLayout
        spacing: Theme.spacing * 2
        
        // File info
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing * 1.5
            
            // File icon
            Rectangle {
                Layout.preferredWidth: 56
                Layout.preferredHeight: 56
                radius: Theme.radiusMedium
                color: Theme.accentColor
                opacity: 0.1
                
                Label {
                    anchors.centerIn: parent
                    text: "📄"
                    font.pixelSize: 28
                }
            }
            
            // File details
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing / 4
                
                Label {
                    Layout.fillWidth: true
                    text: fileName
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: Theme.textPrimaryColor
                    elide: Text.ElideMiddle
                }
                
                Label {
                    text: formatFileSize(fileSize)
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.textSecondaryColor
                }
            }
        }
        
        // Progress section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            
            // Progress bar
            Rectangle {
                Layout.fillWidth: true
                height: 8
                radius: 4
                color: Theme.borderColor
                
                Rectangle {
                    width: parent.width * progress
                    height: parent.height
                    radius: parent.radius
                    color: {
                        if (isComplete) return "#34C759"
                        if (isPaused) return "#FF9500"
                        return Theme.accentColor
                    }
                    
                    Behavior on width {
                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }
                    
                    Behavior on color {
                        ColorAnimation { duration: Theme.animationFast }
                    }
                }
            }
            
            // Progress info
            RowLayout {
                Layout.fillWidth: true
                
                Label {
                    text: {
                        if (isComplete) return "✓ Transfer complete"
                        if (isPaused) return "⏸ Paused"
                        return Math.round(progress * 100) + "%"
                    }
                    font.pixelSize: Theme.fontSizeNormal
                    font.weight: Font.DemiBold
                    color: {
                        if (isComplete) return "#34C759"
                        if (isPaused) return "#FF9500"
                        return Theme.textPrimaryColor
                    }
                }
                
                Item { Layout.fillWidth: true }
                
                Label {
                    visible: !isComplete && !isPaused
                    text: formatSpeed(transferSpeed)
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.textSecondaryColor
                }
            }
            
            // ETA
            Label {
                Layout.fillWidth: true
                visible: !isComplete && !isPaused && text.length > 0
                text: formatETA()
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textSecondaryColor
            }
        }
        
        // Status message
        Label {
            Layout.fillWidth: true
            visible: isComplete
            text: "File saved to Downloads folder"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.textSecondaryColor
            horizontalAlignment: Text.AlignHCenter
        }
    }
    
    // Footer buttons
    footer: Item {
        implicitHeight: 72
        
        Rectangle {
            anchors.fill: parent
            color: Theme.backgroundColor
        }
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing * 2
            spacing: Theme.spacing
            
            Item { Layout.fillWidth: true }
            
            // Cancel button
            ModernButton {
                visible: !isComplete
                text: "Cancel"
                outlined: true
                buttonColor: "#FF3B30"
                Layout.preferredWidth: 100
                
                onClicked: {
                    fileTransferDialog.cancelTransfer()
                    fileTransferDialog.reject()
                }
            }
            
            // Pause/Resume button
            ModernButton {
                visible: !isComplete
                text: isPaused ? "Resume" : "Pause"
                outlined: true
                buttonColor: Theme.accentColor
                Layout.preferredWidth: 100
                
                onClicked: {
                    if (isPaused) {
                        fileTransferDialog.resumeTransfer()
                    } else {
                        fileTransferDialog.pauseTransfer()
                    }
                }
            }
            
            // Done button (when complete)
            ModernButton {
                visible: isComplete
                text: "Done"
                buttonColor: Theme.accentColor
                Layout.preferredWidth: 100
                
                onClicked: fileTransferDialog.accept()
            }
        }
    }
    
    // Simulate progress for demo
    Timer {
        id: progressTimer
        interval: 100
        running: !isPaused && !isComplete && visible
        repeat: true
        onTriggered: {
            if (progress < 1.0) {
                progress += 0.01
                transferSpeed = 512 * 1024 + Math.random() * 256 * 1024 // 512-768 KB/s
                
                if (progress >= 1.0) {
                    progress = 1.0
                    isComplete = true
                }
            }
        }
    }
    
    // Reset on close
    onClosed: {
        progress = 0.0
        isPaused = false
        isComplete = false
        transferSpeed = 0
    }
}
