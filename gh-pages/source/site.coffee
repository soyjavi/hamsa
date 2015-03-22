"use strict"

$ ->
  hljs.initHighlightingOnLoad()

  $("[data-language]").on "click", (event) ->
    event.stopPropagation()
    event.preventDefault()
    el = $ event.currentTarget
    el.addClass("active").siblings("[data-language]").removeClass("active")
    language = el.attr "data-language"
    languages = el.parent().nextUntil("nav")
    languages.find("code.#{language}").parent().addClass("active")
    languages.find("code:not(.#{language})").parent().removeClass("active")

  sections = ({id: $(section).attr("id"), top: section.offsetTop} for section in $ "article section")
  $("article").scroll (event) ->
    scroll = event.target.scrollTop
    links =  $("aside > ul > li > a").removeClass "active"
    for section, index in sections when scroll >= section.top
      unless scroll >= sections[index + 1].top
        links.filter("[href=##{section.id}]").addClass "active"
