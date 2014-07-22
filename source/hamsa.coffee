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
  ###
  Instance repository.
  ###
  @records  = {}

  ###
  Observer reference
  ###
  @observer = undefined

  ###
  Finds a determinate instance with a field attribute.
  @method all
  @return {array}     Array of all repository instances.
  ###
  @all: ->
    records = []
    records.push record for uid, record of @records
    return records

  ###
  Finds a determinate instance with a field attribute.
  @method findBy
  @param  {string}    Name of field to search.
  @param  {string}    Value to filter search.
  @return {object}    Hamsa instance.
  ###
  @findBy: (name, value) ->
    return record for uid, record of @records when record[name] is value
    return null

  ###
  Observe changes in instance repository.
  @method observe
  @param  {function}  A function to execute each time the object is changed.
  @return {object}    A object observe state.
  ###
  @observe: (callback) ->
    @observer = Object.observe @records, (states) ->
      callback state for state in states

  ###
  Observe changes in instance repository.
  @method observe
  @param  {function}  A function to execute each time the object is changed.
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
  constructor: (@fields, observeCallback) ->
    @uid = _guid()
    @constructor.className = @constructor.name
    @constructor.records[@uid] = @fields
    @observe observeCallback if observeCallback?
    @

  ###
  Observe changes in a determinate Hamsa instance.
  @method observe
  @param  {function}  A function to execute each time the fields change.
  @return {object}    A object observe state.
  ###
  observe: (callback, add = true, update = true, destroy = true) ->
    Object.observe @fields, (states) -> callback state for state in states


# -- PRIVATE -------------------------------------------------------------------
_guid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else r & 3 | 8
    v.toString 16
  .toUpperCase()
