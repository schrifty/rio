window.ReplyStyle ||= {}

ReplyStyle.init = (opts) ->
  sessionStorage.setItem('tenant', opts['tenant'])
  d = document.createElement("div")
  d.setAttribute("id", "replystyle_tab")
  d.href = "#"
  d.style.display = "block"
  d.style.backgroundColor = "black"
  d.style.left = "-50px"
  d.title = "support"
  d.class = "ReplyStyleTabLeft"
  d.className = "ReplyStyleTabLeft"

  d2 = document.createElement("div")
  d2.setAttribute("id", "feedback_tab_text")
  d2.innerHTML = "Questions?"
  d.appendChild(d2)

  i = document.createElement("iframe")
  i.style.backgroundColor = "transparent"
  i.style.border = "0px none transparent"
  i.style.padding = "0px"
  i.style.overflow = "hidden"

  o = document.createElement("div")
  o.setAttribute("id", "overlay")
  o.class = "overlay"
  o.className = "overlay"
  o.style.display = "none"
  o.appendChild(i)

  document.body.insertBefore(d, document.body.firstChild)
  document.body.insertBefore(o, document.body.firstChild)

  $replyStyleTab = document.getElementById('replystyle_tab')
  $replyStyleTab.addEventListener('click', (event) ->
#    overlay = document.getElementById('overlay')
    if o.style.display != "none"
      o.style.display = "none"
    else
      o.style.display = "inline"
    if i.src != "http://localhost:3000/conversations/new.html"
      i.src = "http://localhost:3000/conversations/new.html"
  )
