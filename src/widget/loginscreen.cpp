/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2015-2019 by The qTox Project Contributors
 * Copyright © 2024-2025 The TokTok team.
 */


#include "loginscreen.h"

#include "ui_loginscreen.h"

#include "src/persistence/profile.h"
#include "src/persistence/profilelocker.h"
#include "src/persistence/settings.h"
#include "src/widget/form/setpassworddialog.h"
#include "src/widget/style.h"
#include "src/widget/tool/profileimporter.h"
#include "src/widget/translator.h"

#include <QDebug>
#include <QDialog>
#include <QMessageBox>
#include <QToolButton>

namespace {

void profileLoadFailure(QWidget* parent, const QString& message)
{
    QMessageBox::critical(parent, LoginScreen::tr("Couldn't load this profile"), message);
}

} // namespace

LoginScreen::LoginScreen(Paths& paths_, Style& style, int themeColor,
                         const QString& initialProfileName, QWidget* parent)
    : QDialog(parent)
    , ui(new Ui::LoginScreen)
    , quitShortcut{QKeySequence(Qt::CTRL | Qt::Key_Q), this}
    , paths{paths_}
{
    ui->setupUi(this);

    // permanently disables maximize button https://github.com/qTox/qTox/issues/1973
    setWindowFlags(windowFlags() & ~Qt::WindowMaximizeButtonHint);
    setFixedSize(size());

    connect(&quitShortcut, &QShortcut::activated, this, &LoginScreen::close);
    connect(ui->newProfilePgbtn, &QPushButton::clicked, this, &LoginScreen::onNewProfilePageClicked);
    connect(ui->loginPgbtn, &QPushButton::clicked, this, &LoginScreen::onLoginPageClicked);
    connect(ui->createAccountButton, &QPushButton::clicked, this, &LoginScreen::onCreateNewProfile);
    connect(ui->newUsername, &QLineEdit::returnPressed, this, &LoginScreen::onCreateNewProfile);
    connect(ui->newPass, &QLineEdit::returnPressed, this, &LoginScreen::onCreateNewProfile);
    connect(ui->newPassConfirm, &QLineEdit::returnPressed, this, &LoginScreen::onCreateNewProfile);
    connect(ui->loginButton, &QPushButton::clicked, this, &LoginScreen::onLogin);
    connect(ui->loginUsernames, &QComboBox::currentTextChanged, this,
            &LoginScreen::onLoginUsernameSelected);
    connect(ui->loginPassword, &QLineEdit::returnPressed, this, &LoginScreen::onLogin);
    connect(ui->newPass, &QLineEdit::textChanged, this, &LoginScreen::onPasswordEdited);
    connect(ui->newPassConfirm, &QLineEdit::textChanged, this, &LoginScreen::onPasswordEdited);
#if QT_VERSION >= QT_VERSION_CHECK(6, 7, 0)
    connect(ui->autoLoginCB, &QCheckBox::checkStateChanged, this,
            &LoginScreen::onAutoLoginCheckboxChanged);
#else
    connect(ui->autoLoginCB, &QCheckBox::stateChanged, this, &LoginScreen::onAutoLoginCheckboxChanged);
#endif
    connect(ui->importButton, &QPushButton::clicked, this, &LoginScreen::onImportProfile);

    reset(initialProfileName);
    setStyleSheet(style.getStylesheet("loginScreen/loginScreen.qss", themeColor));

    retranslateUi();
    Translator::registerHandler([this] { retranslateUi(); }, this);
}

LoginScreen::~LoginScreen()
{
    Translator::unregister(this);
    delete ui;
}

/**
 * @brief Resets the UI, clears all fields.
 */
void LoginScreen::reset(const QString& initialProfileName)
{
    ui->newUsername->clear();
    ui->newPass->clear();
    ui->newPassConfirm->clear();
    ui->loginPassword->clear();
    ui->loginUsernames->clear();

    const QStringList allProfileNames = Profile::getAllProfileNames(paths);

    if (allProfileNames.isEmpty()) {
        ui->stackedWidget->setCurrentIndex(0);
        ui->newUsername->setFocus();
    } else {
        for (const QString& profileName : allProfileNames) {
            ui->loginUsernames->addItem(profileName);
        }

        ui->loginUsernames->setCurrentText(initialProfileName);
        ui->stackedWidget->setCurrentIndex(1);
        ui->loginPassword->setFocus();
    }
}

