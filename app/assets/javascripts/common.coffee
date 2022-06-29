$ ->
  $(document).on 'change', '.file-upload-button input.upload', ->
    $this = $(this)
    $this.parent().siblings('.file-upload-value').val($this.val())
    if $this.parent().data('autosubmit')
      $this.parents('form').submit()

  $(document).on 'ajax:before', 'form[data-remote="true"]', ->
    $this = $(this)
    $fileUploadButtons = $this.find('.file-upload-button[data-disable-with]')
    if $fileUploadButtons.length
      $fileUploadButtons.data 'disable-primary', $fileUploadButtons.find('span').html()
      $fileUploadButtons.find('span').html($fileUploadButtons.data('disable-with'))

  $(document).on 'ajax:complete ajax:error', 'form[data-remote="true"]', ->
    $this = $(this)
    $fileUploadButtons = $this.find('.file-upload-button[data-disable-with]')
    if $fileUploadButtons.length
      $fileUploadButtons.find('span').html($fileUploadButtons.data('disable-primary'))
      $fileUploadButtons.removeData 'disable-primary'

    $this.find('.file-upload-button').siblings('.file-upload-value').val('Choose File')

  $(document).on 'ajax:error', (e, xhr, settings) ->
    if xhr.status == 401
      window.location.replace('/users/sign_in')

  $(document).on 'inview', '.load-more', ->
    unless $(this).hasClass('load-more--processing')
      $(this).trigger('click')

  $(document).on 'click', '.load-more', (e) ->
    e.preventDefault()
    $this = $(this)
    $this.addClass('load-more--processing');
    $this.find('.glyphicon-refresh').css('display', 'inline-block')
    $.ajax
      type: 'GET'
      url: $this.attr('href')
      dataType: 'script'
      success: ->
        setTimeout (->
          $this.removeClass('load-more--processing');
        ), 1000

        $this.find('.glyphicon-refresh').css('display', 'none')

  window.showAlert = (type, text) ->
    $alert = $("<div class=\"alert alert-#{type}\" />").html(text)
    $('.container.page').prepend($alert)
    $alert.fadeOut 15000, ->
      $(this).remove();


  $(document).on 'input', 'textarea[maxlength]', (e) ->
    $this = $(this)
    $this.parent().find('.max-length-error').remove()
    maxlength = parseInt($this.attr("maxlength"))
    if maxlength && maxlength == $this.val().length
      $error = $('<div class="error max-length-error" />')
                .html("You reached maximum limit of #{maxlength} characters")
      $this.after($error)
