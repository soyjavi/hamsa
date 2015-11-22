###
Basic Module

@namespace  Hamsa
@class      Module

@author     Javier Jimenez Villar <javi.jimenez.villar@gmail.com> || @soyjavi
###
'use strict'

DEFAULT_EVENTS = ['add', 'update', 'delete']

((exports) ->

  class Hamsa

    # -- STATIC ----------------------------------------------------------------
    ###
    Set a array of fields used in the Class
    @method fields
    @param  {string}    Unknown arguments, each argument is the name of field.
    ###
    @define: (@fields = {}) ->
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
    @return {array}     Observers availables.
    ###
    @observe: (callback, @events = DEFAULT_EVENTS) ->
      Object.observe @records, (states) =>
        if _existObserver @observers, callback
          for state in states
            constructor = @records[state.name]?.constructor or state.oldValue.constructor
            if constructor is @
              event = type: state.type, name: state.name
              if state.type in ['add', 'update']
                event.object = @records[state.name]
              else
                event.oldValue = state.oldValue
              callback event
      , @events
      @observers.push callback
      @observers

    ###
    Unobserve changes in instance repository.
    @method unobserve
    @return {array}    Observers availables.
    ###
    @unobserve: (callback) ->
      @observers = _unobserve @, callback

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

      @observers = []
      if callback?
        @observe callback, events
        @observers.push callback
      else if not callback and 'update' in @constructor?.events
        Object.observe @, (states) =>
          for state in states when state.object.constructor is @constructor
            if state.name in @constructor.names
              _constructorUpdate state, @constructor
        , ['update']
      @

    ###
    Observe changes in a determinate Hamsa instance.
    @method observe
    @param  {function}  A function to execute each time the fields change.
    @return {array}    Observers availables for the instance.
    ###
    observe: (callback, events = DEFAULT_EVENTS) ->
      Object.observe @, (states) =>
        if _existObserver @observers, callback
          for state in states when state.name in @constructor.names
            delete state.object.observer
            _constructorUpdate state, @constructor
            callback state
      , events
      @observers.push callback
      @observers

    ###
    Unobserve changes in a determinate Hamsa instance.
    @method unobserve
    @return {array}    Observers availables for the instance.
    ###
    unobserve: (callback) ->
      @observers = _unobserve @, callback

    ###
    Destroy current Hamsa instance
    @method destroy
    @return {object}    Current Hamsa instance
    ###
    destroy: (trigger = true) ->
      if trigger
        for callback in @observers
          callback
            type    : 'destroy'
            name    : @uid
            oldValue: @fields()
      delete @constructor.records[@uid]

    fields: ->
      value = {}
      value[name] = @[name] for name in @constructor.names
      value

  if typeof define is 'function' and define.amd
    define -> Hamsa
  else
    exports.Hamsa = Hamsa

  module.exports = Hamsa if module? and module.exports?

) @

# -- PRIVATE -------------------------------------------------------------------

_cast = (value, define = type: String) ->
  if define.type isnt Date and define.type isnt Array
    define.type value or define.default
  else if define.type is Array
    value or define.default
  else
    value or define.type define.default

_constructorUpdate = (state, className) ->
  for observer in className.observers
    if state.type is 'update' and state.type in className.events
      delete state.object.observer
      observer state

_existObserver = (observers, callback) ->
  exists = false
  for observer in observers when observer is callback
    exists = true
    break
  exists

_guid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else r & 3 | 8
    v.toString 16
  .toUpperCase()

_unobserve = (instance, callback) ->
  for observe, index in instance.observers
    if callback
      if observe is callback
        Object.unobserve instance, observe
        instance.observers.splice index, 1
        break
    else
      Object.unobserve instance, observe
  instance.observers = [] unless callback
  instance.observers
