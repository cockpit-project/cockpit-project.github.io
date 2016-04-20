# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

THEME = "./themes/svbhack"
TYPOGRIFY = True

AUTHOR = u'Cockpit Project'
SITENAME = u'Cockpit Project'
SITEURL = ''
TAGLINE = u'Cockpit Project'

TIMEZONE = 'Utc'

DEFAULT_LANG = u'en'

SITEURL = 'http://cockpit-project.org/blog'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None

# Blogroll
LINKS =  (
          ('Cockpit', 'http://cockpit-project.org/'),
          ('Release Notes', 'http://cockpit-project.org/blog/category/release.html'),
          ('Tutorials', 'http://cockpit-project.org/blog/category/tutorial.html'),
)

# Social widget
SOCIAL = ()

DEFAULT_PAGINATION = 10

STATIC_PATHS = ['images']

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
