EAPI=6

inherit check-reqs eutils

#As per https://developer.palemoon.org/Developer_Guide:Build_Instructions/Pale_Moon/Linux#head:Prerequisites
export WANT_AUTOCONF="2.13"
CHECKREQS_MEMORY="4G"

HOMEPAGE="https://linux.palemoon.org/"
SRC_URI="https://github.com/MoonchildProductions/Pale-Moon/archive/${PV}_Release.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0
	!bindist? ( PaleMoon-2016 )"

IUSE="alsa bindist +custom-cflags cups dbus disable-optimize +devtools ffmpeg
	+jemalloc gold pulseaudio threads cpu_flags_x86_sse2 necko-wifi\
	gtk2 gtk3\
	+system-nspr +system-libevent system-nss +system-jpeg +system-zlib +system-bz2\
	+system-webp +system-png system-spell +system-ffi +system-libvpx system-sqlite +system-cairo\
	+system-pixman +system-icu"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=x11-libs/gtk+-2.24:2
	>=sys-libs/glibc-2.17
	x11-libs/pango
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg )
	jemalloc? ( dev-libs/jemalloc )
	system-nspr? ( >=dev-libs/nspr-4.13.0 )
	system-libevent? ( dev-libs/libevent )
	system-nss? ( >=dev-libs/nss-3.28.3 )
	system-jpeg? ( || ( media-libs/libjpeg-turbo media-libs/jpeg ) )
	system-bz2? ( app-arch/bzip2 )
	system-webp? ( media-libs/libwebp )
	system-png? ( media-libs/libpng[apng] )
	system-spell? ( >=app-text/hunspell-1.6.1 )
	system-ffi? ( dev-libs/libffi )
	system-libvpx? ( media-libs/libvpx )
	system-sqlite? ( dev-db/sqlite[secure-delete] )
	system-cairo? ( x11-libs/cairo )
	system-pixman? ( x11-libs/pixman )
	system-icu? ( dev-libs/icu )"

DEPEND="dev-lang/python:2.7
	app-arch/unzip
	app-arch/zip
	~sys-devel/autoconf-2.13
	dev-lang/yasm
	x11-libs/libXt
	sys-libs/zlib
	<sys-devel/gcc-5
	${RDEPEND}"
# If you compile it with GCC 5,
# the browser will be
# unusably unstable.
# TODO: add ^ to einfo or something

REQUIRED_USE="disable-optimize? ( !custom-cflags !cpu_flags_x86_sse2 )
	necko-wifi? ( dbus )
	^^ ( gtk2 gtk3 )"

mach() {
	python2.7 mach "$@"
}

_mozconf_raw_add() {
	echo "$@" >> "${MOZCONFIG:-${S}/.mozconfig}"
}

ac_opt() {
	_mozconf_raw_add ac_add_options "${1}"
}

moz_use() {
	if [ "${1}" != "!" ]; then
	 use "${1}" || return
	else
	 shift
	 use "${1}" && return
	fi
	
	ac_opt "--${2}-${3:-${1}}"
	
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
	ac_opt "--prefix=/usr"
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
	
	if ! use disable-optimize; then
	 local cxxflags
	 use custom-cflags &&
	  cxxflags+="${CXXFLAGS} "
	 
	 # Officially suggested flags
	 # for taking full advantage of
	 # the SSE2 instruction set
	 use cpu_flags_x86_sse2 &&
	  cxxflags+="-msse2 -mfpmath=sse"
	 
	 ac_opt "--enable-optimize=\"${cxxflags}\""
	 
	else
	 ac_opt "--disable-optimize"
	fi
	
	if use dbus; then
	 cp "${FILESDIR}/${PN}.desktop" "${T}/${PN}.desktop"
	else
	 sed 's/^\(StartupNotify=\)\(.*\)$/\1false/' < "${FILESDIR}/${PN}.desktop" > "${T}/${PN}.desktop"
	fi
	
	moz_use devtools	enable
	moz_use "!" ffmpeg	disable
	moz_use jemalloc	enable
	moz_use jemalloc	enable	jemalloc-lib
	moz_use dbus		enable	startup-notification
	moz_use "!" dbus	disable
	moz_use "!" cups	disable	printing
	moz_use alsa		enable
	moz_use "!" pulseaudio	disable
	moz_use	gold		enable
	moz_use threads		with	pthreads
	moz_use "!" necko-wifi	disable
	moz_use gtk2		"enable-default-toolkit=cairo"
	moz_use gtk3		"enable-default-toolkit=cairo"
	moz_use system-nspr	with
	moz_use system-libevent	with
	moz_use system-nss	with
	moz_use system-jpeg	with
	moz_use system-zlib	with
	moz_use system-bz2	with
	moz_use system-webp	with
	moz_use system-png	with
	moz_use system-spell	enable	system-hunspell
	moz_use system-ffi	enable
	moz_use system-libvpx	with
	moz_use system-sqlite	enable
	moz_use system-cairo	enable
	moz_use system-pixman	enable
	moz_use system-icu	enable
	
	mach configure
}

src_compile() {
	mach build || die
}

src_install() {
	cd "${T}/pmbuild/"
	emake DESTDIR="${D}" install
	
	dosym "${P}" "/usr/lib/${PN}"
	
	local rel_browsersrc="../../../../../../usr/lib/${PN}"
	local iconspx="${rel_browsersrc}/browser/chrome/icons/default/default@PX@.png"
	local iconsres="16 32 48"
	local icon128="${rel_browsersrc}/browser/icons/mozicon128.png"
	local iconsdest="/usr/share/icons/hicolor/@PX@x@PX@/apps/${PN}.png"
	
	for px in ${iconsres}; do
	 dosym "${iconspx/@PX@/${px}}" "${iconsdest//@PX@/${px}}"
	done
	dosym "${icon128}" "${iconsdest//@PX@/128}"
	
	domenu "${T}/${PN}.desktop"
}
