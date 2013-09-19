window.SearchAPI ||= {}

SearchAPI.query = (query, onsuccess, onfail) ->
  $.ajax '/conversations/search.html',
    dataType: 'html'
    data: { "q" : query }
    error: (jqXHR, textStatus, errorThrown) ->
      onfail(errorThrown)
    success: (data) ->
      onsuccess(data)
