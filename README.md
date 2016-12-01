# Jekyll-Springboard

## Installation

1. Install Ruby & Bundler (as root):

   _Note: To become root, you must either run `su` or `sudo -s`_

   * **Fedora** / **RHEL** / **CentOS**:
     ```
     dnf install -y rubygem-bundler ruby-devel libffi-devel make gcc gcc-c++ \
     redhat-rpm-config zlib-devel libxml2-devel libxslt-devel tar
     ```
     
   * **openSUSE**:
     ```
     zypper install ruby2.1-rubygem-bundler ruby2.1-devel make gcc-c++ \
     libxml2-devel libxslt-devel tar
     ```
     
   * **Debian** / **Ubuntu**:
     ```
     apt update && apt install bundler zlib1g-dev
     ```

   * **macOS** / **OS X**:
   
     _Note: First, you must install Mac developer tools. Then, run the following:_
     
     ```
     gem update --system
     gem install bundler
     ```

2. Install gems (as user):
   ```
   bundle install
   ```

3. Run Jekyll:
   ```
   bundle exec jekyll
   ```
   
   _(Note: If you don't have a system-wide install, you should be able to just type `jekyll`)_

