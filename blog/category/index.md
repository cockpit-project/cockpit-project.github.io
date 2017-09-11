---
title: Blog categories
index: false
---

{% for category in site.categories %}
  {% capture filename %}{{
    page.path | replace: 'index', category[0]
    }}{% endcapture %}

  {% assign cat_page = site.pages | where: 'path', filename | first %}

{% if cat_page.path %}
* [{{ category[0] | capitalize }}]({{ cat_page.url }})
{% endif %}
{% endfor %}
