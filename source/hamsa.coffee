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

  @findBy: (name, value) ->
    for uid, record of @records when record[name] is value
      return record
    return null

  # -- STATIC-events -----------------------------------------------------------
  Object.observe @records, (states) ->
    for state in states
      console.log "hamsa.#{state.type.toUpperCase()}: ", state


  # -- INSTANCE ----------------------------------------------------------------
  constructor: (attributes) ->
    @uid = _guid()
    @constructor.className = @constructor.name
    @constructor.records[@uid] = attributes
    Object.observe attributes, @onInstanceObserve
    return attributes

  # -- INSTANCE-events ---------------------------------------------------------
  onInstanceObserve: (states) ->
    for state in states
      console.log "HAMSA.Instance @uid.#{state.type} #{state.name} changed to #{state.object[state.name]} from #{state.oldValue}"

_guid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else r & 3 | 8
    v.toString 16
  .toUpperCase()
