###
Basic Module with extend/include methods

@namespace Atoms.Core
@class Module

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###
"use strict"

MODULE_KEYWORDS = ['included', 'extended']

class window.Hamsa

  # -- STATIC ------------------------------------------------------------------
  @records = {}


  @create: (attributes) ->
    record = new @ attributes

  # -- INSTANCE ----------------------------------------------------------------
  ###
  Sets a unique identifier (uid) to created instance.
  @method constructor
  ###
  constructor: ->
    @uid = _guid()
    @className = @constructor.name

_guid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else r & 3 | 8
    v.toString 16
  .toUpperCase()