void LoginScreen::onProfileLoaded()
{
    done(QDialog::Accepted);
}

void LoginScreen::onProfileLoadFailed()
{
    profileLoadFailure(this, tr("Wrong password."));
    ui->loginPassword->setFocus();
    ui->loginPassword->selectAll();
}

void LoginScreen::onAutoLoginChanged(bool state)
{
    ui->autoLoginCB->setChecked(state);
}

bool LoginScreen::event(QEvent* event)
{
    return QWidget::event(event);
}

void LoginScreen::onNewProfilePageClicked()
{
    ui->stackedWidget->setCurrentIndex(0);
}

void LoginScreen::onLoginPageClicked()
{
    ui->stackedWidget->setCurrentIndex(1);
}

void LoginScreen::onCreateNewProfile()
{
    const QString name = ui->newUsername->text();
    const QString pass = ui->newPass->text();
    const QString failureTitle = tr("Couldn't create a new profile");

    if (name.isEmpty()) {
        emit failure(failureTitle, tr("The username must not be empty."));
        return;
    }

    if (pass.size() != 0 && pass.size() < 6) {
        emit failure(failureTitle, tr("The password must be at least 6 characters long."));
        return;
    }

    if (ui->newPassConfirm->text() != pass) {
        emit failure(failureTitle, tr("The passwords you've entered are different.\n"
                                      "Please make sure to enter the same password twice."));
        return;
    }

    if (Profile::exists(name, paths)) {
        emit failure(failureTitle, tr("A profile with this name already exists."));
        return;
    }

    emit createNewProfile(name, pass);
}

void LoginScreen::onLoginUsernameSelected(const QString& name)
{
    if (name.isEmpty())
        return;

    ui->loginPassword->clear();
    if (Profile::isEncrypted(name, paths)) {
        ui->loginPasswordLabel->show();
        ui->loginPassword->show();
        // there is no way to do autologin if profile is encrypted, and
        // visible option confuses users into thinking that it is possible,
        // thus hide it
        ui->autoLoginCB->hide();
    } else {
        ui->loginPasswordLabel->hide();
        ui->loginPassword->hide();
        ui->autoLoginCB->show();
        ui->autoLoginCB->setToolTip(
            tr("Password protected profiles can't be automatically loaded."));
    }
}

void LoginScreen::onLogin()
{
    const QString name = ui->loginUsernames->currentText();
    const QString pass = ui->loginPassword->text();

    // name can be empty when there are no profiles
    if (name.isEmpty()) {
        profileLoadFailure(this, tr("There is no selected profile.\n\n"
                                    "You may want to create one."));
        return;
    }

    if (!ProfileLocker::isLockable(name, paths)) {
        profileLoadFailure(this, tr("This profile is already in use."));
        return;
    }

    emit loadProfile(name, pass);
}

void LoginScreen::onPasswordEdited()
{
    ui->passStrengthMeter->setValue(SetPasswordDialog::getPasswordStrength(ui->newPass->text()));
}

#if QT_VERSION >= QT_VERSION_CHECK(6, 7, 0)
void LoginScreen::onAutoLoginCheckboxChanged(Qt::CheckState state)
{
    emit autoLoginChanged(state == Qt::CheckState::Checked);
}
#else
void LoginScreen::onAutoLoginCheckboxChanged(int state)
{
    auto cstate = static_cast<Qt::CheckState>(state);
    emit autoLoginChanged(cstate == Qt::CheckState::Checked);
}
#endif

void LoginScreen::retranslateUi()
{
    ui->retranslateUi(this);
}

void LoginScreen::onImportProfile()
{
    ProfileImporter pi(paths, this);
    if (pi.importProfile()) {
        reset();
    }
}
