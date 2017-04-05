EAPI=6

inherit multilib-minimal

# Templated off of dev-libs/libpcre-debian ebuild
DESCRIPTION="libvstdlib_s.so symlinks for Steam"
HOMEPAGE="https://github.com/JamesTheAwesomeDude/squeegily/issues/18"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x86? ( sys-libs/libstdc++-v3 )
	!x86? ( abi_x86_32? ( sys-libs/libstdc++-v3[multilib] ) )"

IUSE="+abi_x86_32"

S="${WORKDIR}"

multilib_src_install() {
	dosym ../$(get_libdir)/libstdc++.so.5 \
		  /usr/$(get_libdir)/libvstdlib_s.so
}
