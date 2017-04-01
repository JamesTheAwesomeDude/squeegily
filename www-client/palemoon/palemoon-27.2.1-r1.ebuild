EAPI=6

inherit check-reqs

#As per https://developer.palemoon.org/Developer_Guide:Build_Instructions/Pale_Moon/Linux#head:Prerequisites
export WANT_AUTOCONF="2.13"
CHECKREQS_MEMORY="4G"

HOMEPAGE="https://linux.palemoon.org/"
SRC_URI="https://github.com/MoonchildProductions/Pale-Moon/archive/${PV}_Release.tar.gz -> ${P}.tar.gz"

IUSE="alsa bindist +custom-cflags cups dbus disable-optimize devtools ffmpeg
	jemalloc gold pulseaudio threads cpu_flags_x86_sse2\
	+system-nspr +system-libevent system-nss +system-jpeg +system-zlib +system-bz2\
	+system-webp +system-png system-spell +system-ffi +system-vpx system-sqlite +system-cairo\
	+system-pixman +system-icu"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=x11-libs/gtk+-2.24
	>=sys-libs/glibc-2.17
	x11-libs/pango"

DEPEND="dev-lang/python:2.7
	~sys-devel/autoconf-2.13
	dev-lang/yasm
	x11-libs/libXt
	sys-libs/zlib
	<sys-devel/gcc-5
	jemalloc? ( dev-libs/jemalloc )
	system-nspr? ( >=dev-libs/nspr-4.13.0 )
	system-libevent? ( dev-libs/libevent )
	system-nss? ( >=dev-libs/nss-3.28.3 )
	system-jpeg? ( || ( media-libs/libjpeg-turbo media-libs/jpeg ) )
	system-bz2? ( app-arch/bzip2 )
	system-webp? ( media-libs/libwebp )
	system-png? ( media-libs/libpng )
	system-spell? ( >=app-text/hunspell-1.6.1 )
	system-ffi? ( dev-libs/libffi )
	system-vpx? ( media-libs/libvpx )
	system-sqlite? ( dev-db/sqlite[secure-delete] )
	system-cairo? ( x11-libs/cairo )
	system-pixman? ( x11-libs/pixman )
	system-icu? ( dev-libs/icu )"
# If you compile it with GCC 5,
# the browser will be
# unusably unstable.
# TODO: add ^ to einfo or something

REQUIRED_USE="disable-optimize? ( !custom-cflags !cpu_flags_x86_sse2 )"

mach() {
	python2.7 mach "$@"
}

_mozconf_raw_add() {
	echo "$@" >> "${MOZCONFIG:-${S}/.mozconfig}"
}

ac_opt() {
	_mozconf_raw_add ac_add_options "${1}"
}

use_system() {
	use "system-${1}" &&
	 ac_opt "--${2:-with}-system-${3:-${1}}"
}

mk_var() {
	_mozconf_raw_add mk_add_options "${1}=\"${2}\""
}

mozconfig_init() {
# Templated from
# https://developer.palemoon.org/Developer_Guide:Build_Instructions/Pale_Moon/Linux#head:Mozconfig_Files
	if ! use bindist; then
	 ac_opt "--enable-official-branding"
	 _mozconf_raw_add "export MOZILLA_OFFICIAL=1"
	fi
	mk_var MOZ_CO_PROJECT "browser"
	ac_opt "--enable-application=browser"
	mk_var MOZ_OBJDIR "${T}/pmbuild/"
	ac_opt "--disable-installer"
	ac_opt "--disable-updater"
	ac_opt "--enable-release"
	ac_opt "--x-libraries=/usr/$(get_libdir)"
	mk_var MOZ_MAKE_FLAGS "${MAKEOPTS}"
}

src_unpack() {
	unpack "${A}"
	export S="${WORKDIR}/Pale-Moon-${PV}_Release"
}

src_prepare() {
	use gold &&
	 eapply "${FILESDIR}/bug_1148523_firefox_gold.patch"
	eapply_user
}

src_configure() {
	mozconfig_init
	
	if use custom-cflags; then
	 if use cpu_flags_x86_sse2; then
	  ac_opt "--enable-optimize=\"${CXXFLAGS} -msse2 -mfpmath=sse\""
	 else
	  ac_opt "--enable-optimize=\"${CXXFLAGS}\""
	 fi
	elif use cpu_flags_x86_sse2; then
	 ac_opt "--enable-optimize=\"-O2 -msse2 -mfpmath=sse\""
	elif use disable-optimize; then
	 ac_opt "--disable-optimize"
	fi
	
	if use devtools; then
	 ac_opt "--enable-devtools"
	fi
	
	if ! use ffmpeg; then
	 ac_opt "--disable-ffmpeg"
	fi
	
	if use jemalloc; then
	 ac_opt "--enable-jemalloc"
	 ac_opt "--enable-jemalloc-lib"
	fi
	
	if use dbus; then
	 ac_opt "--enable-startup-notification"
	else
	 ac_opt "--disable-dbus"
	fi
	
	if ! use cups; then
	 ac_opt "--disable-printing"
	fi
	
	if use alsa; then
	 ac_opt "--enable-alsa"
	fi
	
	if ! use pulseaudio; then
	 ac_opt "--disable-pulseaudio"
	fi
	
	if use gold; then
	 ac_opt "--enable-gold"
	fi
	
	if use threads; then
	 ac_opt "--with-pthreads"
	fi
	
	use_system nspr
	use_system libevent
	use_system nss
	use_system jpeg
	use_system zlib
	use_system bz2
	use_system webp
	use_system png
	use_system spell enable hunspell
	use_system ffi enable
	use_system vpx with libvpx
	use_system sqlite enable
	use_system cairo enable
	use_system pixman enable
	use_system icu
	
	mach configure
}

src_compile() {
	mach build || die
}

src_install() {
	cd "${T}/pmbuild/"
	emake DESTDIR="${D}" install
}
