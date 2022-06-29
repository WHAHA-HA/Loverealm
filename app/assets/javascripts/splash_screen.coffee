$ ->
  $('.splash-screen-close').click (e) ->
    e.preventDefault()
    Cookies.set('splash-screen', 'hidden', { expires: 3 })
    $('#splash-screen').remove()
