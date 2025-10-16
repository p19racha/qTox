/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2025 The TokTok team.
 */

#include "src/version.h"

#include <QString>

#define GIT_DESCRIBE "v1.18.3-34-g4070cbcab"
#define GIT_VERSION "4070cbcabb4568cfa4bf7b7ec5b3d9c99ff93387"
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
