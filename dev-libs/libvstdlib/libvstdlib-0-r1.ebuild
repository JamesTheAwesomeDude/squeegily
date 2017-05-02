# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# or, at your option, the WTFPL v2

EAPI=6

DESCRIPTION="libvstdlib_s.so symlink for Steam"
HOMEPAGE="https://github.com/JamesTheAwesomeDude/squeegily/issues/18"
SLOT="0"
KEYWORDS="amd64 x86"
LICENSE="|| ( GPL-2 WTFPL-2 )"

RDEPEND="x86? ( sys-libs/libstdc++-v3 )
	!x86? ( sys-libs/libstdc++-v3[multilib] )"

src_unpack() {
	S="${WORKDIR}"
}

src_install() {
	dosym libstdc++.so.5  /usr/lib32/libvstdlib_s.so
}
