cmake_minimum_required(VERSION 3.16)

project(WeekWise VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QML_IMPORT_PATH "${CMAKE_SOURCE_DIR}/plugins")

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)
find_package(Qt6 6.5 REQUIRED COMPONENTS Qml)

qt_standard_project_setup()

set(SOURCES
    src/main.cpp
)

qt_add_resources(SOURCES
    src/res.qrc
)

qt_add_executable(WeekWise ${SOURCES})

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(WeekWise PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appWeekPlanner
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

add_subdirectory(plugins/BDatabase)

target_link_libraries(WeekWise
    PRIVATE Qt6::Quick
    PRIVATE BDatabaseplugin)

include(GNUInstallDirs)
install(TARGETS WeekWise
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt6_generate_deploy_qml_app_script(
    TARGET WeekWise
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
    MACOS_BUNDLE_POST_BUILD
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})

configure_file(${CMAKE_SOURCE_DIR}/dbconfig.ini ${CMAKE_BINARY_DIR}/dbconfig.ini COPYONLY)

# Install config.ini to the project directory
install(FILES ${CMAKE_BINARY_DIR}/dbconfig.ini DESTINATION ${CMAKE_INSTALL_BINDIR})
