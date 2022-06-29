$ ->
  $('.profile-options-button[data-toggle-panel]').click (e) ->
    e.preventDefault()
    $('.profile-options .profile-options-button').removeClass('active')
    $('.profile-options .option-panel').hide()

    $(this).addClass('active');
    $('.profile-options .option-panel.' + $(this).data('toggle-panel')).show()

