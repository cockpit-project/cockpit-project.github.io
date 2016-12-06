---
---
today = new Date()
currentYear = today.getFullYear()
hashInfo = []
calendarData = {}
prefix = ''

getHash = ->
  if document.location.hash != ''
    hashInfo = document.location.hash.slice(1).split('/')
  else
    hashInfo = []

scrollTo = (hash) ->
  setTimeout(->
    el = document.getElementById(hash.slice(1))

    if el
      parent = if el.nodeName == 'H2'
        el.parentElement.parentElement
      else
        el.parentElement

      parent.scrollIntoView({behavior: 'smooth', block: 'start'})
  , 0)

slugify = (name) ->
  # TODO: Enhance slugification
  name.toLowerCase().replace(/[^\w]/g, '-')

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

makeQuickLinks = (allConfs) ->
  $lis = $('h2.event>a', allConfs).clone().map((el) ->
    @['title'] = ''
    $('<li>').append(@)[0]
  )

  $ul = $('<ul>').append($lis)

  $("""
    <div id="#{prefix}quicklinks" class="quicklinks">
      <h2>Quicklinks</h2>
    </div>
    """).append($ul)

processAllEvents = (events) ->
  formatted = []

  for year of events
    for item of events[year]
      event = events[year][item]

      if event['start']

        event['title'] = event['name']

        event['current'] = new Date(event['end']) > today

        event['className'] = if event['current']
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

  getHash()
  yearOnly = +hashInfo[0]

  numberOfEvents = 0

  # $list.html('')

  $allConfs = $('<div></div>')

  for yearLabel, year of data
    continue if yearOnly && +yearLabel != yearOnly

    prefix = if yearOnly
      yearLabel + "/"
    else
      ""

    for label, conf of year
      continue unless new Date(conf.end) > today || yearOnly

      numberOfEvents += 1

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

      confEnd = if conf.end
          """
                  -
                  <abbr class="dtend" title="#{ conf.end }">#{
                    humanizeDate conf.end
                  }</abbr>
          """
        else
          ''

      $conf = $("""
        <div class="conference">
          <a class="top" href="##{ prefix }quicklinks">Back to top</a>
          <div class="vevent">
            <h2 class="event summary" id="#{ confID }">
              <a href="##{ confID }" title="Link to this conference directly">
                #{ conf.name }
              </a>
            </h2>
            <div class="conference-info">
              #{ location || '' }
              <h3 class="date">
                <abbr class="dtstart" title="#{ conf.start }">#{ 
                  humanizeDate conf.start
                  }</abbr>
                #{ confEnd }
              </h3>
              #{ description || '' }
            </div>
          </div>
        </div>
        """)

      if conf.talks
        conf.talks.forEach (talk) ->
          talkID = confID + '/' + slugify talk.title

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

          $conf.append($talk)

      $allConfs.append($conf)

  $allConfs.prepend(makeQuickLinks $allConfs)

  $list.html($allConfs.children())

  scrollTo(document.location.hash)

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
  # TODO: Dynamically load by year (so not all events are loaded at once)
  
  # Set events_data (in _config.yml) to the URL where events data resides
  eventsData = '{{
    site.events_data
    | default: '//rhevents-duckosas.rhcloud.com/all.json'
  }}'

  # Grab and format events
  $.get eventsData, processCalendar

  #window.onhashchange = processEventList if "onhashchange" in window
  window.onhashchange = (foo) ->
    processEventList(calendarData)
