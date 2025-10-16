/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2025 The TokTok team.
 */

#include "src/version.h"

#include <QString>

#define GIT_DESCRIBE "v1.18.3-33-g7229a8b96"
#define GIT_VERSION "7229a8b96666a11d0615311185d1c9ed63c5b280"
#define GIT_DESCRIBE_EXACT "Nightly"

namespace VersionInfo {
QString gitDescribe()
{
    return QStringLiteral(GIT_DESCRIBE);
}

QString gitVersion()
{
    return QStringLiteral(GIT_VERSION);
}

QString gitDescribeExact()
{
    return QStringLiteral(GIT_DESCRIBE_EXACT);
}
} // namespace VersionInfo
