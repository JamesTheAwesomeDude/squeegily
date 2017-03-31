EAPI=6

DESCRIPTION="Virtual Reality Internet Browser"
HOMEPAGE="http://www.janusvr.com/"
SRC_URI="http://downloads.janusvr.com/janusvr_linux.tar.gz -> ${P}.tar.gz"

LICENSE="JanusVR-2017"
SLOT="0"
# Testing until all dependencies are
# no longer testing… :(
KEYWORDS="-* ~amd64"

RESTRICT="strip mirror"

# TODO: USE flag to
# use bundled rather
# than system/native
# libraries?
RDEPEND="app-arch/bzip2
	app-arch/snappy
	dev-db/sqlite:3
	dev-lang/perl:0/5.22
	dev-libs/double-conversion
	dev-libs/glib:2
	dev-libs/icu:0/58.1
	dev-libs/leveldb
	dev-libs/libbsd
	dev-libs/libpcre-debian:3
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-qt/qtcore:5/5.6
	dev-qt/qtgui:5/5.6[xcb]
	dev-qt/qtimageformats
	dev-qt/qtmultimedia:5/5.6[gstreamer]
	dev-qt/qtopengl:5/5.6
	dev-qt/qtscript:5[scripttools]
	dev-qt/qtsql:5/5.6
	dev-qt/qtwebkit:5/5.6
	dev-qt/qtwebsockets:5/5.6
	dev-qt/qtwidgets:5/5.6
	dev-qt/qtxml:5/5.6
	media-gfx/graphite2
	media-libs/flac
	media-libs/freetype:2
	media-libs/glu
	media-libs/harfbuzz:0/0.9.18
	media-libs/ilmbase:0/12
	media-libs/libjpeg-turbo
	media-libs/libogg
	media-libs/libpng:0/16
	media-libs/libvorbis
	media-libs/openal
	media-libs/openexr:0/22
	media-libs/opus
	sci-physics/bullet
	~sys-devel/gcc-5.1.0
	sys-libs/glibc:2.2
	sys-libs/libstdc++-v3
	sys-libs/zlib"

src_unpack() {
	unpack "${A}"
	export S="${WORKDIR}/JanusVRBin"
}

src_install() {
	exeinto /opt/"${PN}"
	doexe janusvr janusvr_websurface libLeap.so
	dosym "/opt/${PN}/${PN}" "/usr/bin/${PN}"
	insinto /opt/"${PN}"
	doins -r assets
}
