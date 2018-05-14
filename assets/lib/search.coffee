---
---

"use strict"

$ ->
  $form = $('#search-form')
  $input = $('#search-input')
  $similar = $('#similar')
  $similarList = $('#similar-list')
  $matchesString = $('#matches')
  $results = $('#results')
  $progress = $('#progress')
  template = $('#template').html()

  searchIndex = null

  ajax = new $.Deferred()

  wordsplit = /[\s,;!?=\+"'\\\/]+/
  typeTimer = null

  generateWordList = ->
    window.wordlistAll = {}

    searchIndex.pages.forEach (obj, pageId) ->
      # Uppercase is a work-around to avoid reserved words
      # (Thanks, JavaScript!)
      obj.wordlist.toUpperCase().split(/\s+/).forEach (word) ->
        return if word == ''

        wordlistAll[word] ||= []

        try
          wordlistAll[word].push pageId
        catch e
          console.log "Problem:", word, pageId
        return

    searchIndex.words = wordlistAll

  loadsearchIndex = ->
    return if ajax.state() == "resolved" && ajax.state() == "pending"

    $.get '{{ site.baseurl }}/search.json', (data)->
      searchIndex = data
      do generateWordList unless data.words
      ajax.resolve data


  displayResults = (words, matches, similar) ->
    $pending = $('<div class="pending"/>')
    pages = searchIndex.pages
    text = $input.val().toLowerCase().replace(/ ?-\w+/g, '').replace(/\+/g, '')

    $('#results-none').hide()

    if matches.length > 0
      fakedate = (new Date).toISOString()

      matches.sort (a, b) ->
        # Sort by date
        dateA = pages[a].date || fakedate
        dateB = pages[b].date || fakedate

        # Title match score (weighted heavily)
        titleA = pages[a].title.toLowerCase().score(text)
        titleB = pages[b].title.toLowerCase().score(text)

        # Summary snippet score (weighted a good bit)
        summA = pages[a].summary.toLowerCase().score(text)
        summB = pages[b].summary.toLowerCase().score(text)

        # Date score (very small weight)
        dateScoreA = Date.parse(dateA.split(' ')[0]) / Date.now() * 0.05
        dateScoreB = Date.parse(dateB.split(' ')[0]) / Date.now() * 0.05

        # Generate page scores
        # (and add a 'score' value to the page info)
        scoreA = pages[a].score = (titleA * 3 + summA + dateScoreA) / 5 / 0.71
        scoreB = pages[b].score = (titleB * 3 + summB + dateScoreB) / 5 / 0.71

        # Sort based on score
        return scoreA < scoreB

      for match in matches
        page = pages[match]

        # Clone search result snippet
        $snippet = $(template)

        # Add data to the cloned template
        $snippet.removeClass('hidden')
          .find('.title').html(page.title).attr('href', page.url).end()
          .find('.url').html(page.url).attr('href', page.url).end()
          .find('.summary').html(page.summary).end()

        if page.date
          $snippet.find('.date').text(page.datestring).end()
        else
          $snippet.find('.date').remove().end()

        # Add snippet to pending (off-page) search results
        $pending.append $snippet

    else
      if $input.val() != ''
        $('#results-none').removeClass('hidden').show()

    # Add search results to the page
    $results.html($pending.children())

    if similar.length > 0
      $similar.removeClass('hidden').hide()
      $similarList.html ->
        result = ''

        $.each similar, (k, v)->
          rating = "Score: " + Math.round(v.score * 50) / 10
          result += '<a href="#%" title="$">%</a> '.replace(/%/g, v.word).replace(/\$/, rating)

        return result

      $similar.show()
    else
      $similar.hide()
      $matchesString.hide()
      $similarList.html('')

    $matchesString
      .find('.number').html(matches.length).end()
      .find('.plural').toggle(matches.length != 1).end()
      .removeClass('hidden').toggle(matches.length != 0)

    $progress.hide()
    $input.focus()


  parseForm = ->
    $progress.removeClass('hidden').show()

    $.when(ajax).done (data)->
      text = $input.val()
      words = text.toLowerCase().trim().split(wordsplit)
      similar = []
      matchers = {matches: [], antimatches: []}

      # Search for each word in the text entry
      for word in words
        # Check for "-" before a word to exclude that word
        polarity = if word.match(/^-/) then 'antimatches' else 'matches'
        # Strip dashes at the beginning and periods at the end of a word
        word = word.replace(/^-/, '').replace(/\.$/, '')
        # Search for the existance of words
        wordMatch = data.words[word.toUpperCase()]

        if wordMatch
          if matchers[polarity].length < 1
            # First word; propogate the matches
            matchers[polarity] = wordMatch
          else
            if polarity == 'matches'
              # Do an AND of matching pages
              matchers[polarity] = matchers[polarity].map (a) ->
                return a unless wordMatch.indexOf(a) < 0
            else
              # Add unique antimatchers
              matchers[polarity] = matchers[polarity]
                .concat wordMatch.filter (item) ->
                    matchers[polarity].indexOf(item) < 0

        # Add similar words to a 'similar' keyword array
        if polarity == 'matches'
          $.map searchIndex.words, (data, key) ->
            keyLow = key.toLowerCase()
            matchscore = keyLow.score(word, 0.5)

            if (matchscore > 0.7) &&
              !similar.filter((s) -> s.word == keyLow)[0] &&
              word != keyLow
                similar.push {word: keyLow, score: matchscore}

      # Sort similar words by similarity score
      similar.sort (a, b) -> a.score < b.score ? a : b

      # Power results with a matches-antimatches reaction
      results = matchers['matches'].filter (match) ->
        match if matchers['antimatches'].indexOf(match) < 0

      # Hand off word matches and similar keywords to the renderer
      displayResults words, results, similar.slice(0,21)


  selectForm = ->
    setTimeout ->
      $input.focus().select()
    , 0


  updateHash = ->
    window.location.hash = "#" + $input.val().trim()


  window.trigger404 = (val) ->
    if $input.val() == ''
      keywords= decodeURIComponent(document.location.pathname)
        .replace val, ''
        .replace '{{ site.permalink | split: '/' | first }}', ''
        .replace /.html$/, ''
        .replace /.md$/, ''
        .replace /[\/\-\_\+]/g, ' '
        .replace /^\s+|\s+$/g, ''

      $input.val(keywords)
      do parseForm


  do loadsearchIndex

  $form
    .on 'keydown', (e)->
      switch e.key
        when "Tab", "Down", "ArrowDown"
          $('#similar a:first,#results a').first().focus()
          do e.preventDefault
        when "Left", "ArrowLeft", "Right", "ArrowRight", "Home", "End", "Esc", "Escape", "Enter"
          # NOOP
        else
          unless e.ctrlKey || e.altKey
            clearTimeout typeTimer
            typeTimer = setTimeout updateHash, 500
    .on 'submit', (e)->
      do updateHash
      do e.preventDefault

  $similar.on 'keydown', 'a', (e)->
    switch e.key
      when "Right", "ArrowRight"
        $(@).next().focus()
      when "Left", "ArrowLeft"
        $(@).prev().focus()
      when "Up", "ArrowUp"
        selectForm()
      when "Down", "ArrowDown"
        $('#results a:first').focus()
      when " "
        $(@).click()
      when "Enter"
        selectForm()

  $results
    .on 'keydown', 'a', (e) ->
      $article = $(@).parentsUntil('#results')
      switch e.key
        when "Down", "ArrowDown"
          $article.next().find('a:first').focus()
        when "Up", "ArrowUp"
          firstChild = $article.filter(':first-child').length != 1
          if firstChild
            selectForm()
          else
            $article.prev().find('a:first').focus()
    .on 'focus', 'a', (e) ->
      $(@).parentsUntil('#results').addClass('highlight')
    .on 'blur', 'a', (e) ->
      $(@).parentsUntil('#results').removeClass('highlight')

  $(document)
    .on 'keydown', (e) ->
      switch e.key
        when "Esc", "Escape"
          $input.val('')
          do updateHash

  $.when(ajax).done (data)->
    do parseForm

  $(window).on 'hashchange', (e)->
    val = @location.hash.substr(1)
    $input.val(decodeURIComponent(val))
    do parseForm

  # Run a search if the URL is like "/search/#foo"
  $(window).trigger 'hashchange' if window.location.hash

  selectForm()
