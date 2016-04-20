# This redirects all make targets to builddir
all:
	$(MAKE) -C $(REDIRECT) html
%:
	$(MAKE) -C $(REDIRECT) $@
REDIRECT = pelican
