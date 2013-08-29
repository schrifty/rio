window.PanelSettings ||= {}

PanelSettings.initted = false

PanelSettings.init = ->
  unless PanelSettings.initted
    PanelSettings.initted = true

PanelSettings.messageNotificationHandler = (message) ->
PanelSettings.conversationNotificationHandler = (conversation) ->
