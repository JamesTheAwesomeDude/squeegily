EAPI=6

inherit eutils unpacker udev

DESCRIPTION="Launcher for the Steam software distribution service"
HOMEPAGE="http://www.steampowered.com/"
SRC_URI="https://steamcdn-a.akamaihd.net/client/installer/steam.deb -> ${P/${PN}-/${PN}_}_all.deb"

LICENSE="steam"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

IUSE="+steam_runtime cups vaapi vdpau xinerama +abi_x86_32"

REQUIRED_USE="abi_x86_32"

RDEPEND="dev-libs/libbsd[abi_x86_32]
	dev-libs/libpcre[abi_x86_32,cxx]
	dev-libs/libusb[abi_x86_32]
	media-libs/flac[abi_x86_32]
	media-libs/mesa[abi_x86_32]
	sys-apps/tcp-wrappers[abi_x86_32]
	sys-apps/util-linux[abi_x86_32]
	amd64? (
	 sys-devel/gcc[multilib]
	 sys-libs/glibc[multilib]
	)
	sys-libs/libudev-compat[abi_x86_32]
	|| (
	 sys-fs/eudev[abi_x86_32]
	 sys-fs/udev[abi_x86_32]
	 sys-apps/systemd[abi_x86_32]
	)
	sys-libs/zlib[abi_x86_32]
	x11-libs/libdrm[abi_x86_32]
	x11-libs/libxshmfence[abi_x86_32]
	!steam_runtime? (
	 app-crypt/mit-krb5[abi_x86_32]
	 app-crypt/p11-kit[abi_x86_32]
	 dev-db/sqlite:3[abi_x86_32]
	 dev-lang/orc[abi_x86_32]
	 dev-libs/atk[abi_x86_32]
	 dev-libs/dbus-glib[abi_x86_32]
	 dev-libs/expat[abi_x86_32]
	 dev-libs/glib:2[abi_x86_32]
	 dev-libs/gmp[abi_x86_32]
	 dev-libs/libappindicator:2[abi_x86_32]
	 dev-libs/libdbusmenu[abi_x86_32]
	 dev-libs/libffi[abi_x86_32]
	 dev-libs/libgudev[abi_x86_32]
	 dev-libs/libltdl[abi_x86_32]
	 dev-libs/libpcre-debian:3[abi_x86_32]
	 dev-libs/libvstdlib[abi_x86_32]
	 dev-libs/libxml2[abi_x86_32]
	 dev-libs/nspr[abi_x86_32]
	 dev-libs/nss[abi_x86_32]
	 gnome-base/gconf[abi_x86_32]
	 media-libs/alsa-lib[abi_x86_32]
	 media-libs/fontconfig[abi_x86_32]
	 media-libs/freeglut[abi_x86_32]
	 media-libs/freetype[abi_x86_32]
	 media-libs/glew[abi_x86_32]
	 media-libs/glu[abi_x86_32]
	 media-libs/gst-plugins-base[abi_x86_32]
	 media-libs/gstreamer:0.10[abi_x86_32]
	 media-libs/lcms:2[abi_x86_32]
	 media-libs/libcanberra[abi_x86_32]
	 media-libs/libexif[abi_x86_32]
	 || ( media-libs/libjpeg-turbo[abi_x86_32] media-libs/jpeg[abi_x86_32] )
	 media-libs/libogg[abi_x86_32]
	 media-libs/libsamplerate[abi_x86_32]
	 media-libs/libsdl[abi_x86_32]
	 media-libs/libsndfile[abi_x86_32]
	 media-libs/libtheora[abi_x86_32]
	 media-libs/libvorbis[abi_x86_32]
	 media-libs/openal[abi_x86_32]
	 media-libs/speex[abi_x86_32]
	 || ( media-sound/apulse[abi_x86_32] media-sound/pulseaudio[abi_x86_32] )
	 net-dns/avahi[abi_x86_32]
	 net-dns/libidn[abi_x86_32]
	 net-libs/libasyncns[abi_x86_32]
	 net-misc/curl[abi_x86_32]
	 || ( dev-libs/libnm[abi_x86_32] net-misc/networkmanager[abi_x86_32] )
	 net-nds/openldap[abi_x86_32]
	 cups? ( net-print/cups[abi_x86_32] )
	 x11-libs/cairo[abi_x86_32]
	 x11-libs/gdk-pixbuf[abi_x86_32]
	 x11-libs/gtk+:2[abi_x86_32]
	 x11-libs/libICE[abi_x86_32]
	 x11-libs/libSM[abi_x86_32]
	 x11-libs/libX11[abi_x86_32]
	 x11-libs/libXScrnSaver[abi_x86_32]
	 x11-libs/libXau[abi_x86_32]
	 x11-libs/libXaw[abi_x86_32]
	 x11-libs/libXcomposite[abi_x86_32]
	 x11-libs/libXcursor[abi_x86_32]
	 x11-libs/libXdamage[abi_x86_32]
	 x11-libs/libXdmcp[abi_x86_32]
	 x11-libs/libXext[abi_x86_32]
	 x11-libs/libXfixes[abi_x86_32]
	 x11-libs/libXft[abi_x86_32]
	 x11-libs/libXi[abi_x86_32]
	 xinerama? ( x11-libs/libXinerama[abi_x86_32] )
	 x11-libs/libXmu[abi_x86_32]
	 x11-libs/libXpm[abi_x86_32]
	 x11-libs/libXrandr[abi_x86_32]
	 x11-libs/libXrender[abi_x86_32]
	 x11-libs/libXt[abi_x86_32]
	 x11-libs/libXtst[abi_x86_32]
	 x11-libs/libXxf86vm[abi_x86_32]
	 vaapi? ( x11-libs/libva[abi_x86_32] )
	 vdpau? ( x11-libs/libvdpau[abi_x86_32] )
	 x11-libs/libxcb[abi_x86_32]
	 x11-libs/pango[abi_x86_32]
	 x11-libs/pangox-compat[abi_x86_32]
	 x11-libs/pixman[abi_x86_32]
	)"
# Libraries that Steam uses bundled regardless
#	 dev-cpp/tbb[abi_x86_32]
#	 dev-libs/libindicator:0[abi_x86_32]

DEPEND=""

src_unpack() {
	mkdir "${WORKDIR}/${P}"
	cd "${WORKDIR}/${P}"
	unpack_deb "${A}"
}

src_prepare() {
	use steam_runtime ||
	 eapply "${FILESDIR}/steam-disable-STEAM_RUNTIME.patch"
	eapply_user
}

src_install() {
	(cd "${S}/usr"
	 (cd "../lib/udev/rules.d/"
	  udev_dorules "60-HTC-Vive-perms.rules" "99-steam-controller-perms.rules"
	 )
	 (cd "share/pixmaps"
	  doicon "steam.png" "steam_tray_mono.png"
	 )
	 (cd "share/icons/hicolor/"
	  local icon_sizes="256 16 24 48 32"
	  for px in ${icon_sizes}; do
	   doicon -s "${px}" "${px}x${px}/apps/${PN}.png"
	  done
	 )
	 domenu "share/applications/steam.desktop"
	 insinto "/usr/lib/${PN}/"
	 use steam_runtime && doins "lib/steam/bootstraplinux_ubuntu12_32.tar.xz"
	 doman "share/man/man6/steam.6.gz"
	 dobin "bin/steam" "bin/steamdeps"
	)
}
