# This redirects all make targets to builddir
all:
	@LANG=C $(MAKE) -C $(REDIRECT) html
%:
	@LANG=C $(MAKE) -C $(REDIRECT) $@
REDIRECT = pelican
