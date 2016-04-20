Title: Cockpit has Docker pull support
Date: 2014-06-24
Category: Cockpit
Tags: cockpit, docker

Cockpit 0.12 now has support for pulling Docker images from the
[Docker registry](https://registry.hub.docker.com/).

![Docker pull support](images/cockpit-docker-pull.png)

Unfortunately Docker doesn't have support for cancelling the pull of an image. So that
sort of hampers the UI a bit. At least for now.
