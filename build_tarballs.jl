# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "bullet3"
version = v"2.87.0"

# Collection of sources required to build bullet3
sources = [
    "https://github.com/bulletphysics/bullet3.git" =>
    "6e4707df5fa1f9927109e89a7cd2a6d6a6ddd072",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd bullet3/
mkdir build
cd build
cmake -DBUILD_CLSOCKET=OFF -DBUILD_ENET=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DBUILD_OPENGL3_DEMOS=OFF -DUSE_GRAPHICAL_BENCHMARK=OFF -DBUILD_BULLET2_DEMOS=OFF -DBUILD_CPU_DEMOS=OFF -DUSE_GLUT=OFF -DBUILD_UNIT_TESTS=OFF ..
make -j${ncore}
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libBulletCollision", :libcollision),
    LibraryProduct(prefix, "libBullet3Dynamics", :libdynamics),
    LibraryProduct(prefix, "libBulletSoftBody", :libsoftbody),
    LibraryProduct(prefix, "libBullet3Collision", :libcollision),
    LibraryProduct(prefix, "libBullet3Common", :libcommon),
    LibraryProduct(prefix, "libBullet3OpenCL_clew", :libopencl),
    LibraryProduct(prefix, "libBulletRobotics", :librobotics)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

