
lychee-container:
	podman run --init -it -v .:/input:Z,ro lycheeverse/lychee --root-dir "/input/_site" --config "/input/.lychee.toml" /input/_site

.PHONY: lychee-container
