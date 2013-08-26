window.Menu or= {}

Menu.show = ->
  $('#menu').slideDown()

  # make sure the correct panel is displayed when the page is first loaded
  # TODO pull up the most recent panel
  $('#pill-questions').click()

Menu.hide = ->
  $('#menu').slideUp()
  $('.menu-panel').slideUp()
