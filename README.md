The interpreter for the Kos Programming Language

See <http://github.com/kos-lang/kos>.

To install Kos on Gentoo, run:

    root # eselect repository add kos git https://github.com/kos-lang/gentoo-overlay.git
    root # emaint sync -r kos
    root # ACCEPT_KEYWORDS="~*" emerge -avq dev-lang/kos

On older Gentoo installations, using layman:

    root # layman -o https://raw.githubusercontent.com/kos-lang/gentoo-overlay/main/repository.xml -f -a kos
    root # ACCEPT_KEYWORDS="~*" emerge -avq dev-lang/kos
