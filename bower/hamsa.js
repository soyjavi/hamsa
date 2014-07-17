/**
 * hamsa - Object.Observe wrapper.
 * @version v0.07.17
 * @link    https://github.com/soyjavi/hamsa
 * @author  Javi Jimenez Villar (@soyjavi) (https://twitter.com/soyjavi)
 * @license MIT
 */
(function(){"use strict";var x,t;x=["included","extended"],window.Hamsa=function(){function x(){this.uid=t(),this.className=this.constructor.name}return x.records={},x.create=function(x){var t;return t=new this(x)},x}(),t=function(){return"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g,function(x){var t,n;return t=16*Math.random()|0,n="x"===x?t:3&t|8,n.toString(16)}).toUpperCase()}}).call(this);