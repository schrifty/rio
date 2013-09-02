window.PanelUsers or= {}

PanelUsers.initted = false

$(document).ready ->
  $('#panel-users').on 'dblclick', (event) ->
    console.log "DOUBLECLICK"

PanelUsers.init = ->
  unless PanelUsers.initted
    AgentAPI.getAgents(
      ( (data) ->
        PanelUsers.populate(data)
        PanelUsers.initted = true
      ),
      ( -> console.log 'Failed to get the agents!' )
    )


PanelUsers.populate = (data) ->
  body = $('#panel-users tbody')
  body.empty()
  for agent in data
    newrow = $('<tr>')
    newrow.append($('<td>').text(agent.display_name)) # name
    newrow.append($('<td class="prettydate" title="' + agent.last_sign_in_at + '">')) # last_logged_in
    newrow.append($('<td>').text(agent.customer_count)) # customers
    newrow.append($('<td class=' + agent.status + '>').text(agent.status)) # status
    newrow.append($('<td>').text(agent.email)) # email
    body.append(newrow)
    $('.prettydate').prettyDate(5)

PanelUsers.messageNotificationHandler = (message) ->
PanelUsers.conversationNotificationHandler = (conversation) ->
PanelUsers.agentNotificationHandler = (agent) ->
  # add a new row to the table
