# determines the web view provider (either Qt WebKit or Qt WebEngine)

if(TARGET_CONFIG_DONE)
    message(FATAL_ERROR "Can not include WebViewProviderConfig module when targets are already configured.")
endif()

include(QtLinkage)

set(WEBVIEW_PROVIDER "auto" CACHE STRING "specifies the web view provider: auto (default), webkit, webengine or none")
if(NOT WEBVIEW_PROVIDER OR "${WEBVIEW_PROVIDER}" STREQUAL "auto")
    find_qt5_module(WebKitWidgets OPTIONAL)
    if(QT5_WebKitWidgets_FOUND)
        set(WEBVIEW_PROVIDER WebKitWidgets)
        set(WEBVIEW_DEFINITION "${META_PROJECT_VARNAME_UPPER}_USE_WEBKIT")
        message(STATUS "No web view provider explicitly specified, defaulting to Qt WebKit.")
    else()
        find_qt5_module(WebEngineWidgets OPTIONAL)
        if(QT5_WebEngineWidgets_FOUND)
            set(WEBVIEW_PROVIDER WebEngineWidgets)
            set(WEBVIEW_DEFINITION "${META_PROJECT_VARNAME_UPPER}_USE_WEBENGINE")
            list(APPEND ADDITIONAL_QT_REPOS "webengine")
            message(STATUS "No web view provider explicitly specified, defaulting to Qt WebEngine.")
        else()
            set(WEBVIEW_PROVIDER "")
            set(WEBVIEW_DEFINITION "${META_PROJECT_VARNAME_UPPER}_NO_WEBVIEW")
            message(STATUS "No web view provider available, web view has been disabled.")
        endif()
    endif()
else()
    if(${WEBVIEW_PROVIDER} STREQUAL "webkit")
        find_qt5_module(WebKitWidgets REQUIRED)
        set(WEBVIEW_PROVIDER WebKitWidgets)
        set(WEBVIEW_DEFINITION "${META_PROJECT_VARNAME_UPPER}_USE_WEBKIT")
        message(STATUS "Using Qt WebKit as web view provider.")
    elseif(${WEBVIEW_PROVIDER} STREQUAL "webengine")
        find_qt5_module(WebEngineWidgets REQUIRED)
        set(WEBVIEW_PROVIDER WebEngineWidgets)
        set(WEBVIEW_DEFINITION "${META_PROJECT_VARNAME_UPPER}_USE_WEBENGINE")
        list(APPEND ADDITIONAL_QT_REPOS "webengine")
        message(STATUS "Using Qt WebEngine as web view provider.")
    elseif(${WEBVIEW_PROVIDER} STREQUAL "none")
        set(WEBVIEW_DEFINITION "${META_PROJECT_VARNAME_UPPER}_NO_WEBVIEW")
        set(WEBVIEW_PROVIDER "")
        message(STATUS "Web view has been disabled.")
    else()
        message(FATAL_ERROR "The specified web view provider '${WEBVIEW_PROVIDER}' is unknown.")
    endif()
endif()

if(WEBVIEW_PROVIDER)
    use_qt5_module(${WEBVIEW_PROVIDER} REQUIRED)
endif()
list(APPEND META_PRIVATE_COMPILE_DEFINITIONS ${WEBVIEW_DEFINITION})
