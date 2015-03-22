/**
 * hamsa - Object.Observe wrapper.
 * @version v0.3.22
 * @link    http://gethamsa.com
 * @author  Javi Jimenez Villar (@soyjavi) (http://soyjavi.com)
 * @license MIT
 */
(function(){"use strict";$(function(){var t,a;return hljs.initHighlightingOnLoad(),$("[data-language]").on("click",function(t){var a,e,n;return t.stopPropagation(),t.preventDefault(),a=$(t.currentTarget),a.addClass("active").siblings("[data-language]").removeClass("active"),e=a.attr("data-language"),n=a.parent().nextUntil("nav"),n.find("code."+e).parent().addClass("active"),n.find("code:not(."+e+")").parent().removeClass("active")}),a=function(){var a,e,n,i;for(n=$("article section"),i=[],a=0,e=n.length;e>a;a++)t=n[a],i.push({id:$(t).attr("id"),top:t.offsetTop});return i}(),$("article").scroll(function(e){var n,i,r,l,o,s;for(s=e.target.scrollTop,l=$("aside > ul > li > a").removeClass("active"),o=[],i=n=0,r=a.length;r>n;i=++n)t=a[i],s>=t.top&&o.push(s>=a[i+1].top?void 0:l.filter("[href=#"+t.id+"]").addClass("active"));return o})})}).call(this);