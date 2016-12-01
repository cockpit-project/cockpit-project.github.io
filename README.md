# Jekyll-Springboard

## Installation

1. Install Ruby & Bundler (as root):

   * **Fedora** / **RHEL** / **CentOS**:
     ```
     dnf install -y rubygem-bundler ruby-devel libffi-devel make gcc gcc-c++ \
     redhat-rpm-config zlib-devel libxml2-devel libxslt-devel tar
     ```
     
   * **Debian** / **Ubuntu**:
     ```
     apt update && apt install bundler zlib1g-dev
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

