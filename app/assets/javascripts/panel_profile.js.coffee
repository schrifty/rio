window.PanelProfile or= {}

PanelProfile.initted = false

$(document).ready ->
  $('#profile-submit').on 'click', (event) -> PanelProfile.processForm(event)
  PanelProfile.$submitStatus = $('#profile-submit-result')

PanelProfile.init = ->
  unless PanelProfile.initted
    AgentAPI.getCurrentAgent(
      ( (data) ->
        PanelProfile.populate(data)
        PanelProfile.initted = true
      ),
      ( -> console.log 'Failed to get the current agent!' )
    )

PanelProfile.processForm = (event) ->
  $('#profile-form').validate( {
    debug: true,
#    onfocusout: true,
#    focusInvalid: true,
#    errorClass: 'has-error',
#    validClass: 'has-success',
    submitHandler: ( (form) ->
      agent = { agent: {
        display_name: $('#profile-name').val(),
        email: $('#profile-email').val()
      }}
      AgentAPI.updateAgent(JSON.parse(sessionStorage.getItem('current_user')).id, agent,
        ( (agent) ->
          sessionStorage.setItem('current_user', agent)
          PanelProfile.$submitStatus.val("Your changes have been successfuly saved")
          PanelProfile.$submitStatus.show()
        ),
        ( ->
          PanelProfile.$submitStatus.val("There was an error")
          PanelProfile.$submitStatus.show()
        )
      )
      return false
    ),
    rules: {
      name: {
        minlength: 2,
        required: true
      },
      email: {
        required: true,
        email: true
      }
    },
    highlight: ( (element) ->
      $(element).closest('.form-group').removeClass('has-success').addClass('has-error')
    )
    success: ( (element) ->
#      element.text("OK!").addClass('valid').closest('.form-group').removeClass('has-error').addClass('has-success')
      element.closest('.form-group').removeClass('has-error')
    )}
  )

PanelProfile.populate = (data) ->
  $('#profile-name').val(data.display_name)
  $('#profile-email').val(data.email)

PanelProfile.messageNotificationHandler = (message) -> # noop
PanelProfile.conversationNotificationHandler = (conversation) -> # noop
PanelProfile.agentNotificationHandler = (agent) -> # noop
