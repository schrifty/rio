window.AvailabilityWidget ||= {}

$(document).ready ->
  AvailabilityWidget.$logout = $('#logout-action')
  AvailabilityWidget.$logout.on 'click', (event) -> Main.signOut()

  # User wants to go offline
  AvailabilityWidget.$offline = $('#offline-action')
  AvailabilityWidget.$offline.on 'click', (event) ->
    user = JSON.parse(sessionStorage.getItem('current_user'))
    AgentAPI.updateAgent(user.id, { agent : { available: 0 }},
      ( ->
        sessionStorage.setItem('availability', "0")
        AvailabilityWidget.show()
      ),
      ( (errorThrown) -> console.log "Couldn't take user offline: " + errorThrown)
    )

  # User wants to go online
  AvailabilityWidget.$online = $('#online-action')
  AvailabilityWidget.$online.on 'click', (event) ->
    user = JSON.parse(sessionStorage.getItem('current_user'))
    AgentAPI.updateAgent(user.id, { agent: { available: 1 }},
      ( ->
        sessionStorage.setItem('availability', "1")
        AvailabilityWidget.show()
      ),
      ( (errorThrown) -> console.log "Couldn't take user online: " + errorThrown)
    )

AvailabilityWidget.show = ->
  user = JSON.parse(sessionStorage.getItem('current_user'))
  $button = $('#availability-button')
  if sessionStorage.getItem('availability') == "1"
    $('#availability-button-label').text(user.display_name + ' is Online')
    $button.removeClass('btn-inverse').addClass('btn-success')
    AvailabilityWidget.$online.hide()
    AvailabilityWidget.$offline.show()
  else
    $('#availability-button-label').text(user.display_name + ' is Offline')
    $button.removeClass('btn-success').addClass('btn-inverse')
    AvailabilityWidget.$online.show()
    AvailabilityWidget.$offline.hide()
  $button.slideDown()

AvailabilityWidget.hide = ->
  $('#availability-button').slideUp()
