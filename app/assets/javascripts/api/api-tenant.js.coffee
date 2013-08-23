window.TenantAPI or= {}

TenantAPI.createTenant = (email, display_name) ->
  tenant = { "email" : email, "display_name" : display_name }
  $.ajax '/tenants',
    data: { "tenant" : tenant }
    type: 'POST'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
      return false
    success: (data) ->
      return true

