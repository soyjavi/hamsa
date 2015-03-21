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
