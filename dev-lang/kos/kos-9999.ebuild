# Copyright (c) 2021 Chris Dragan
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

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
	SRC_URI="https://github.com/kos-lang/kos/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~arm64 ~amd64 ~ppc64 ~x86"
	S="${WORKDIR}/kos-${PV}"
fi

kos_make() {
	export CC="$(tc-getCC)"
	export CXX="$(tc-getCXX)"
	export AR="$(tc-getAR)"

	local mymakeargs=(
		STRIP=true
		debug=$(usex debug 1 0)
		builtin_modules=$(usex static-libs 1 0)
	)

	# Work around for ar not able to find ld-linux.so when cross compiling
	if [[ ${CBUILD:-} != ${CHOST:-} ]]; then
		mymakeargs+=( lto=0 )
		AR="ar"
	fi

	emake "${mymakeargs[@]}" "$@"
}

src_compile() {
	kos_make
}

src_test() {
	if [[ ${CBUILD:-} != ${CHOST:-} ]]; then
		ewarn "Unable to test the package on host system"
		ewarn "CHOST is ${CHOST} but CBUILD is ${CBUILD}"
		return 0
	fi
	kos_make test
}

src_install() {
	kos_make destdir="${ED}/usr" install
}
