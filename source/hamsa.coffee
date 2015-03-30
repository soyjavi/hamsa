###
Basic Module

@namespace  Hamsa
@class      Module

@author     Javier Jimenez Villar <javi.jimenez.villar@gmail.com> || @soyjavi
###
"use strict"

DEFAULT_EVENTS = ["add", "update", "delete"]

((exports) ->

  class Hamsa

    # -- STATIC ------------------------------------------------------------------
    @records    = {}
    @fields     = {}
    @names      = []
    @callbacks  = []
    @observers  = []

    ###
    Set a array of fields used in the Class
    @method fields
    @param  {string}    Unknown arguments, each argument is the name of field.
    ###
    @define: (@fields = {}) ->
      @records = {}
      @names = (field for field of @fields)
      @

    ###
    Returns all instances of the Class
    @method all
    @return {array}     Array of all repository instances.
    ###
    @all: -> do @find

    ###
    Destroy all instances of the Class
    @method destroyAll
    @return {array}     Empty array of all repository instances.
    ###
    @destroyAll: ->
      delete @records[uid] for uid of @records
      @records

    ###
    Returns instances of the defined Hamsa Class
    @method find
    @param  {function}  [OPTIONAL] Function for filter instances
    @return {array}     Array of Hamsa instances
    ###
    @find: (filter) ->
      (record for uid, record of @records when not filter or filter record)

    ###
    Finds a determinate instance with a field attribute.
    @method findBy
    @param  {string}    Name of field to search.
    @param  {string}    Value to filter search.
    @return {object}    Hamsa instance.
    ###
    @findBy: (name, value) ->
      (record for uid, record of @records when record[name] is value)

    ###
    Observe changes in instance repository.
    @method observe
    @param  {function}  A function to execute each time the object is changed.
    @return {object}    A object observe state.
    ###
    @observe: (callback, events = DEFAULT_EVENTS) ->
      observer = Object.observe @records, (states) =>
        for state in states
          event = type: state.type, name: state.name
          if state.type in ["add", "update"]
            event.object = @records[state.name]
          else
            event.oldValue = state.oldValue
          callback event
      , events
      @callbacks.push callback
      @observers.push observer

    ###
    Unobserve changes in instance repository.
    @method unobserve
    @return {object}    A object observe state.
    ###
    @unobserve: ->
      Object.unobserve @records, observer for observer in @observers
      @callbacks = []
      @observers = []

    # -- INSTANCE ----------------------------------------------------------------
    ###
    Create a nre instance for a Hamsa Class.
    @method constructor
    @param  {object}    Fields for the instance.
    @param  {function}  A function to execute each time the fields change.
    @return {object}    Hamsa instance.
    ###
    constructor: (fields = {}, callback, events = DEFAULT_EVENTS) ->
      @constructor.className = @constructor.name
      @constructor.records[@uid = _guid()] = @
      for field, define of @constructor.fields when fields[field] or define.default?
        if typeof @[field] is 'function'
          @[field] fields[field] or define.default
        else
          @[field] = _cast fields[field], define

      @callbacks = []
      @observers = []
      @observe callback, events if callback?
      @

    ###
    Observe changes in a determinate Hamsa instance.
    @method observe
    @param  {function}  A function to execute each time the fields change.
    @return {object}    A object observe state.
    ###
    observe: (callback, events = DEFAULT_EVENTS) ->
      observer = Object.observe @, (states) =>
        for state in states when state.name in @constructor.names
          delete state.object.observer
          callback state
      , events
      @callbacks.push callback
      @observers.push observer
      observer

    ###
    Unobserve changes in a determinate Hamsa instance.
    @method unobserve
    @return {object}    A object observe state.
    ###
    unobserve: ->
      Object.unobserve @, observer for observer in @observers
      @callbacks = []
      @observers = []

    ###
    Destroy current Hamsa instance
    @method destroy
    @return {object}    Current Hamsa instance
    ###
    destroy: (trigger = true) ->
      if trigger
        for callback in @callbacks
          callback
            type    : "destroy"
            name    : @uid
            oldValue: @fields()
      delete @constructor.records[@uid]

    fields: ->
      value = {}
      value[name] = @[name] for name in @constructor.names
      value

  if typeof define is "function" and define.amd
    define -> Hamsa
  else
    exports.Hamsa = Hamsa

  module.exports = Hamsa if module? and module.exports?

) @

# -- PRIVATE -------------------------------------------------------------------
_guid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else r & 3 | 8
    v.toString 16
  .toUpperCase()

_cast = (value, define) ->
  if define.type isnt Date
    define.type value or define.default
  else
    value or define.type define.default
