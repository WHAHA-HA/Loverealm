$ ->
  expr = /(youtu\.be\/|[?&]v=)([\d\w-]{11})/

  formatVideoPrevier = ($element) ->
    $element.css('background-image', "url(http://i.ytimg.com/vi/#{$element.data('id')}/hqdefault.jpg)")
    $element.append $('<div/>', 'class': 'play')

  youtubeVideoPreview = (id) ->
    formatVideoPrevier $('<div class="youtube" />').data('id', id)

  window.injectYoutubeVideoPreview = ($element) ->
    match = $element.text().match(expr)
    if match
      $element.append(youtubeVideoPreview(match[2].trim()))

  $('.status-content-text').each (index, status) ->
    injectYoutubeVideoPreview($(status))

  $('.youtube').each (index, element) ->
    formatVideoPrevier($(element))

  $(document).delegate '.youtube', 'click', ->
    $this = $(this)
    iframe_url = "https://www.youtube.com/embed/#{$this.data('id')}?autoplay=1&autohide=1&enablejsapi=1&iv_load_policy=3"
    if $this.data('params')
      iframe_url += '&' + $this.data('params')

    iframe = $('<iframe/>',
      'frameborder': '0'
      'src': iframe_url
      'allowfullscreen': true
      'width': '100%'
      'height': $this.height())

    $this.replaceWith iframe

  $(document).on 'ajax:success', '.status_in_place', ->
    $element = $(this).parent()
    $element.find('.youtube, iframe').remove()
    injectYoutubeVideoPreview($element)
