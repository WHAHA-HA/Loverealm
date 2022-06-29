$ ->
  $(document).on 'click', '.share-button-container .external-sharing', (e) ->
    e.preventDefault()
    $(this).parents('.share-button-container').siblings('.share-buttons').toggleClass('hidden')

  $(document).on 'mouseleave', '.content', (e) ->
    $(this).find('.share-buttons').addClass('hidden')
