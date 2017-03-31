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

HIAWATHA_CONFIG_DIR="${HIAWATHA_CONFIG_DIR:-/etc/hiawatha}"
HIAWATHA_LOG_DIR="${HIAWATHA_LOG_DIR:-/var/log/hiawatha}"
HIAWATHA_PID_DIR="${HIAWATHA_PID_DIR:-/var/run}"
HIAWATHA_DEFAULT_WEBROOT_DIR="${HIAWATHA_DEFAULT_WEBROOT_DIR:-/var/www/hiawatha}"
HIAWATHA_WORK_DIR="${HIAWATHA_WORK_DIR:-/var/lib/hiawatha}"
HIAWATHA_USER="${HIAWATHA_USER:-hiawatha}"
HIAWATHA_GROUP="${HIAWATHA_GROUP:-hiawatha}"

pkg_setup() {
	enewgroup ${HIAWATHA_GROUP}
	enewuser ${HIAWATHA_USER} -1 -1 "${HIAWATHA_DEFAULT_WEBROOT_DIR}" ${HIAWATHA_GROUP}
}

replace_text() {
	local file=$1
	local replace_this=$2
	local replace_with=$3
	local output_to=$4 #OPTIONAL
	echo "$@"
	
	if [[ -n ${output_to} ]] ; then
		sed -r \
		 -e "s|${replace_this}|${replace_with}|" \
		 "${file}" > ${output_to} || die "Failed editing ${file} to ${output_to}!"
	else
		sed -r \
		 -e "s|${replace_this}|${replace_with}|" \
		 "${file}" -i || die "Failed editing ${file}!"
	fi
}

src_prepare() {
	replace_text "${S}/config/hiawatha.conf.in" \
	 "^#ServerId = .*" "ServerId = ${HIAWATHA_USER}"
	
	replace_text "${FILESDIR}/hiawatha.initd" \
	 "@HIAWATHA_PID_DIR@" "${HIAWATHA_PID_DIR}" \
	 "${T}/hiawatha.initd"
	
	replace_text "${S}/extra/debian/hiawatha.service" \
	 "/.*hiawatha.pid" "${HIAWATHA_PID_DIR}/hiawatha.pid"
	
	eapply_user
}

src_configure() {
	local mycmakeargs=(
	 -DENABLE_CACHE="$(usex cache)"
	 -DENABLE_DEBUG="$(usex debug)"
	 -DENABLE_IPV6="$(usex ipv6)"
	 -DENABLE_MONITOR="$(usex monitor)"
	 -DENABLE_RPROXY="$(usex rproxy)"
	 -DENABLE_TLS="$(usex ssl)"
	 -DENABLE_SYSTEM_MBEDTLS="$(usex ssl)"
	 -DENABLE_TOMAHAWK="$(usex tomahawk)"
	 -DENABLE_XSLT="$(usex xslt)"
	 -DCONFIG_DIR="${HIAWATHA_CONFIG_DIR}"
	 -DLOG_DIR="${HIAWATHA_LOG_DIR}"
	 -DPID_DIR="${HIAWATHA_PID_DIR}"
	 -DWEBROOT_DIR="${HIAWATHA_DEFAULT_WEBROOT_DIR}"
	 -DWORK_DIR="${HIAWATHA_WORK_DIR}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	rm -r "${ED%/}${HIAWATHA_DEFAULT_WEBROOT_DIR}"/*
	keepdir "${HIAWATHA_LOG_DIR}"
	keepdir "${HIAWATHA_WORK_DIR}"
	keepdir "${HIAWATHA_DEFAULT_WEBROOT_DIR}"
	newinitd "${T}/hiawatha.initd" "hiawatha"
	systemd_dounit "./debian/extra/hiawatha.service"
}
