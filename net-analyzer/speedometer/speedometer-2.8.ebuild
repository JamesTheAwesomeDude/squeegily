# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# or, at your option, the WTFPL v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Measure and display the rate of data across a network connection or data into a file."
HOMEPAGE="https://excess.org/${PN}/"
SRC_URI="https://excess.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/urwid[${PYTHON_USEDEP}]"
