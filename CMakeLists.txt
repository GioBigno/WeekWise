cmake_minimum_required(VERSION 3.16)

project(WeekWise VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)
find_package(Qt6 6.5 REQUIRED COMPONENTS Qml)

qt_standard_project_setup()

qt_add_executable(WeekWise
    src/main.cpp

    src/res.qrc
)


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

target_link_libraries(WeekWise
    PRIVATE Qt6::Quick)

include(GNUInstallDirs)
install(TARGETS WeekWise
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
