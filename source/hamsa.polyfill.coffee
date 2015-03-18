###
Polyfill for navigator who don't support Object.observe (ES7)

@namespace  Hamsa.Polyfill
@class      Polyfill

@author     Javier Jimenez Villar <javi.jimenez.villar@gmail.com> || @soyjavi
###
"use strict"

Object.observe or ((O, A, root) ->

  # -- Internal use
  DEFAULT_EVENTS = ['add', 'update', 'delete']

  inArray = A.indexOf or ((array, pivot, start) -> A::indexOf.call array, pivot, start)

  nextFrame = root.requestAnimationFrame or root.webkitRequestAnimationFrame or do ->
    initial = +new Date
    last = initial
    (func) ->
      now = +new Date
      setTimeout (-> func (last = +new Date) - initial), 17

  observe = (object, handler, events) ->
    data = observed.get object
    if data
      setHandler object, data, handler, events
    else
      properties = Object.getOwnPropertyNames object
      data =
        handlers  : new Map
        properties: properties
        values    : (value for key, value of object when key in properties)
      observed.set object, data
      setHandler object, data, handler, events
      nextFrame runGlobalLoop if observed.size is 1

  setHandler = (object, data, handler, events) ->
    handler_data = handlers.get handler
    unless handler_data
      handlers.set handler, handler_data =
        observed      : new Map
        changeRecords : []
    handler_data.observed.set object,
      events  : events
      data    : data
    data.handlers.set handler, handler_data

  performPropertyChecks = (data, object, except) ->
    return if !data.handlers.size
    values = data.values
    keys = Object.getOwnPropertyNames object
    properties = data.properties.slice()
    properties_length = properties.length

    for key in keys
      index = inArray properties, key
      value = object[key]
      if index is -1
        addChangeRecord object, data, {
          name  : key
          type  : 'add'
          object: object
        }, except
        data.properties.push key
        values.push value
      else
        old_value = values[index]
        properties[index] = null
        properties_length--
        if (if old_value is value then old_value is 0 and 1 / old_value isnt 1 / value else old_value is old_value or value is value)
          addChangeRecord object, data, {
            name    : key
            type    : 'update'
            object  : object
            oldValue: old_value
          }, except
          data.values[index] = value

    i = properties.length
    while properties_length and i--
      if properties[i] isnt null
        addChangeRecord object, data, {
          name    : properties[i]
          type    : 'delete'
          object  : object
          oldValue: values[i]
        }, except
        data.properties.splice i, 1
        data.values.splice i, 1
        properties_length--
    return

  addChangeRecord = (object, data, changeRecord, except) ->
    data.handlers.forEach (handler_data) ->
      events = handler_data.observed.get(object).events
      if (typeof except isnt 'string' or inArray(events, except) is -1) and inArray(events, changeRecord.type) > -1
        handler_data.changeRecords.push changeRecord
      return
    return

  runGlobalLoop = ->
    if observed.size
      observed.forEach performPropertyChecks
      handlers.forEach deliverHandlerRecords
      nextFrame runGlobalLoop
    return

  deliverHandlerRecords = (handler_data, handler) ->
    if handler_data.changeRecords.length
      handler handler_data.changeRecords
      handler_data.changeRecords = []
    return

  observed = new Map
  handlers = new Map

  ###
  @function Object.observe
  @see http://arv.github.io/ecmascript-object-observe/#Object.observe
  ###
  O.observe = (object, handler, events = DEFAULT_EVENTS) ->
    if !object or typeof object isnt 'object' and typeof object isnt 'function'
      throw new TypeError 'Object.observe cannot observe non-object'
    if typeof handler isnt 'function'
      throw new TypeError 'Object.observe cannot deliver to non-function'
    if O.isFrozen and O.isFrozen(handler)
      throw new TypeError 'Object.observe cannot deliver to a frozen function object'
    if arguments.length > 2 and typeof events isnt 'object'
      throw new TypeError 'Object.observe cannot use non-object accept list'
    observe object, handler, events
    object

  ###
  @function Object.unobserve
  @see http://arv.github.io/ecmascript-object-observe/#Object.unobserve
  ###
  O.unobserve = (object, handler) ->
    if object is null or typeof object isnt 'object' and typeof object isnt 'function'
      throw new TypeError('Object.unobserve cannot unobserve non-object')
    if typeof handler isnt 'function'
      throw new TypeError('Object.unobserve cannot deliver to non-function')

    handler_data = handlers.get(handler)
    odata = undefined
    if handler_data and (odata = handler_data.observed.get(object))
      handler_data.observed.forEach (odata, object) ->
        performPropertyChecks odata.data, object
        return
      nextFrame ->
        deliverHandlerRecords handler_data, handler
        return

      if handler_data.observed.size is 1 and handler_data.observed.has(object)
        handlers['delete'] handler
      else
        handler_data.observed['delete'] object
      if odata.data.handlers.size is 1
        observed['delete'] object
      else
        odata.data.handlers['delete'] handler
    object

)(Object, Array, this)
