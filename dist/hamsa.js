/**
 * hamsa - A dead simple, data-binding & observable model.
 * @version v0.11.1
 * @link    http://gethamsa.com
 * @author  Javi Jimenez Villar (http://soyjavi.com)
 * @license MIT
 */

/*
Basic Module

@namespace  Hamsa
@class      Module

@author     Javier Jimenez Villar <javi.jimenez.villar@gmail.com> || @soyjavi
 */

(function() {
  'use strict';
  var DEFAULT_EVENTS, _cast, _constructorUpdate, _existObserver, _guid, _unobserve,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  DEFAULT_EVENTS = ['add', 'update', 'delete'];

  (function(exports) {
    var Hamsa;
    Hamsa = (function() {

      /*
      Set a array of fields used in the Class
      @method fields
      @param  {string}    Unknown arguments, each argument is the name of field.
       */
      Hamsa.define = function(fields1) {
        var field;
        this.fields = fields1 != null ? fields1 : {};
        this.events = [];
        this.names = (function() {
          var results;
          results = [];
          for (field in this.fields) {
            results.push(field);
          }
          return results;
        }).call(this);
        this.observers = [];
        this.records = {};
        return this;
      };


      /*
      Returns all instances of the Class
      @method all
      @return {array}     Array of all repository instances.
       */

      Hamsa.all = function() {
        return this.find();
      };


      /*
      Destroy all instances of the Class
      @method destroyAll
      @return {array}     Empty array of all repository instances.
       */

      Hamsa.destroyAll = function() {
        var uid;
        for (uid in this.records) {
          delete this.records[uid];
        }
        return this.records;
      };


      /*
      Returns instances of the defined Hamsa Class
      @method find
      @param  {object}  [OPTIONAL] Specifies selection criteria using query operators.
                        To return all instances, omit this parameter.
      @return {array}   Array of Hamsa instances
       */

      Hamsa.find = function(query) {
        var exists, field, record, records, ref, uid, value;
        if (query == null) {
          query = {};
        }
        records = [];
        ref = this.records;
        for (uid in ref) {
          record = ref[uid];
          exists = true;
          for (field in query) {
            value = query[field];
            if (exists) {
              if (_cast(record[field], this.fields[field]) !== value) {
                exists = false;
              }
            }
          }
          if (exists) {
            records.push(record);
          }
        }
        return records;
      };


      /*
      Returns one instance that satisfies the specified query criteria
      @method findOne
      @param  {object}  [OPTIONAL] Specifies selection criteria using query operators.
                        To return the first instance, omit this parameter.
      @return {object}  Hamsa instance.
       */

      Hamsa.findOne = function(query) {
        return this.find(query)[0];
      };


      /*
      Modifies and returns a single instance
      @method findAndModify
      @param  {object}  Document parameter with the embedded document fields.
      @return {object}  Hamsa instance.
       */

      Hamsa.findAndModify = function(document) {
        var key, record, ref, value;
        record = this.findOne(document.query);
        if (record) {
          ref = document.update;
          for (key in ref) {
            value = ref[key];
            record[key] = value;
          }
        }
        return record || new this(document.update);
      };


      /*
      Observe changes in instance repository.
      @method observe
      @param  {function}  A function to execute each time the object is changed.
      @return {array}     Observers availables.
       */

      Hamsa.observe = function(callback, events1) {
        this.events = events1 != null ? events1 : DEFAULT_EVENTS;
        Object.observe(this.records, (function(_this) {
          return function(states) {
            var constructor, event, j, len, ref, ref1, results, state;
            if (_existObserver(_this.observers, callback)) {
              results = [];
              for (j = 0, len = states.length; j < len; j++) {
                state = states[j];
                constructor = ((ref = _this.records[state.name]) != null ? ref.constructor : void 0) || state.oldValue.constructor;
                if (constructor === _this) {
                  event = {
                    type: state.type,
                    name: state.name
                  };
                  if ((ref1 = state.type) === 'add' || ref1 === 'update') {
                    event.object = _this.records[state.name];
                  } else {
                    event.oldValue = state.oldValue;
                  }
                  results.push(callback(event));
                } else {
                  results.push(void 0);
                }
              }
              return results;
            }
          };
        })(this), this.events);
        this.observers.push(callback);
        return this.observers;
      };


      /*
      Unobserve changes in instance repository.
      @method unobserve
      @return {array}    Observers availables.
       */

      Hamsa.unobserve = function(callback) {
        return this.observers = _unobserve(this, callback);
      };


      /*
      Create a nre instance for a Hamsa Class.
      @method constructor
      @param  {object}    Fields for the instance.
      @param  {function}  A function to execute each time the fields change.
      @return {object}    Hamsa instance.
       */

      function Hamsa(fields, callback, events) {
        var define, field, ref, ref1;
        if (fields == null) {
          fields = {};
        }
        if (events == null) {
          events = DEFAULT_EVENTS;
        }
        this.constructor.className = this.constructor.name;
        this.constructor.records[this.uid = _guid()] = this;
        ref = this.constructor.fields;
        for (field in ref) {
          define = ref[field];
          if (fields[field] || (define["default"] != null)) {
            if (typeof this[field] === 'function') {
              this[field](fields[field] || define["default"]);
            } else {
              this[field] = _cast(fields[field], define);
            }
          }
        }
        this.observers = [];
        if (callback != null) {
          this.observe(callback, events);
          this.observers.push(callback);
        } else if (!callback && indexOf.call((ref1 = this.constructor) != null ? ref1.events : void 0, 'update') >= 0) {
          Object.observe(this, (function(_this) {
            return function(states) {
              var j, len, ref2, results, state;
              results = [];
              for (j = 0, len = states.length; j < len; j++) {
                state = states[j];
                if (state.object.constructor === _this.constructor) {
                  if (ref2 = state.name, indexOf.call(_this.constructor.names, ref2) >= 0) {
                    results.push(_constructorUpdate(state, _this.constructor));
                  } else {
                    results.push(void 0);
                  }
                }
              }
              return results;
            };
          })(this), ['update']);
        }
        this;
      }


      /*
      Observe changes in a determinate Hamsa instance.
      @method observe
      @param  {function}  A function to execute each time the fields change.
      @return {array}    Observers availables for the instance.
       */

      Hamsa.prototype.observe = function(callback, events) {
        if (events == null) {
          events = DEFAULT_EVENTS;
        }
        Object.observe(this, (function(_this) {
          return function(states) {
            var j, len, ref, results, state;
            if (_existObserver(_this.observers, callback)) {
              results = [];
              for (j = 0, len = states.length; j < len; j++) {
                state = states[j];
                if (!(ref = state.name, indexOf.call(_this.constructor.names, ref) >= 0)) {
                  continue;
                }
                delete state.object.observer;
                _constructorUpdate(state, _this.constructor);
                results.push(callback(state));
              }
              return results;
            }
          };
        })(this), events);
        this.observers.push(callback);
        return this.observers;
      };


      /*
      Unobserve changes in a determinate Hamsa instance.
      @method unobserve
      @return {array}    Observers availables for the instance.
       */

      Hamsa.prototype.unobserve = function(callback) {
        return this.observers = _unobserve(this, callback);
      };


      /*
      Destroy current Hamsa instance
      @method destroy
      @return {object}    Current Hamsa instance
       */

      Hamsa.prototype.destroy = function(trigger) {
        var callback, j, len, ref;
        if (trigger == null) {
          trigger = true;
        }
        if (trigger) {
          ref = this.observers;
          for (j = 0, len = ref.length; j < len; j++) {
            callback = ref[j];
            callback({
              type: 'destroy',
              name: this.uid,
              oldValue: this.fields()
            });
          }
        }
        return delete this.constructor.records[this.uid];
      };

      Hamsa.prototype.fields = function() {
        var j, len, name, ref, value;
        value = {};
        ref = this.constructor.names;
        for (j = 0, len = ref.length; j < len; j++) {
          name = ref[j];
          value[name] = this[name];
        }
        return value;
      };

      return Hamsa;

    })();
    if (typeof define === 'function' && define.amd) {
      define(function() {
        return Hamsa;
      });
    } else {
      exports.Hamsa = Hamsa;
    }
    if ((typeof module !== "undefined" && module !== null) && (module.exports != null)) {
      return module.exports = Hamsa;
    }
  })(this);

  _cast = function(value, define) {
    if (define == null) {
      define = {
        type: String
      };
    }
    if (define.type !== Date && define.type !== Array) {
      return define.type(value || define["default"]);
    } else if (define.type === Array) {
      return value || define["default"];
    } else {
      return value || define.type(define["default"]);
    }
  };

  _constructorUpdate = function(state, className) {
    var j, len, observer, ref, ref1, results;
    ref = className.observers;
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      observer = ref[j];
      if (state.type === 'update' && (ref1 = state.type, indexOf.call(className.events, ref1) >= 0)) {
        delete state.object.observer;
        results.push(observer(state));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  _existObserver = function(observers, callback) {
    var exists, j, len, observer;
    exists = false;
    for (j = 0, len = observers.length; j < len; j++) {
      observer = observers[j];
      if (!(observer === callback)) {
        continue;
      }
      exists = true;
      break;
    }
    return exists;
  };

  _guid = function() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r, v;
      r = Math.random() * 16 | 0;
      v = c === 'x' ? r : r & 3 | 8;
      return v.toString(16);
    }).toUpperCase();
  };

  _unobserve = function(instance, callback) {
    var index, j, len, observe, ref;
    ref = instance.observers;
    for (index = j = 0, len = ref.length; j < len; index = ++j) {
      observe = ref[index];
      if (callback) {
        if (observe === callback) {
          Object.unobserve(instance, observe);
          instance.observers.splice(index, 1);
          break;
        }
      } else {
        Object.unobserve(instance, observe);
      }
    }
    if (!callback) {
      instance.observers = [];
    }
    return instance.observers;
  };


  /*
  Easy way for extends Javascript 'Classes'
  
  @namespace  window
  @class      Extends
  
  @author     Javier Jimenez Villar <javi.jimenez.villar@gmail.com> || @soyjavi
   */

  "use strict";

  window._extends = function(child, parent) {
    var ctor, key;
    ctor = function() {
      this.constructor = child;
    };
    for (key in parent) {
      if (_hasProp.call(parent, key)) {
        child[key] = parent[key];
      }
    }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };

  window._hasProp = {}.hasOwnProperty;


  /*
  Polyfill for navigator who don't support Object.observe (ES7)
  
  @namespace  Hamsa.Polyfill
  @class      Polyfill
  
  @author     Javier Jimenez Villar <javi.jimenez.villar@gmail.com> || @soyjavi
   */

  "use strict";

  Object.observe || (function(O, A, root) {
    var addChangeRecord, deliverHandlerRecords, handlers, inArray, nextFrame, observe, observed, performPropertyChecks, runGlobalLoop, setHandler;
    DEFAULT_EVENTS = ['add', 'update', 'delete'];
    inArray = A.indexOf || (function(array, pivot, start) {
      return A.prototype.indexOf.call(array, pivot, start);
    });
    nextFrame = root.requestAnimationFrame || root.webkitRequestAnimationFrame || (function() {
      var initial, last;
      initial = +(new Date);
      last = initial;
      return function(func) {
        var now;
        now = +(new Date);
        return setTimeout((function() {
          return func((last = +(new Date)) - initial);
        }), 17);
      };
    })();
    observe = function(object, handler, events) {
      var data, key, properties, value;
      data = observed.get(object);
      if (data) {
        return setHandler(object, data, handler, events);
      } else {
        properties = Object.getOwnPropertyNames(object);
        data = {
          handlers: new Map,
          properties: properties,
          values: (function() {
            var results;
            results = [];
            for (key in object) {
              value = object[key];
              if (indexOf.call(properties, key) >= 0) {
                results.push(value);
              }
            }
            return results;
          })()
        };
        observed.set(object, data);
        setHandler(object, data, handler, events);
        if (observed.size === 1) {
          return nextFrame(runGlobalLoop);
        }
      }
    };
    setHandler = function(object, data, handler, events) {
      var handler_data;
      handler_data = handlers.get(handler);
      if (!handler_data) {
        handlers.set(handler, handler_data = {
          observed: new Map,
          changeRecords: []
        });
      }
      handler_data.observed.set(object, {
        events: events,
        data: data
      });
      return data.handlers.set(handler, handler_data);
    };
    performPropertyChecks = function(data, object, except) {
      var i, index, j, key, keys, len, old_value, properties, properties_length, value, values;
      if (!data.handlers.size) {
        return;
      }
      values = data.values;
      keys = Object.getOwnPropertyNames(object);
      properties = data.properties.slice();
      properties_length = properties.length;
      for (j = 0, len = keys.length; j < len; j++) {
        key = keys[j];
        index = inArray(properties, key);
        value = object[key];
        if (index === -1) {
          addChangeRecord(object, data, {
            name: key,
            type: 'add',
            object: object
          }, except);
          data.properties.push(key);
          values.push(value);
        } else {
          old_value = values[index];
          properties[index] = null;
          properties_length--;
          if ((old_value === value ? old_value === 0 && 1 / old_value !== 1 / value : old_value === old_value || value === value)) {
            addChangeRecord(object, data, {
              name: key,
              type: 'update',
              object: object,
              oldValue: old_value
            }, except);
            data.values[index] = value;
          }
        }
      }
      i = properties.length;
      while (properties_length && i--) {
        if (properties[i] !== null) {
          addChangeRecord(object, data, {
            name: properties[i],
            type: 'delete',
            object: object,
            oldValue: values[i]
          }, except);
          data.properties.splice(i, 1);
          data.values.splice(i, 1);
          properties_length--;
        }
      }
    };
    addChangeRecord = function(object, data, changeRecord, except) {
      data.handlers.forEach(function(handler_data) {
        var events;
        events = handler_data.observed.get(object).events;
        if ((typeof except !== 'string' || inArray(events, except) === -1) && inArray(events, changeRecord.type) > -1) {
          handler_data.changeRecords.push(changeRecord);
        }
      });
    };
    runGlobalLoop = function() {
      if (observed.size) {
        observed.forEach(performPropertyChecks);
        handlers.forEach(deliverHandlerRecords);
        nextFrame(runGlobalLoop);
      }
    };
    deliverHandlerRecords = function(handler_data, handler) {
      if (handler_data.changeRecords.length) {
        handler(handler_data.changeRecords);
        handler_data.changeRecords = [];
      }
    };
    observed = new Map;
    handlers = new Map;

    /*
    @function Object.observe
    @see http://arv.github.io/ecmascript-object-observe/#Object.observe
     */
    O.observe = function(object, handler, events) {
      if (events == null) {
        events = DEFAULT_EVENTS;
      }
      if (!object || typeof object !== 'object' && typeof object !== 'function') {
        throw new TypeError('Object.observe cannot observe non-object');
      }
      if (typeof handler !== 'function') {
        throw new TypeError('Object.observe cannot deliver to non-function');
      }
      if (O.isFrozen && O.isFrozen(handler)) {
        throw new TypeError('Object.observe cannot deliver to a frozen function object');
      }
      if (arguments.length > 2 && typeof events !== 'object') {
        throw new TypeError('Object.observe cannot use non-object accept list');
      }
      observe(object, handler, events);
      return object;
    };

    /*
    @function Object.unobserve
    @see http://arv.github.io/ecmascript-object-observe/#Object.unobserve
     */
    return O.unobserve = function(object, handler) {
      var handler_data, odata;
      if (object === null || typeof object !== 'object' && typeof object !== 'function') {
        throw new TypeError('Object.unobserve cannot unobserve non-object');
      }
      if (typeof handler !== 'function') {
        throw new TypeError('Object.unobserve cannot deliver to non-function');
      }
      handler_data = handlers.get(handler);
      odata = void 0;
      if (handler_data && (odata = handler_data.observed.get(object))) {
        handler_data.observed.forEach(function(odata, object) {
          performPropertyChecks(odata.data, object);
        });
        nextFrame(function() {
          deliverHandlerRecords(handler_data, handler);
        });
        if (handler_data.observed.size === 1 && handler_data.observed.has(object)) {
          handlers['delete'](handler);
        } else {
          handler_data.observed['delete'](object);
        }
        if (odata.data.handlers.size === 1) {
          observed['delete'](object);
        } else {
          odata.data.handlers['delete'](handler);
        }
      }
      return object;
    };
  })(Object, Array, this);

}).call(this);
