/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2025 The TokTok team.
 */

#include "src/version.h"

#include <QString>

#define GIT_DESCRIBE "v1.18.3-36-g06751e6c7"
#define GIT_VERSION "06751e6c7bb236fe941f0a46a968d959d66160e2"
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
