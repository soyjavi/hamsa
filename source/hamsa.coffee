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

    # -- STATIC ----------------------------------------------------------------
    ###
    Set a array of fields used in the Class
    @method fields
    @param  {string}    Unknown arguments, each argument is the name of field.
    ###
    @define: (@fields = {}) ->
      @callbacks  = []
      @events     = []
      @names      = (field for field of @fields)
      @observers  = []
      @records    = {}
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
    @param  {object}  [OPTIONAL] Specifies selection criteria using query operators.
                      To return all instances, omit this parameter.
    @return {array}   Array of Hamsa instances
    ###
    @find: (query = {}) ->
      records = []
      for uid, record of @records
        exists = true
        for field, value of query when exists
          exists = false if _cast(record[field], @fields[field]) isnt value
        records.push record if exists
      records

    ###
    Returns one instance that satisfies the specified query criteria
    @method findOne
    @param  {object}  [OPTIONAL] Specifies selection criteria using query operators.
                      To return the first instance, omit this parameter.
    @return {object}  Hamsa instance.
    ###
    @findOne: (query) ->
      @find(query)[0]

    ###
    Modifies and returns a single instance
    @method findAndModify
    @param  {object}  Document parameter with the embedded document fields.
    @return {object}  Hamsa instance.
    ###
    @findAndModify: (document) ->
      record = @findOne document.query
      record[key] = value for key, value of document.update if record
      record or new @ document.update

    ###
    Observe changes in instance repository.
    @method observe
    @param  {function}  A function to execute each time the object is changed.
    @return {object}    A object observe state.
    ###
    @observe: (callback, @events = DEFAULT_EVENTS) ->
      observer = Object.observe @records, (states) =>
        for state in states
          constructor = @records[state.name]?.constructor or state.oldValue.constructor
          if constructor is @
            event = type: state.type, name: state.name
            if state.type in ["add", "update"]
              event.object = @records[state.name]
            else
              event.oldValue = state.oldValue
            callback event
      , @events
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

    # -- INSTANCE --------------------------------------------------------------
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
      if callback?
        @observe callback, events
      else if not callback and "update" in @constructor?.events
        Object.observe @, (states) =>
          for state in states when state.object.constructor is @constructor
            if state.name in @constructor.names
              _constructorUpdate state, @constructor
        , ["update"]
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
          _constructorUpdate state, @constructor
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
  if define.type isnt Date and define.type isnt Array
    define.type value or define.default
  else if define.type is Array
    value or define.default
  else
    value or define.type define.default

_constructorUpdate = (state, className) ->
  for callback in className.callbacks
    if state.type is "update" and state.type in className.events
      delete state.object.observer
      callback state
