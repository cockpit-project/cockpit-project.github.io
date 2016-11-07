---
---
slugify = (name) ->
  # TODO: Enhance slugification
  name.toLowerCase().replace(/[^\w]/g, '-')

processAllEvents = (events) ->
  today = Date.now()
  formatted = []

  for year of events
    for item of events[year]
      event = events[year][item]

      if event['start']

        event['title'] = event['name']

        event['className'] = if new Date(event['end']) > today
          "current"
        else
          "old"

        if event['start'].match(' ')
          event['allDay'] = false
        else
          event['allDay'] = true
          event['className'] += ' fc-x-conf'

        # TODO: Handle talk events for series
        unless event['type'] == 'series'
          formatted.push(event) 

  formatted

processEventList = (data) ->
  $list = $('#all-events')

  # TODO: Make this work per year
  year = 2016
  prefix = year + "/"

  $list.html('')

  $allConfs = $('<div></div>')

  for label, conf of data[year]
    confID = prefix + slugify label

    location = if conf.location
      """
      <h3 class="location">
        <a href="https://maps.google.com/maps?q=#{ conf.location }" target="_blank">
          #{ conf.location }
        </a>
      </h3>
      """

    description = if conf.description
      """
      <div class="description">#{ conf.description }</div>
      """

    $conf = $("""
      <div class="conference">
        <a class="top" href="#quicklinks">Back to top</a>
        <div class="vevent">
          <h2 class="event summary" id="#{ confID }">
            <a href="##{ confID }" title="Link to this conference directly">
              #{ conf.name }
            </a>
          </h2>
          <div class="conference-info">
            #{ location || '' }
            <h3 class="date">
              <abbr class="dtstart" title="#{ conf.start }">#{ conf.start }</abbr>
              -
              <abbr class="dtend" title="#{ conf.end }">#{ conf.end }</abbr>
            </h3>
            #{ description || '' }
          </div>
        </div>
      </div>
      """)

    if conf.talks
      conf.talks.forEach (talk) ->
        talkID = confID + '--' + slugify talk.title

        speaker = if talk.speaker
          """
            <h4 class="speaker">Speaker: #{ talk.speaker }</h4>
          """

        location = if talk.location
          """
            <h4 class="location">Location: #{ talk.location }</h4>
          """

        $talk = $("""
          <div class="vevent talk">
            <h3 id="#{ talkID }" class="summary">
              <a href="##{ talkID }">#{ talk.title }</a>
            </h3>
            #{ speaker || '' }
            #{ location || '' }
            <h4 class="time">
              <abbr class="dtstart" title="#{ talk.start }">#{ talk.start }</abbr>
              -
              <abbr class="dtend" title="#{ talk.end }">#{ talk.end }</abbr>
            </h4>
            <div class="description">#{ talk.description }</div>
          </div>
          """)

        $conf.append($talk)

    $allConfs.append($conf)

  $list.html($allConfs)

processCalendar = (data) ->
  $widget = $("#calendar-widget")

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
  # TODO: Make the URL configurable via liquid
  # TODO: Dynamically load by year (so not all events are loaded at once)
  yearData = '//rhevents-duckosas.rhcloud.com/all.json'

  now = Date.now()

  # Grab and format events
  $.get yearData, processCalendar
