EAPI=6

DESCRIPTION="Virtual Reality Internet Browser"
HOMEPAGE="http://www.janusvr.com/"
SRC_URI="http://downloads.janusvr.com/${PN}_linux.tar.gz -> ${P}.tar.gz
https://github.com/ValveSoftware/openvr/raw/70acfe9262290ddb789588a7390e5fc60bb20080/bin/linux64/libopenvr_api.so -> libopenvr_api-1.0.6-x86_64.so"

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
	dev-qt/qtcore:5
	dev-qt/qtgui:5[xcb]
	dev-qt/qtimageformats:5
	dev-qt/qtmultimedia:5[qml,gstreamer]
	dev-qt/qtopengl:5
	dev-qt/qtpositioning:5[qml]
	dev-qt/qtscript:5[scripttools]
	dev-qt/qtsensors:5[qml]
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5[qml,multimedia]
	dev-qt/qtwebsockets:5[qml]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
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
	unpack ${A}
	export S="${WORKDIR}/JanusVRBin"
}

src_install() {
	exeinto /opt/"${PN}"
	doexe "${PN}" "${PN}_websurface" libLeap.so
	newexe "${DISTDIR}/libopenvr_api-1.0.6-x86_64.so" libopenvr_api.so
	dosym "../../opt/${PN}/${PN}" "/usr/bin/${PN}"
	dosym "../../opt/${PN}/${PN}_websurface" "/usr/bin/${PN}_websurface"
	insinto /opt/"${PN}"
	doins -r assets
}
