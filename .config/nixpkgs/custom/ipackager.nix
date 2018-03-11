{
  stdenv, fetchgit,
  cmake, gcc,
  glm, mesa, qt5, xorg,
  libisopach
}:

stdenv.mkDerivation rec {
  name = "ipackager-${version}";
  version = "0.6";
  src = libisopach.src;
  preConfigure = ''
    rm -r CMakeLists.txt Doxyfile.in README.md src ipackager/src/IPackager.pro
    mv ipackager/* .
    rmdir ipackager
    sed -e 's/@/$/g' > CMakeLists.txt << EOI
    CMAKE_MINIMUM_REQUIRED(VERSION 3.1)
    
    PROJECT(ipackager VERSION ${version})
    
    SET(CMAKE_MODULE_PATH "@{ipackager_SOURCE_DIR}/cmake")
    
    SET(CMAKE_INCLUDE_CURRENT_DIR ON)
    
    SET(CMAKE_AUTOMOC ON)
    SET(CMAKE_AUTOUIC ON)
    
    FIND_PACKAGE(Qt5 COMPONENTS
        Core
        Gui
        Network
        OpenGL
        Widgets
        Xml
        X11Extras
    REQUIRED)
    FIND_PACKAGE(GLM REQUIRED)
    FIND_PACKAGE(OpenGL REQUIRED)
    
    INCLUDE_DIRECTORIES(@{CMAKE_CURRENT_SOURCE_DIR}/src)
    INCLUDE_DIRECTORIES(@{GLM_INCLUDE_DIR})
    INCLUDE_DIRECTORIES(@{OPENGL_INCLUDE_DIRS})
    
    ADD_DEFINITIONS(-DNO_IMMERSIVE)
    ADD_DEFINITIONS(-DNO_STEREO)
    
    SET(CMAKE_CXX_STANDARD 14)

    SET(IPACKAGER_SOURCES
        src/convert/conversionsystem.cpp
        src/converter/plyconverter.cpp
        src/converter/wavefrontconverter.cpp
        src/converter/x3dconverter.cpp
        src/converter/xyzconverter.cpp
        src/hack/gpumeshdata.cpp
        src/hack/materialpart.cpp
        src/hack/meshpart.cpp
        src/ipackager.cpp
        src/main.cpp
        src/materialdialog.cpp
        src/moc_ipackager.cpp
        src/moc_materialdialog.cpp
        src/moc_qmatrixdialog.cpp
        src/previewwidget.cpp
        src/qmatrixdialog.cpp
    )

    SET(IPACKAGER_UI
        src/ipackager.ui
        src/materialdialog.ui
        src/qmatrixdialog.ui
    )

    QT5_WRAP_CPP(GENERATED_SOURCES @{IPACKAGER_UI})
    #T5_WRAP_UI (GENERATED_HEADERS @{IPACKAGER_UI})

    ADD_EXECUTABLE(ipackager
        @{IPACKAGER_SOURCES}
    #   @{IPACKAGER_UI}
    )
    SET_TARGET_PROPERTIES(ipackager PROPERTIES
        VERSION ${version}
    )
    TARGET_LINK_LIBRARIES(ipackager
        Qt5::Core
        Qt5::Gui
        Qt5::Network
        Qt5::OpenGL
        Qt5::Widgets
        Qt5::Xml
        Qt5::X11Extras
        @{X11_LIBRARIES}
        @{OPENGL_LIBRARIES}
        isopach
    )
    INSTALL(TARGETS ipackager RUNTIME DESTINATION "@{CMAKE_INSTALL_PREFIX}/bin")
    EOI
    nl -ba CMakeLists.txt
  '';
  libPath = [ libisopach xorg.libX11 ];
  enableParallelBuilding = true;
  nativeBuildInputs = [
    cmake gcc
  ];
  buildInputs = [
    glm mesa xorg.libX11
    libisopach
  ];
  meta = {
    description = "Isopach2 is a graphics engine targetting multiscreen immersive environments.";
    homepage = "https://github.nrel.gov/nbrunhar/LibIsopach";
    platforms = stdenv.lib.platforms.linux;
  };
}
