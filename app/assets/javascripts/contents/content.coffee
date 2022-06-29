$ ->
  $(document).on 'click', '.comment-action', (e) ->
    e.preventDefault()
    $comments = $(this).parents('.content').find('.comments .comment')
    if $comments.length > 5
      $comments.slice(0, -5).remove()
      $('.load-more-comments').show()

  $(document).on 'ajax:before', 'a.content-action[data-remote="true"]', ->
    $(this).data('remote', false)

  $(document).on 'ajax:complete ajax:error', 'a.content-action[data-remote="true"]', ->
    $(this).data('remote', true)

  handleScroll = ->
    $sidebarContent = $('.sidebar-content')
    headerHeight = $('header nav').height()
    sidebarMargin = parseInt($sidebarContent.find('.sidebar-item').css('margin-top'))
    offsetTop = $(window).scrollTop() + headerHeight
    if offsetTop > $('.sidebar').offset().top
      unless $sidebarContent.css('position') == 'fixed'
        $sidebarContent.css({
          position: 'fixed',
          top: "#{headerHeight + sidebarMargin}px"
        })
    else
      unless $sidebarContent.css('position') == 'relative'
        $sidebarContent.css({
          position: 'relative',
          top: 'auto'
        })

  if $('.content-with-sidebar').length
    $(window).scroll handleScroll
    handleScroll()
