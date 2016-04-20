Title: Introducing Cockpit
Date: 2014-02-13 12:46
Tags: technical
Slug: introducing-cockpit

Gave a [talk at DevConf][] in Brno about the project a bunch of us have
been working on: [Cockpit][]. It's a UI for Linux Servers. Currently in
the prototype stage...  
  
![Cockpit login](images/cockpit1.png)

Hopefully there'll be a video of the talk available soon. You can try
out the Cockpit prototype in Fedora like so:  
  
    :::text
    # yum install --enablerepo=updates-testing cockpit
    # setenforce 0 # issue 200
    # systemctl enable cockpit-ws.socket
    $ xdg-open http://localhost:21064

  
**Don't run this on a system you care about (yet).** Sorry about the
certificate warning. Groan ... I know ... working on that.  
  
Needless to say I'm excited about where this is going...


  [talk at DevConf]: http://thewalter.net/stef/misc/cockpit-devconf-2014-talk.pdf
  [Cockpit]: http://cockpit-project.org/
