window.receiver_name_typeahead_options = {
  name: 'receiver_name',
  display: (user) ->
    "#{user.first_name} #{user.last_name}"
  source: new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote:
      url: '/dashboard/messages/search_receiver?search=%QUERY',
      wildcard: '%QUERY'
  )
}
