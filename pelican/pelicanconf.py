# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

THEME = "./themes/svbhack"
TYPOGRIFY = True

AUTHOR = u'Cockpit Project'
SITENAME = u'Cockpit Project'
SITEURL = 'http://cockpit-project.org/blog'
TAGLINE = u'Cockpit Project'

TIMEZONE = 'Utc'

DEFAULT_LANG = u'en'

# Feed generation is usually not desired when developing
# FEED_ALL_ATOM = None
# CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None

# We don't distingish between publish/html
FEED_ALL_ATOM = 'feeds/all.atom.xml'
CATEGORY_FEED_ATOM = 'feeds/%s.atom.xml'
DELETE_OUTPUT_DIRECTORY = True

# Blogroll
LINKS =  ()

# Social widget
SOCIAL = ()

DEFAULT_PAGINATION = 10

STATIC_PATHS = ['images']

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
