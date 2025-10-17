/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2025 The TokTok team.
 */

#include "src/version.h"

#include <QString>

#define GIT_DESCRIBE "v1.18.3-37-g5efaf3e4c"
#define GIT_VERSION "5efaf3e4ce4cb601d58c8a31dbc54f103f46c115"
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
