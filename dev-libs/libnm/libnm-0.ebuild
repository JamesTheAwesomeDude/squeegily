EAPI=6

inherit multilib-minimal

SRC_URI="http://media.steampowered.com/client/runtime/steam-runtime-dev-release_latest.tar.xz -> steam-runtime-dev-release_2014-04-15.tar.xz"

DESCRIPTION="libnm-glib.so.4 and libnm-util.so.2 for Steam"
HOMEPAGE="https://github.com/JamesTheAwesomeDude/squeegily/issues/18"
LICENSE="steam-runtime"

SLOT="0"
KEYWORDS="-* amd64 ~x86"

IUSE="+abi_x86_32"

RDEPEND="!net-misc/networkmanager"

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/${A%%.tar*}"
}

multilib_src_install_all() {
# Have to disable this function so we don't
# install bogus documentation
	return true
}

multilib_src_install() {
	(cd "${S}/$(get_libdir | sed 's/lib32/i386/; s/lib64/amd64/')/usr/lib"
	 dolib libnm-util.so.2.3.0 libnm-util.so.2 libnm-util.so
	 dolib libnm-glib.so.4.3.0 libnm-glib.so.4 libnm-glib.so
	)
}
