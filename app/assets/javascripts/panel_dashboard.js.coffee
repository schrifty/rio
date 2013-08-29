window.PanelDashboard ||= {}

PanelDashboard.initted = false

PanelDashboard.init = ->
  unless PanelDashboard.initted
    PanelDashboard.initted = true

PanelDashboard.messageNotificationHandler = (message) ->
PanelDashboard.conversationNotificationHandler = (conversation) ->
