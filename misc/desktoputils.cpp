#include "./desktoputils.h"

#include <QDesktopServices>
#include <QUrl>

namespace DesktopUtils {

/*!
 * \brief Shows the specified file or directory using the default file browser.
 * \remarks \a path musn't be specified as URL. (Conversion to URL is the purpose of this function).
 */
bool openLocalFileOrDir(const QString &path)
{
#ifdef Q_OS_WIN32
    // backslashes are commonly used under Windows
    // -> replace backslashes with slashes to support Windows paths
    QString tmp(path);
    tmp.replace(QChar('\\'), QChar('/'));
    return QDesktopServices::openUrl(QUrl(QStringLiteral("file:///") + path, QUrl::TolerantMode));
#else
    return QDesktopServices::openUrl(QUrl(QStringLiteral("file://") + path, QUrl::TolerantMode));
#endif
}

}
