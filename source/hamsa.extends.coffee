###
Easy way for extends Javascript 'Classes'

@namespace  window
@class      Extends

@author     Javier Jimenez Villar <javi.jimenez.villar@gmail.com> || @soyjavi
###
"use strict"

window._extends = (child, parent) ->

  ctor = ->
    @constructor = child
    return

  for key of parent when _hasProp.call(parent, key)
    child[key] = parent[key]
  ctor.prototype = parent.prototype
  child.prototype = new ctor
  child.__super__ = parent.prototype
  child

window._hasProp = {}.hasOwnProperty
