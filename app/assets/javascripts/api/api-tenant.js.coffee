window.TenantAPI or= {}

TenantAPI.createTenant = (email, display_name) ->
  tenant = { "email" : email, "display_name" : display_name }
  $.ajax '/tenants',
    data: { "tenant" : tenant }
    type: 'POST'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(errorThrown)
      return false
    success: (data) ->
      return true

TenantAPI.updateTenant = (id, data, onsuccess, onfail) ->
  $.ajax '/tenants/' + id,
    type: 'PUT'
    dataType: 'json'
    data: { "tenant": data }
    error: (jqXHR, textStatus, errorThrown) ->
      onfail(errorThrown)
    success: (data) ->
      onsuccess(data)