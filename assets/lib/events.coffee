---
---
today = new Date()
currentYear = today.getFullYear()
hashInfo = []
calendarData = {}
prefix = ''

## To filter events, use events_filter in _config.yml
keyword = "{{ site.events_filter }}"
## To filter by tag only, set events_filter_tags_only: true in _config.yml
filterByTagOnly = {{ site.events_filter_tags_only | default: false }}

## Return the current document hash in fragments, split by '/'
getHash = ->
  if document.location.hash != ''
    hashInfo = document.location.hash.slice(1).split('/')
  else
    hashInfo = []

## Scroll to a specific event or location, based on the document hash or ID
scrollTo = (hash) ->
  setTimeout(->
    return unless hash.slice(1)

    el = document.getElementById(hash.slice(1))

    if el
      parent = if el.nodeName == 'H2'
        el.parentElement.parentElement
      else
        el.parentElement

      parent.scrollIntoView({behavior: 'instant', block: 'start'})
  , 0)

## Make IDs slugged
slugify = (name) ->
  # TODO: Enhance slugification
  name.toLowerCase().replace(/[^\w]/g, '-')

## Format date in a friendly way
humanizeDate = (date, type) ->
  return date unless date

  if date.match ' '
    dateParts = date.split ' '
    dateTime = dateParts[0] + 'T' + dateParts[1]

    if type == 'start'
      format = '%a %e %b %Y %l:%M%P'
    else 
      format = '%l:%M%P ' + dateParts[2]
  else
    dateTime = date
    format = '%A %e %B'
    format += ' %Y' unless +date.slice(0,4) == currentYear

  new Date(dateTime).toLocaleFormat(format)

## Make a quicklick section based on event IDs
makeQuickLinks = (allEvents) ->
  $lis = $('h2.event>a', allEvents).clone().map((el) ->
    @.title = ''
    $('<li>').append(@)[0]
  ).sort (a, b) -> a.firstChild.href > b.firstChild.href

  $ul = $('<ul>').append($lis)

  $("""
    <div id="#{prefix}quicklinks" class="quicklinks">
      <h2>Quicklinks</h2>
    </div>
    """).append($ul)

# Test to see if the event should be skipped
# Returns true if it should be skipped, false if it should be included
skipEvent = (event) ->
  return false if keyword == ""
  return true unless event

  if keyword
    regex = new RegExp(keyword, 'i')
    match_tags = event.tags?.match(regex)
    match_desc = event.description?.match(regex)
    match_talk = event.talks?.map((t)-> t.description).join(' ').match(regex)

    result = if filterByTagOnly
               match_tags
             else
               match_tags || match_talk || match_desc

    return !result

## Process events for the calendar widget, as the widget expects
## a specific format and needs additional metadata
processAllEvents = (events) ->
  formatted = []

  for year of events
    for item of events[year]
      event = events[year][item]

      continue if skipEvent(event)

      if event.start

        event.title = event.name

        event.current = new Date(event.end) > today

        event.className = if event.current
                            "current"
                          else
                            "old"

        if event.start.match(' ')
          event.allDay = false
        else
          event.allDay = true
          event.className += ' fc-x-conf'

        # TODO: Handle talk events for series
        unless event.type == 'series'
          formatted.push(event) 

  formatted

## Process events for the event list
processEventList = (data) ->
  $list = $('#all-events')

  getHash()
  yearOnly = +hashInfo[0]

  numberOfEvents = 0

  # $list.html('')

  $allEvents = $('<div></div>')

  for yearLabel, year of data
    continue if yearOnly && +yearLabel != yearOnly

    prefix = if yearOnly
      yearLabel + "/"
    else
      ""

    for label, event of year
      continue unless new Date(event.end) > today || yearOnly

      continue if skipEvent(event)

      numberOfEvents += 1

      eventID = prefix + slugify label

      location = if event.location
        """
        <h3 class="location">
          <a href="https://maps.google.com/maps?q=#{ event.location }" target="_blank">
            #{ event.location }
          </a>
        </h3>
        """

      description = if event.description
        """
        <div class="description">#{ event.description }</div>
        """

      eventEnd = if event.end
          """
                  -
                  <abbr class="dtend" title="#{ event.end }">#{
                    humanizeDate event.end
                  }</abbr>
          """
        else
          ''

      $event = $("""
        <div class="conference">
          <a class="top" href="##{ prefix }quicklinks">Back to top</a>
          <div class="vevent">
            <h2 class="event summary" id="#{ eventID }">
              <a href="##{ eventID }" title="Link to this conference directly">
                #{ event.name }
              </a>
            </h2>
            <div class="conference-info">
              #{ location || '' }
              <h3 class="date">
                <abbr class="dtstart" title="#{ event.start }">#{ 
                  humanizeDate event.start
                  }</abbr>
                #{ eventEnd }
              </h3>
              #{ description || '' }
            </div>
          </div>
        </div>
        """)

      if event.talks
        event.talks.forEach (talk) ->
          talkID = eventID + '/' + slugify talk.title

          speaker = if talk.speaker
            """
              <h4 class="speaker">Speaker: #{ talk.speaker }</h4>
            """

          location = if talk.location
            """
              <h4 class="location">Location: #{ talk.location }</h4>
            """

          talk_start = if talk.start
            """
                <abbr class="dtstart" title="#{ talk.start }">#{
                  humanizeDate talk.start, 'start'
                  }</abbr>
            """

          talk_end = if talk.end
            """
                -
                <abbr class="dtend" title="#{ talk.end }">#{
                  humanizeDate talk.end, 'end'
                  }</abbr>
            """

          $talk = $("""
            <div class="vevent talk">
              <h3 id="#{ talkID }" class="summary">
                <a href="##{ talkID }">#{ talk.title }</a>
              </h3>
              #{ speaker || '' }
              #{ location || '' }
              <h4 class="time">
              #{ talk_start || '' }
              #{ talk_end || '' }
              </h4>
              <div class="description">#{ talk.description }</div>
            </div>
            """)

          $event.append($talk)

      $allEvents.append($event)

  $allEvents.prepend(makeQuickLinks $allEvents)

  $list.html($allEvents.children())

  scrollTo(document.location.hash)

## Generate the calendar widget
processCalendar = (data) ->
  $widget = $("#calendar-widget")

  calendarData = data

  processEventList data

  # Init the calendar widget
  $widget.fullCalendar
    editable: false
    eventLimit: 4
    contentHeight: "auto"
    timezone: "local"
    header:
      left: "title"
      firstDay: 1
      center: ""
      right: "today prev,next"
    events: processAllEvents(data)
    # eventMouseover: tooltipShow
    # eventMouseout: tooltipHide
    # eventRender: adjustClasses


$ ->
  # Set events_data (in _config.yml) to the URL where events data resides
  eventsData = '{{
    site.events_data
    | default: '//rhevents-duckosas.rhcloud.com/all.json'
  }}'

  # Grab and format events
  $.get eventsData, processCalendar

  #window.onhashchange = processEventList if "onhashchange" in window
  window.onhashchange = -> processEventList(calendarData)
