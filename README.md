# squeegily
### Gentoo ebuilds with aspirations of superlative quality

To add this repo, run

	sudo emerge -av app-portage/layman
	sudo layman -o https://raw.githubusercontent.com/JamesTheAwesomeDude/squeegily/master/repositories.xml -f -a squeegily

The goal for this is repo is to create _nice_ packages for Gentoo Linux.

 * If I've marked a package as TESTING, I'm open to suggestions.
 * If I've marked a package as STABLE, I'm open to complaints.

## Steam

If you plan to use `STEAM_RUNTIME=0` and you don't use NetworkManager, the following command is necessary:

	echo "dev-libs/libnm steam-runtime" | sudo tee -a /etc/portage/package.license
