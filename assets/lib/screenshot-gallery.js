$(function(){
  var $next, $prev, touchX, touchY;

  // Prevent scrolling the page (used with CSS noScroll class)
  function lockScrolling(bool) {
    $('html').toggleClass('noScroll', bool);
  }

  // Generate the HTML for the zoomed in preview
  function makePreview(element) {
    if (!element) return false;

    // Previous and next elements get tracked in the JS enclosure
    $prev = $('img', $(element).prev('.zoom'));
    $next = $('img', $(element).next('.zoom'));
    
    // Grab the description
    var desc = $('img', element).attr('alt');
    // Format next/previous links when they're relevant
    var prev = $prev.length ? '<a href="#" data-direction="prev" class="screenshot-prev prev"><img alt="previous" src="images/site/arrow-left.svg"></a>' : '';
    var next = $next.length ? '<a href="#" data-direction="next" class="screenshot-next next"><img alt="next" src="images/site/arrow-right.svg"></a>' : '';

    // Generate jQuery document fragment based on the generated HTML
    var $html = $('<div id="imagePreview" class="image-container zoom-out">' + prev + '<img src="' + element.href + '" alt="' + desc + '">' + next + '<p>' + desc + "</p></div>");
    
    return $html;
  }

  // Show the preview
  function showPreview(element) {
    var preview = makePreview(element);
    $('body').append(preview);
    lockScrolling(true);
  }

  // Hotswap the preview for the next or previous
  function switchPreview(direction) {
    var $element = (direction == "next") ? $next : $prev;
    if (!$element) return false;

    var code = makePreview($element.parent()[0]);
    if (!code) return false;
    
    // We're transplanting the contents inside the container, to prevent an animation
    $('#imagePreview').addClass('no-anim').html($(code).children());
    // Add a pulse class, to make the arrow react to a switch
    $('.' + direction, '#imagePreview').addClass('pulse');
  }

  // Close the preview (with a fade and removal)
  function closePreview(element) {
    var $element = $('#imagePreview');

    $element.fadeOut(200, function(){
      $element.remove();
      lockScrolling(false);
    });
  }

  function previewIsVisible() {
    return $('#imagePreview').is(':visible');
  }

  // Bind actions to the document; bubbling up events, handled in specific cases
  $(document).on('click', 'a.screenshot.zoom, .screenshot.zoom a', function(ev){
    // Generate a screenshot preview when clicking on a screenshot thumbnail
    showPreview(this);
    ev.preventDefault();
  }).on('click', '#imagePreview', function(ev){
    // Close, unless clicking on a link
    if (ev.target.nodeName !== 'A') {
      closePreview();
    }
  }).on('click', '.screenshot-next, .screenshot-prev', function(ev){
    // Switch to the next or previous, when clicking on an link arrow
    switchPreview(this.getAttribute('data-direction'));
    ev.preventDefault();
  }).on('keydown', function(ev) {
    // Handle keyboard shortcuts
    var action;

    if (previewIsVisible()) {
      switch (ev.key) {
        // arrows
        case 'ArrowLeft': action = "prev"; break;
        case 'ArrowRight': action = "next"; break;
        case 'ArrowUp': action = "prev"; break;
        case 'ArrowDown': action = "next"; break;
        // Page up / down
        case 'PageUp': action = "prev"; break;
        case 'PageDown': action = "next"; break;
        // Space, shift+space, and backspace
        case ' ':
          if (ev.shiftKey) {
            action = "prev";
          } else {
            action = "next";
          }
          break;
        case 'Backspace': action = "prev"; break;
        // vi keys
        case 'h': action = "prev"; break;
        case 'j': action = "next"; break;
        case 'k': action = "prev"; break;
        case 'l': action = "next"; break;
        // wasd
        case 'w': action = "prev"; break;
        case 's': action = "next"; break;
        case 'a': action = "prev"; break;
        case 'd': action = "next"; break;
        // Escape
        case 'Escape': action = "close"; break;
      }

      if (!action) return true;

      if (action == "close") {
        closePreview();
      } else {
        switchPreview(action);
      }

      ev.preventDefault();
    }
  }).on('wheel', function(ev){
    // Handle mouse scroll events
    var action = (ev.originalEvent.deltaY > 0) ? 'next' : 'prev';
    switchPreview(action);
  });
});
