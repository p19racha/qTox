/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2025 The TokTok team.
 */

#include "src/version.h"

#include <QString>

#define GIT_DESCRIBE "v1.18.3-39-g13cc3311d"
#define GIT_VERSION "13cc3311dc6c2966b53a5f7a6360dccd21a53854"
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
