/**
 * hamsa - A dead simple, data-binding & observable model.
 * @version v0.9.20
 * @link    http://gethamsa.com
 * @author  Javi Jimenez Villar (http://soyjavi.com)
 * @license MIT
 */
(function(){"use strict";var e,t,n,r,o=[].indexOf||function(e){for(var t=0,n=this.length;n>t;t++)if(t in this&&this[t]===e)return t;return-1};e=["add","update","delete"],function(s){var i;return i=function(){function s(s,i,u){var c,a,l,f;null==s&&(s={}),null==u&&(u=e),this.constructor.className=this.constructor.name,this.constructor.records[this.uid=r()]=this,l=this.constructor.fields;for(a in l)c=l[a],(s[a]||null!=c["default"])&&("function"==typeof this[a]?this[a](s[a]||c["default"]):this[a]=t(s[a],c));this.callbacks=[],this.observers=[],null!=i?this.observe(i,u):!i&&o.call(null!=(f=this.constructor)?f.events:void 0,"update")>=0&&Object.observe(this,function(e){return function(t){var r,s,i,u,c;for(u=[],r=0,s=t.length;s>r;r++)c=t[r],c.object.constructor===e.constructor&&(i=c.name,o.call(e.constructor.names,i)>=0?u.push(n(c,e.constructor)):u.push(void 0));return u}}(this),["update"])}return s.define=function(e){var t;return this.fields=null!=e?e:{},this.callbacks=[],this.events=[],this.names=function(){var e;e=[];for(t in this.fields)e.push(t);return e}.call(this),this.observers=[],this.records={},this},s.all=function(){return this.find()},s.destroyAll=function(){var e;for(e in this.records)delete this.records[e];return this.records},s.find=function(e){var n,r,o,s,i,u,c;null==e&&(e={}),s=[],i=this.records;for(u in i){o=i[u],n=!0;for(r in e)c=e[r],n&&t(o[r],this.fields[r])!==c&&(n=!1);n&&s.push(o)}return s},s.findOne=function(e){return this.find(e)[0]},s.findAndModify=function(e){var t,n,r,o;if(n=this.findOne(e.query)){r=e.update;for(t in r)o=r[t],n[t]=o}return n||new this(e.update)},s.observe=function(t,n){var r;return this.events=null!=n?n:e,r=Object.observe(this.records,function(e){return function(n){var r,o,s,i,u,c,a,l;for(a=[],s=0,i=n.length;i>s;s++)l=n[s],r=(null!=(u=e.records[l.name])?u.constructor:void 0)||l.oldValue.constructor,r===e?(o={type:l.type,name:l.name},"add"===(c=l.type)||"update"===c?o.object=e.records[l.name]:o.oldValue=l.oldValue,a.push(t(o))):a.push(void 0);return a}}(this),this.events),this.callbacks.push(t),this.observers.push(r)},s.unobserve=function(){var e,t,n,r;for(r=this.observers,e=0,t=r.length;t>e;e++)n=r[e],Object.unobserve(this.records,n);return this.callbacks=[],this.observers=[]},s.prototype.observe=function(t,r){var s;return null==r&&(r=e),s=Object.observe(this,function(e){return function(r){var s,i,u,c,a;for(c=[],s=0,i=r.length;i>s;s++)a=r[s],u=a.name,o.call(e.constructor.names,u)>=0&&(delete a.object.observer,n(a,e.constructor),c.push(t(a)));return c}}(this),r),this.callbacks.push(t),this.observers.push(s),s},s.prototype.unobserve=function(){var e,t,n,r;for(r=this.observers,e=0,t=r.length;t>e;e++)n=r[e],Object.unobserve(this,n);return this.callbacks=[],this.observers=[]},s.prototype.destroy=function(e){var t,n,r,o;if(null==e&&(e=!0),e)for(o=this.callbacks,n=0,r=o.length;r>n;n++)(t=o[n])({type:"destroy",name:this.uid,oldValue:this.fields()});return delete this.constructor.records[this.uid]},s.prototype.fields=function(){var e,t,n,r,o;for(o={},r=this.constructor.names,e=0,t=r.length;t>e;e++)n=r[e],o[n]=this[n];return o},s}(),"function"==typeof define&&define.amd?define(function(){return i}):s.Hamsa=i,"undefined"!=typeof module&&null!==module&&null!=module.exports?module.exports=i:void 0}(this),r=function(){return"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g,function(e){var t,n;return t=16*Math.random()|0,n="x"===e?t:3&t|8,n.toString(16)}).toUpperCase()},t=function(e,t){return null==t&&(t={type:String}),t.type!==Date&&t.type!==Array?t.type(e||t["default"]):t.type===Array?e||t["default"]:e||t.type(t["default"])},n=function(e,t){var n,r,s,i,u,c;for(i=t.callbacks,c=[],r=0,s=i.length;s>r;r++)n=i[r],"update"===e.type&&(u=e.type,o.call(t.events,u)>=0)?(delete e.object.observer,c.push(n(e))):c.push(void 0);return c},window._extends=function(e,t){var n,r;n=function(){this.constructor=e};for(r in t)_hasProp.call(t,r)&&(e[r]=t[r]);return n.prototype=t.prototype,e.prototype=new n,e.__super__=t.prototype,e},window._hasProp={}.hasOwnProperty,Object.observe||function(t,n,r){var s,i,u,c,a,l,f,d,h,p;return e=["add","update","delete"],c=n.indexOf||function(e,t,r){return n.prototype.indexOf.call(e,t,r)},a=r.requestAnimationFrame||r.webkitRequestAnimationFrame||function(){var e,t;return e=+new Date,t=e,function(n){var r;return r=+new Date,setTimeout(function(){return n((t=+new Date)-e)},17)}}(),l=function(e,t,n){var r,s,i,u;return r=f.get(e),r?p(e,r,t,n):(i=Object.getOwnPropertyNames(e),r={handlers:new Map,properties:i,values:function(){var t;t=[];for(s in e)u=e[s],o.call(i,s)>=0&&t.push(u);return t}()},f.set(e,r),p(e,r,t,n),1===f.size?a(h):void 0)},p=function(e,t,n,r){var o;return o=u.get(n),o||u.set(n,o={observed:new Map,changeRecords:[]}),o.observed.set(e,{events:r,data:t}),t.handlers.set(n,o)},d=function(e,t,n){var r,o,i,u,a,l,f,d,h,p,v;if(e.handlers.size){for(v=e.values,a=Object.getOwnPropertyNames(t),d=e.properties.slice(),h=d.length,i=0,l=a.length;l>i;i++)u=a[i],o=c(d,u),p=t[u],-1===o?(s(t,e,{name:u,type:"add",object:t},n),e.properties.push(u),v.push(p)):(f=v[o],d[o]=null,h--,(f===p?0===f&&1/f!==1/p:f===f||p===p)&&(s(t,e,{name:u,type:"update",object:t,oldValue:f},n),e.values[o]=p));for(r=d.length;h&&r--;)null!==d[r]&&(s(t,e,{name:d[r],type:"delete",object:t,oldValue:v[r]},n),e.properties.splice(r,1),e.values.splice(r,1),h--)}},s=function(e,t,n,r){t.handlers.forEach(function(t){var o;o=t.observed.get(e).events,("string"!=typeof r||-1===c(o,r))&&c(o,n.type)>-1&&t.changeRecords.push(n)})},h=function(){f.size&&(f.forEach(d),u.forEach(i),a(h))},i=function(e,t){e.changeRecords.length&&(t(e.changeRecords),e.changeRecords=[])},f=new Map,u=new Map,t.observe=function(n,r,o){if(null==o&&(o=e),!n||"object"!=typeof n&&"function"!=typeof n)throw new TypeError("Object.observe cannot observe non-object");if("function"!=typeof r)throw new TypeError("Object.observe cannot deliver to non-function");if(t.isFrozen&&t.isFrozen(r))throw new TypeError("Object.observe cannot deliver to a frozen function object");if(arguments.length>2&&"object"!=typeof o)throw new TypeError("Object.observe cannot use non-object accept list");return l(n,r,o),n},t.unobserve=function(e,t){var n,r;if(null===e||"object"!=typeof e&&"function"!=typeof e)throw new TypeError("Object.unobserve cannot unobserve non-object");if("function"!=typeof t)throw new TypeError("Object.unobserve cannot deliver to non-function");return n=u.get(t),r=void 0,n&&(r=n.observed.get(e))&&(n.observed.forEach(function(e,t){d(e.data,t)}),a(function(){i(n,t)}),1===n.observed.size&&n.observed.has(e)?u["delete"](t):n.observed["delete"](e),1===r.data.handlers.size?f["delete"](e):r.data.handlers["delete"](t)),e}}(Object,Array,this)}).call(this);