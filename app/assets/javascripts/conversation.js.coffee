# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#submit').on 'click', (event) ->
    conversation = {"tenant_id" : "1", "active" : "true", "customer_id" : "1", "referer_url" : "http://blah.com"};
    $.ajax "/conversations",
      data: {conversation: conversation},
      type: 'POST',
      dataType: "json",
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(textStatus)
      success: (data) ->
        console.log(data);


