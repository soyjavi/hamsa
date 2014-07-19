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

  @observe: (callback) ->
    Object.observe @records, (states) -> callback state for state in states

  @findBy: (name, value) ->
    for uid, record of @records when record[name] is value
      return record
    return null

  # -- INSTANCE ----------------------------------------------------------------
  constructor: (attributes) ->
    @uid = _guid()
    @constructor.className = @constructor.name
    @constructor.records[@uid] = attributes
    Object.observe attributes, @onInstanceObserve
    @

  # -- INSTANCE-events ---------------------------------------------------------
  onInstanceObserve: (states) =>
    for state in states
      console.log "Hamsa.Instance >> [#{state.type}] >> #{state.name}: #{state.object[state.name]} (before #{state.oldValue})"

_guid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else r & 3 | 8
    v.toString 16
  .toUpperCase()
