EAPI=6

DESCRIPTION="libvstdlib_s.so symlink for Steam"
HOMEPAGE="https://github.com/JamesTheAwesomeDude/squeegily/issues/18"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x86? ( sys-libs/libstdc++-v3 )
	!x86? ( sys-libs/libstdc++-v3[multilib] )"

src_unpack() {
	S="${WORKDIR}"
}

src_install() {
	dosym libstdc++.so.5  /usr/lib32/libvstdlib_s.so
}
