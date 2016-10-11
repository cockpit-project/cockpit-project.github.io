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

processCalendar = (data) ->
  $widget = $("#calendar-widget")

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
