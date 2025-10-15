/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2025 qTox Ubuntu Modernization Project
 */

#include "thememanager.h"

#include <QDebug>
#include <QFile>
#include <QProcess>

ThemeManager::ThemeManager(QObject* parent)
    : QObject(parent)
    , m_isDark(false)
{
    // Try to detect system theme on startup
    m_isDark = detectSystemTheme();
    
    qDebug() << "ThemeManager initialized with theme:" << (m_isDark ? "Dark" : "Light");
}

void ThemeManager::setIsDark(bool dark)
{
    if (m_isDark != dark) {
        m_isDark = dark;
        emit isDarkChanged(m_isDark);
        emit themeNameChanged(themeName());
        
        qDebug() << "Theme changed to:" << (m_isDark ? "Dark" : "Light");
    }
}

void ThemeManager::toggleTheme()
{
    setIsDark(!m_isDark);
}

bool ThemeManager::detectSystemTheme()
{
    // Method 1: Try gsettings (GNOME/Ubuntu default)
    bool darkMode = readGnomeThemeSetting();
    
    // Method 2: Fallback - check GTK theme name
    if (!darkMode) {
        QProcess process;
        process.start("gsettings", QStringList() << "get" << "org.gnome.desktop.interface" << "gtk-theme");
        
        if (process.waitForFinished(1000)) {
            QString theme = QString::fromUtf8(process.readAllStandardOutput()).trimmed();
            theme = theme.remove('\''); // Remove quotes
            
            // Common dark theme patterns
            darkMode = theme.contains("dark", Qt::CaseInsensitive) ||
                      theme.contains("Adwaita-dark", Qt::CaseInsensitive) ||
                      theme.contains("Yaru-dark", Qt::CaseInsensitive);
            
            qDebug() << "GTK theme detected:" << theme << "- Dark mode:" << darkMode;
        }
    }
    
    return darkMode;
}

bool ThemeManager::readGnomeThemeSetting()
{
    // Try to read GNOME color-scheme setting (GNOME 42+)
    QProcess process;
    process.start("gsettings", QStringList() << "get" << "org.gnome.desktop.interface" << "color-scheme");
    
    if (process.waitForFinished(1000)) {
        QString scheme = QString::fromUtf8(process.readAllStandardOutput()).trimmed();
        scheme = scheme.remove('\''); // Remove quotes
        
        bool isDark = scheme.contains("dark", Qt::CaseInsensitive) ||
                     scheme == "prefer-dark";
        
        qDebug() << "GNOME color-scheme:" << scheme << "- Dark mode:" << isDark;
        return isDark;
    }
    
    return false;
}

void ThemeManager::saveThemePreference()
{
    QSettings settings;
    settings.beginGroup("UI");
    settings.setValue("darkTheme", m_isDark);
    settings.endGroup();
    
    qDebug() << "Theme preference saved:" << (m_isDark ? "Dark" : "Light");
}

void ThemeManager::loadThemePreference()
{
    QSettings settings;
    settings.beginGroup("UI");
    
    // If user has a saved preference, use it. Otherwise, detect system theme.
    if (settings.contains("darkTheme")) {
        setIsDark(settings.value("darkTheme").toBool());
        qDebug() << "Loaded theme preference:" << (m_isDark ? "Dark" : "Light");
    } else {
        setIsDark(detectSystemTheme());
        qDebug() << "No saved preference, using system theme:" << (m_isDark ? "Dark" : "Light");
    }
    
    settings.endGroup();
}
