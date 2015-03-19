###
Basic Module

@namespace  Hamsa
@class      Module

@author     Javier Jimenez Villar <javi.jimenez.villar@gmail.com> || @soyjavi
###
"use strict"

DEFAULT_EVENTS = ["add", "update", "delete"]

class window.Hamsa

  # -- STATIC ------------------------------------------------------------------
  ###
  Instance repository
  ###
  @records  = {}

  ###
  Observer reference
  ###
  @observer = undefined

  ###
  Set a array of fields used in the Class
  @method fields
  @param  {string}    Unknown arguments, each argument is the name of field.
  ###
  @fields: (attributes...) ->
    @records = {}
    @attributes = attributes or []
    @

  ###
  Returns all instances of the Class
  @method all
  @return {array}     Array of all repository instances.
  ###
  @all: ->
    records = []
    records.push record for uid, record of @records
    records

  ###
  Destroy all instances of the Class
  @method destroyAll
  @return {array}     Empty array of all repository instances.
  ###
  @destroyAll: ->
    delete @records[uid] for uid of @records
    @records

  ###
  Finds a determinate instance with a field attribute.
  @method findBy
  @param  {string}    Name of field to search.
  @param  {string}    Value to filter search.
  @return {object}    Hamsa instance.
  ###
  @findBy: (name, value) ->
    record for uid, record of @records when record[name] is value

  ###
  Observe changes in instance repository.
  @method observe
  @param  {function}  A function to execute each time the object is changed.
  @return {object}    A object observe state.
  ###
  @observe: (handler, events = DEFAULT_EVENTS) ->
    @observer = Object.observe @records, (states) ->
      handler state for state in states
    , events

  ###
  Unobserve changes in instance repository.
  @method unobserve
  @return {object}    A object observe state.
  ###
  @unobserve: ->
    Object.unobserve @records, @observer


  # -- INSTANCE ----------------------------------------------------------------
  ###
  Create a nre instance for a Hamsa Class.
  @method constructor
  @param  {object}    Fields for the instance.
  @param  {function}  A function to execute each time the fields change.
  @return {object}    Hamsa instance.
  ###
  constructor: (attributes = {}, handler, events = DEFAULT_EVENTS) ->
    @constructor.className = @constructor.name
    @constructor.records[@uid = _guid()] = @
    for key, value of attributes
      if typeof @[key] is 'function'
        @[key](value)
      else
        @[key] = value
    @observe handler, events if handler?
    @

  ###
  Observe changes in a determinate Hamsa instance.
  @method observe
  @param  {function}  A function to execute each time the fields change.
  @return {object}    A object observe state.
  ###
  observe: (handler, events = DEFAULT_EVENTS) ->
    @observer = Object.observe @, (states) ->
      for state in states when state.name isnt "observer"
        delete state.object.observer
        handler state
    , events

  ###
  Unobserve changes in a determinate Hamsa instance.
  @method unobserve
  @return {object}    A object observe state.
  ###
  unobserve: ->
    Object.unobserve @fields, @observer


# -- PRIVATE -------------------------------------------------------------------
_guid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else r & 3 | 8
    v.toString 16
  .toUpperCase()
