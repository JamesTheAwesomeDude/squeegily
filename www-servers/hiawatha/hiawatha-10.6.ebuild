# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# or, at your option, the WTFPL v2

EAPI=6

inherit cmake-utils eutils user systemd

DESCRIPTION="An advanced and secure webserver for Unix"
HOMEPAGE="https://www.hiawatha-webserver.org/"
SRC_URI="https://www.hiawatha-webserver.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE="+cache debug +ipv6 monitor +rproxy +ssl tomahawk +urltoolkit +xslt"

DEPEND="xslt? ( dev-libs/libxslt )
	ssl? ( net-libs/mbedtls )
	sys-libs/zlib"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup www-data
	enewuser www-data -1 -1 /var/www/hiawatha www-data
}

src_prepare() {
	eapply "${FILESDIR}/hiawatha-dont-install-index_html.patch"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
	 -DENABLE_CACHE="$(usex cache)"
	 -DENABLE_DEBUG="$(usex debug)"
	 -DENABLE_IPV6="$(usex ipv6)"
	 -DENABLE_MONITOR="$(usex monitor)"
	 -DENABLE_RPROXY="$(usex rproxy)"
	 -DENABLE_TLS="$(usex ssl)"
	 -DENABLE_TOMAHAWK="$(usex tomahawk)"
	 -DENABLE_TOOLKIT="$(usex urltoolkit)"
	 -DENABLE_XSLT="$(usex xslt)"
	 -DCMAKE_INSTALL_PREFIX="${EROOT}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	keepdir "${EROOT}/var/www/hiawatha"
	newinitd "${FILESDIR}/hiawatha.initd" "hiawatha"
	systemd_dounit "${S}/extra/debian/hiawatha.service"
}
