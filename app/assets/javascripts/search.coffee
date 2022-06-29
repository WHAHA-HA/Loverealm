$ ->
  footer_content = (data) ->
    '<div class="tt-dataset-footer">' +
      'See all: ' +
      "<a href=\"/dashboard/search?filter=#{data.query}&type=people\">People</a>" +
      "<a href=\"/dashboard/search?filter=#{data.query}&type=stories\">Stories</a>" +
    '</div>'

  $('.search-text').typeahead(null,
    {
      name: 'user-suggestions',
      display: (user) ->
        "#{user.first_name} #{user.last_name}"
      templates: {
        header: '<h4>Users</h4>',
        footer: footer_content
      },
      source: new Bloodhound(
        datumTokenizer: Bloodhound.tokenizers.whitespace,
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote:
          url: '/dashboard/search/get_autocomplete_data?search=%QUERY',
          wildcard: '%QUERY',
          filter: (response) ->
            response.users
      )
    },
    {
      name: 'content-suggestions',
      display: 'title',
      templates: {
        header: '<h4>Stories</h4>',
        footer: footer_content
      },
      source: new Bloodhound(
        datumTokenizer: Bloodhound.tokenizers.whitespace,
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote:
          url: '/dashboard/search/get_autocomplete_data?search=%QUERY',
          wildcard: '%QUERY',
          filter: (response) ->
            response.contents
      )
    }
  ).on 'typeahead:selected', (e, selection) ->
    # TODO: Add type to make redirection more accuracy
    if selection.title?
      window.location.href = "/dashboard/contents/#{selection.id}"
    else if selection.first_name?
      window.location.href = "/dashboard/users/#{selection.id}/profile"

  $('#search').on 'submit', (e) ->
    return false if $(this).find('input.tt-input').val() == ''
