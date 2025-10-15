/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2025 qTox Ubuntu Modernization Project
 */

#pragma once

#include <QObject>
#include <QSettings>
#include <QString>

/**
 * @brief ThemeManager handles theme detection and switching for the modern UI
 * 
 * This class bridges between Ubuntu system theme settings and the QML Theme singleton.
 * It detects the system's preferred color scheme (light/dark) and notifies the UI
 * when the theme should change.
 */
class ThemeManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isDark READ isDark WRITE setIsDark NOTIFY isDarkChanged)
    Q_PROPERTY(QString themeName READ themeName NOTIFY themeNameChanged)

public:
    explicit ThemeManager(QObject* parent = nullptr);
    ~ThemeManager() override = default;

    bool isDark() const { return m_isDark; }
    void setIsDark(bool dark);
    
    QString themeName() const { return m_isDark ? QStringLiteral("Dark") : QStringLiteral("Light"); }

    /**
     * @brief Detect Ubuntu/GNOME system theme preference
     * @return true if dark mode is preferred
     */
    Q_INVOKABLE bool detectSystemTheme();
    
    /**
     * @brief Toggle between light and dark themes
     */
    Q_INVOKABLE void toggleTheme();
    
    /**
     * @brief Save theme preference to settings
     */
    void saveThemePreference();
    
    /**
     * @brief Load theme preference from settings
     */
    void loadThemePreference();

signals:
    void isDarkChanged(bool isDark);
    void themeNameChanged(const QString& name);

private:
    bool m_isDark;
    
    /**
     * @brief Read GNOME/GTK theme settings
     */
    bool readGnomeThemeSetting();
};
