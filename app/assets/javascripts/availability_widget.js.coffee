window.AvailabilityWidget ||= {}

$(document).ready ->
  AvailabilityWidget.$logoutButton = $('#logout-button')
  AvailabilityWidget.$logoutButton.on 'click', (event) -> Main.signOut()

  # User wants to go offline
  AvailabilityWidget.$offlineButton = $('#offline-button')
  AvailabilityWidget.$offlineButton.on 'click', (event) ->
    user = JSON.parse(sessionStorage.getItem('current_user'))
    AgentAPI.updateAgent(user.id, { agent : { available: 0 }},
      ( ->
        sessionStorage.setItem('availability', "0")
        AvailabilityWidget.show()
      ),
      ( (errorThrown) -> console.log "Couldn't take user offline: " + errorThrown)
    )

  # User wants to go online
  AvailabilityWidget.$onlineButton = $('#online-button')
  AvailabilityWidget.$onlineButton.on 'click', (event) ->
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
  $('#availability-label').text(user.display_name + ' is ')
  if sessionStorage.getItem('availability') == "1"
    $('#availability-button-label').text('Online')
    $('#availability-button').removeClass('btn-primary').addClass('btn-success')
    AvailabilityWidget.$onlineButton.hide()
    AvailabilityWidget.$offlineButton.show()
  else
    $('#availability-button-label').text('Offline')
    $('#availability-button').removeClass('btn-success').addClass('btn-primary')
    AvailabilityWidget.$onlineButton.show()
    AvailabilityWidget.$offlineButton.hide()
  $('#availability-widget').slideDown()

AvailabilityWidget.hide = ->
  $('#availability-widget').slideUp()
