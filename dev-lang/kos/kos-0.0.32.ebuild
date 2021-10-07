# Copyright (c) 2021 Chris Dragan
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Kos Programming Language"
HOMEPAGE="https://github.com/kos-lang/kos"

LICENSE="MIT"
SLOT="0"
IUSE="debug static-libs test"
RESTRICT="!test? ( test )"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/kos-lang/kos.git"
	inherit git-r3
else
	SRC_URI="https://github.com/kos-lang/kos/releases/download/v${PV}/kos-${PV}-src.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~arm64 ~amd64 ~ppc64 ~x86"
	S="${WORKDIR}/kos-${PV}-src"
fi

kos_make() {
	local mymakeargs=(
		STRIP=true
		debug=$(usex debug 1 0)
		builtin_modules=$(usex static-libs 1 0)
	)
	emake "${mymakeargs[@]}" "$@"
}

src_compile() {
	kos_make
}

src_test() {
	kos_make test
}

src_install() {
	kos_make destdir="${ED}/usr" install
}
