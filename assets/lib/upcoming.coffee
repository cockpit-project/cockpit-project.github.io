---
---

slugify = (name) ->
  # TODO: Enhance slugification
  name.toLowerCase().replace(/[^\w]/g, '-')

formatEvents = (data) ->
  $placeholder = $('#upcoming-template > .upcoming-list').clone()
  $template_date  = $('.upcoming-date', $placeholder)
  $template_event = $('.upcoming-event', $placeholder)
  $more_link  = $('.upcoming-more', '#upcoming-template')

  # Now that we've extracted the template pieces, clear the placeholder
  $placeholder.empty()

  # Grab the more link href for the base event link generation
  base_link = $more_link.find('a').attr('href')

  # Overload data with series talks
  data
    .filter (item) ->
      # Only work on the series types with talks
      item['type'] == 'series' && item['talks']
    .forEach (item) ->
      item['talks'].forEach (talk) ->
        # Make the name a combo of the series title and talk
        talk['name'] = item.name + ': ' + talk.title
        # Be certain we're only using the date (and not time)
        talk['start'] = talk.start.split(' ')[0]
        # Add the talk as a high-level event in the event data
        data.push talk

  # Remove series
  events = data.filter (item) ->
    item['type'] != 'series'

  items_displayed = 0

  # Process each conference
  events
    .sort (a,b) -> a.start > b.start
    .forEach (item) ->
      date = new Date item.start
      $date = $template_date.clone()
      $event = $template_event.clone()

      # TODO: Handle keyword defined by liquid
      keyword = new RegExp 'conf', 'i'

      keyword = undefined

      if keyword
        keyword_match =
          item.description.match(keyword) ||
          item.name.match(keyword) ||
          (item.tag && item.tag.match(keyword))
      else
        keyword_match = true

      # Insert proper date
      $date
        .find('.day').html(date.getDate()).end()
        .find('.month').html(date.toLocaleFormat('%b')).end()
        .attr('title', item.start)

      # Insert event title and link
      $event
        .find('a')
        .html(item.name)
        .attr('title', item.description)
        .attr('href', base_link + '#' + slugify(item.name))

      # Ensure the date has not passed and that it's limited properly
      # TODO: Make iteration # based on site-configured liquid tags
      if date >= Date.now() && items_displayed <  15 && keyword_match
        items_displayed++

        # Add event info to the placeholder
        $placeholder.append($date).append($event)

  # Add finalized event info and the more link to the upcoming section
  $('#upcoming').html($placeholder).append($more_link)

$ ->
  # TODO: Make the URL configurable via liquid
  eventsData = '//rhevents-duckosas.rhcloud.com/upcoming.json'

  # Grab and format events
  $.get eventsData, formatEvents
