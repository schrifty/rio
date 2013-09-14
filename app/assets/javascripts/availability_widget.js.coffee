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

  AvailabilityWidget.$widget = $('#availability-widget')
  AvailabilityWidget.$button = $('#availability-button')
  AvailabilityWidget.$label = $('#availability-button-label')

AvailabilityWidget.show = ->
  if sessionStorage.getItem('availability') == "1"
    AvailabilityWidget.$label.text('Online')
    AvailabilityWidget.$button.removeClass('btn-warning').addClass('btn-info')
    AvailabilityWidget.$online.hide()
    AvailabilityWidget.$offline.show()
  else
    AvailabilityWidget.$label.text('Offline')
    AvailabilityWidget.$button.removeClass('btn-info').addClass('btn-warning')
    AvailabilityWidget.$online.show()
    AvailabilityWidget.$offline.hide()
  AvailabilityWidget.$widget.slideDown()

AvailabilityWidget.hide = ->
  AvailabilityWidget.$widget.slideUp()
