# This redirects all make targets to builddir
all:
	@LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 $(MAKE) -C $(REDIRECT) html
%:
	@LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 $(MAKE) -C $(REDIRECT) $@
REDIRECT = pelican
