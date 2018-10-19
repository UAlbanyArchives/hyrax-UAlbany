!function(){"use strict";function l(t,e){return w.each(e,function(e){t=e.constructor===RegExp?t.replace(e,""):t.replace(e[0],e[1])}),t}function m(t){var n,e;return e=[/^[IVXLMCD]{1,2}\.[ \u00a0]/,/^[ivxlmcd]{1,2}\.[ \u00a0]/,/^[a-z]{1,2}[\.\)][ \u00a0]/,/^[A-Z]{1,2}[\.\)][ \u00a0]/,/^[0-9]+\.[ \u00a0]/,/^[\u3007\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d]+\.[ \u00a0]/,/^[\u58f1\u5f10\u53c2\u56db\u4f0d\u516d\u4e03\u516b\u4e5d\u62fe]+\.[ \u00a0]/],t=t.replace(/^[\u00a0 ]+/,""),w.each(e,function(e){if(e.test(t))return!(n=!0)}),n}function u(e){function n(e){var t="";if(3===e.type)return e.value;if(e=e.firstChild)for(;t+=n(e),e=e.next;);return t}function i(e,t){if(3===e.type&&t.test(e.value))return e.value=e.value.replace(t,""),!1;if(e=e.firstChild)do{if(!i(e,t))return!1}while(e=e.next);return!0}function t(t,n,r){var a=t._listLevel||l;a!==l&&(a<l?o&&(o=o.parent.parent):(s=o,o=null)),o&&o.name===n?o.append(t):(s=s||o,o=new A(n,1),1<r&&o.attr("start",""+r),t.wrap(o)),t.name="li",l<a&&s&&s.lastChild.append(o),l=a,function e(t){if(t._listIgnore)t.remove();else if(t=t.firstChild)for(;e(t),t=t.next;);}(t),i(t,/^\u00a0+/),i(t,/^\s*([\u2022\u00b7\u00a7\u25CF]|\w+\.)/),i(t,/^\u00a0+/)}for(var o,s,l=1,r=[],a=e.firstChild;null!=a;)if(r.push(a),null!==(a=a.walk()))for(;void 0!==a&&a.parent!==e;)a=a.walk();for(var u=0;u<r.length;u++)if("p"===(e=r[u]).name&&e.firstChild){var c=n(e);if(/^[\s\u00a0]*[\u2022\u00b7\u00a7\u25CF]\s*/.test(c)){t(e,"ul");continue}if(m(c)){var f=/([0-9]+)\./.exec(c),d=1;f&&(d=parseInt(f[1],10)),t(e,"ol",d);continue}if(e._listLevel){t(e,"ul",1);continue}o=null}else s=o,o=null}function c(n,r,a,i){var o,s={},e=n.dom.parseStyle(i);return w.each(e,function(e,t){switch(t){case"mso-list":(o=/\w+ \w+([0-9]+)/i.exec(i))&&(a._listLevel=parseInt(o[1],10)),/Ignore/i.test(e)&&a.firstChild&&(a._listIgnore=!0,a.firstChild._listIgnore=!0);break;case"horiz-align":t="text-align";break;case"vert-align":t="vertical-align";break;case"font-color":case"mso-foreground":t="color";break;case"mso-background":case"mso-highlight":t="background";break;case"font-weight":case"font-style":return void("normal"!==e&&(s[t]=e));case"mso-element":if(/^(comment|comment-list)$/i.test(e))return void a.remove()}0!==t.indexOf("mso-comment")?0!==t.indexOf("mso-")&&("all"===h.getRetainStyleProps(n)||r&&r[t])&&(s[t]=e):a.remove()}),/(bold)/i.test(s["font-weight"])&&(delete s["font-weight"],a.wrap(new A("b",1))),/(italic)/i.test(s["font-style"])&&(delete s["font-style"],a.wrap(new A("i",1))),(s=n.dom.serializeStyle(s,a.name))||null}function r(t,n){t.on("PastePreProcess",function(e){e.content=n(t,e.content,e.internal,e.wordContent)})}function a(e,t){if(!$.isWordContent(t))return t;var n=[];w.each(e.schema.getBlockElements(),function(e,t){n.push(t)});var r=new RegExp("(?:<br>&nbsp;[\\s\\r\\n]+|<br>)*(<\\/?("+n.join("|")+")[^>]*>)(?:<br>&nbsp;[\\s\\r\\n]+|<br>)*","g");return t=L.filter(t,[[r,"$1"]]),L.filter(t,[[/<br><br>/g,"<BR><BR>"],[/<br>/g," "],[/<BR><BR>/g,"<br>"]])}function i(e,t,n,r){if(r||n)return t;var u,a=h.getWebkitStyles(e);if(!1===h.shouldRemoveWebKitStyles(e)||"all"===a)return t;if(a&&(u=a.split(/[, ]/)),u){var c=e.dom,f=e.selection.getNode();t=t.replace(/(<[^>]+) style="([^"]*)"([^>]*>)/gi,function(e,t,n,r){var a=c.parseStyle(c.decode(n)),i={};if("none"===u)return t+r;for(var o=0;o<u.length;o++){var s=a[u[o]],l=c.getStyle(f,u[o],!0);/color/.test(u[o])&&(s=c.toHex(s),l=c.toHex(l)),l!==s&&(i[u[o]]=s)}return(i=c.serializeStyle(i,"span"))?t+' style="'+i+'"'+r:t+r})}else t=t.replace(/(<[^>]+) style="([^"]*)"([^>]*>)/gi,"$1$3");return t.replace(/(<[^>]+) data-mce-style="([^"]+)"([^>]*>)/gi,function(e,t,n,r){return t+' style="'+n+'"'+r})}function o(n,e){n.$("a",e).find("font,u").each(function(e,t){n.dom.remove(t,!0)})}var f=function(e){var t=e,n=function(){return t};return{get:n,set:function(e){t=e},clone:function(){return f(n())}}},t=tinymce.util.Tools.resolve("tinymce.PluginManager"),s=function(e){return!(!/(^|[ ,])powerpaste([, ]|$)/.test(e.settings.plugins)||!t.get("powerpaste")||("undefined"!=typeof window.console&&window.console.log&&window.console.log("PowerPaste is incompatible with Paste plugin! Remove 'paste' from the 'plugins' option."),0))},d=function(e,t){return{clipboard:e,quirks:t}},p=function(e,t,n,r){return e.fire("PastePreProcess",{content:t,internal:n,wordContent:r})},g=function(e,t,n,r){return e.fire("PastePostProcess",{node:t,internal:n,wordContent:r})},v=function(e,t){return e.fire("PastePlainTextToggle",{state:t})},n=function(e,t){return e.fire("paste",{ieFake:t})},h={shouldPlainTextInform:function(e){return e.getParam("paste_plaintext_inform",!0)},shouldBlockDrop:function(e){return e.getParam("paste_block_drop",!1)},shouldPasteDataImages:function(e){return e.getParam("paste_data_images",!1)},shouldFilterDrop:function(e){return e.getParam("paste_filter_drop",!0)},getPreProcess:function(e){return e.getParam("paste_preprocess")},getPostProcess:function(e){return e.getParam("paste_postprocess")},getWebkitStyles:function(e){return e.getParam("paste_webkit_styles")},shouldRemoveWebKitStyles:function(e){return e.getParam("paste_remove_styles_if_webkit",!0)},shouldMergeFormats:function(e){return e.getParam("paste_merge_formats",!0)},isSmartPasteEnabled:function(e){return e.getParam("smart_paste",!0)},isPasteAsTextEnabled:function(e){return e.getParam("paste_as_text",!1)},getRetainStyleProps:function(e){return e.getParam("paste_retain_style_properties")},getWordValidElements:function(e){return e.getParam("paste_word_valid_elements","-strong/b,-em/i,-u,-span,-p,-ol,-ul,-li,-h1,-h2,-h3,-h4,-h5,-h6,-p/div,-a[href|name],sub,sup,strike,br,del,table[width],tr,td[colspan|rowspan|width],th[colspan|rowspan|width],thead,tfoot,tbody")},shouldConvertWordFakeLists:function(e){return e.getParam("paste_convert_word_fake_lists",!0)},shouldUseDefaultFilters:function(e){return e.getParam("paste_enable_default_filters",!0)}},b=function(e,t,n){var r,a,i;"text"===t.pasteFormat.get()?(t.pasteFormat.set("html"),v(e,!1)):(t.pasteFormat.set("text"),v(e,!0),i=e,!1===n.get()&&h.shouldPlainTextInform(i)&&(a="Paste is now in plain text mode. Contents will now be pasted as plain text until you toggle this option off.",(r=e).notificationManager.open({text:r.translate(a),type:"info"}),n.set(!0))),e.focus()},y=function(e,n,t){e.addCommand("mceTogglePlainTextPaste",function(){b(e,n,t)}),e.addCommand("mceInsertClipboardContent",function(e,t){t.content&&n.pasteHtml(t.content,t.internal),t.text&&n.pasteText(t.text)})},x=tinymce.util.Tools.resolve("tinymce.Env"),P=tinymce.util.Tools.resolve("tinymce.util.Delay"),w=tinymce.util.Tools.resolve("tinymce.util.Tools"),_=tinymce.util.Tools.resolve("tinymce.util.VK"),e="x-tinymce/html",D="<!-- "+e+" -->",T=function(e){return D+e},C=function(e){return e.replace(D,"")},k=function(e){return-1!==e.indexOf(D)},R=function(){return e},F=tinymce.util.Tools.resolve("tinymce.html.Entities"),E=function(e){return e.replace(/\r?\n/g,"<br>")},S=function(e,i,t){var n=e.split(/\n\n/),r=function(e,t){var n,r=[],a="<"+i;if("object"==typeof t){for(n in t)t.hasOwnProperty(n)&&r.push(n+'="'+F.encodeAllRaw(t[n])+'"');r.length&&(a+=" "+r.join(" "))}return a+">"}(0,t),a="</"+i+">",o=w.map(n,function(e){return e.split(/\n/).join("<br />")});return 1===o.length?o[0]:w.map(o,function(e){return r+e+a}).join("")},I=function(e){return!/<(?:\/?(?!(?:div|p|br|span)>)\w+|(?:(?!(?:span style="white-space:\s?pre;?">)|br\s?\/>))\w+\s[^>]+)>/i.test(e)},M=function(e,t,n){return t?S(e,t,n):E(e)},O=tinymce.util.Tools.resolve("tinymce.html.DomParser"),A=tinymce.util.Tools.resolve("tinymce.html.Node"),H=tinymce.util.Tools.resolve("tinymce.html.Schema"),B=tinymce.util.Tools.resolve("tinymce.html.Serializer"),L={filter:l,innerText:function(t){var n=H(),r=O({},n),a="",i=n.getShortEndedElements(),o=w.makeMap("script noscript style textarea video audio iframe object"," "),s=n.getBlockElements();return t=l(t,[/<!\[[^\]]+\]>/g]),function e(t){var n=t.name,r=t;if("br"!==n)if(i[n]&&(a+=" "),o[n])a+=" ";else{if(3===t.type&&(a+=t.value),!t.shortEnded&&(t=t.firstChild))for(;e(t),t=t.next;);s[n]&&r.next&&(a+="\n","p"===n&&(a+="\n"))}else a+="\n"}(r.parse(t)),a},trimHtml:function(e){return l(e,[/^[\s\S]*<body[^>]*>\s*|\s*<\/body[^>]*>[\s\S]*$/gi,/<!--StartFragment-->|<!--EndFragment-->/g,[/( ?)<span class="Apple-converted-space">\u00a0<\/span>( ?)/g,function(e,t,n){return t||n?"\xa0":" "}],/<br class="Apple-interchange-newline">/g,/<br>$/i])},createIdGenerator:function(e){var t=0;return function(){return e+t++}},isMsEdge:function(){return-1!==navigator.userAgent.indexOf(" Edge/")}},$={preProcess:function(e,t){return h.shouldUseDefaultFilters(e)?function(r,e){var t,a;(t=h.getRetainStyleProps(r))&&(a=w.makeMap(t.split(/[, ]/))),e=L.filter(e,[/<br class="?Apple-interchange-newline"?>/gi,/<b[^>]+id="?docs-internal-[^>]*>/gi,/<!--[\s\S]+?-->/gi,/<(!|script[^>]*>.*?<\/script(?=[>\s])|\/?(\?xml(:\w+)?|img|meta|link|style|\w:\w+)(?=[\s\/>]))[^>]*>/gi,[/<(\/?)s>/gi,"<$1strike>"],[/&nbsp;/gi,"\xa0"],[/<span\s+style\s*=\s*"\s*mso-spacerun\s*:\s*yes\s*;?\s*"\s*>([\s\u00a0]*)<\/span>/gi,function(e,t){return 0<t.length?t.replace(/./," ").slice(Math.floor(t.length/2)).split("").join("\xa0"):""}]]);var n=h.getWordValidElements(r),i=H({valid_elements:n,valid_children:"-li[p]"});w.each(i.elements,function(e){e.attributes["class"]||(e.attributes["class"]={},e.attributesOrder.push("class")),e.attributes.style||(e.attributes.style={},e.attributesOrder.push("style"))});var o=O({},i);o.addAttributeFilter("style",function(e){for(var t,n=e.length;n--;)(t=e[n]).attr("style",c(r,a,t,t.attr("style"))),"span"===t.name&&t.parent&&!t.attributes.length&&t.unwrap()}),o.addAttributeFilter("class",function(e){for(var t,n,r=e.length;r--;)n=(t=e[r]).attr("class"),/^(MsoCommentReference|MsoCommentText|msoDel)$/i.test(n)&&t.remove(),t.attr("class",null)}),o.addNodeFilter("del",function(e){for(var t=e.length;t--;)e[t].remove()}),o.addNodeFilter("a",function(e){for(var t,n,r,a=e.length;a--;)if(n=(t=e[a]).attr("href"),r=t.attr("name"),n&&-1!==n.indexOf("#_msocom_"))t.remove();else if(n&&0===n.indexOf("file://")&&(n=n.split("#")[1])&&(n="#"+n),n||r){if(r&&!/^_?(?:toc|edn|ftn)/i.test(r)){t.unwrap();continue}t.attr({href:n,name:r})}else t.unwrap()});var s=o.parse(e);return h.shouldConvertWordFakeLists(r)&&u(s),B({validate:r.settings.validate},i).serialize(s)}(e,t):t},isWordContent:function(e){return/<font face="Times New Roman"|class="?Mso|style="[^"]*\bmso-|style='[^'']*\bmso-|w:WordDocument/i.test(e)||/class="OutlineElement/.test(e)||/id="?docs\-internal\-guid\-/.test(e)}},j=function(e,t){return{content:e,cancelled:t}},W=function(e,t,n,r){var a,i,o,s,l,u,c=p(e,t,n,r);return e.hasEventListeners("PastePostProcess")&&!c.isDefaultPrevented()?(a=e,i=c.content,o=n,s=r,l=a.dom.create("div",{style:"display:none"},i),u=g(a,l,o,s),j(u.node.innerHTML,u.isDefaultPrevented())):j(c.content,c.isDefaultPrevented())},N=function(e,t,n){var r=$.isWordContent(t),a=r?$.preProcess(e,t):t;return W(e,a,n,r)},V=function(e,t){return e.insertContent(t,{merge:h.shouldMergeFormats(e),paste:!0}),!0},z=function(e){return/^https?:\/\/[\w\?\-\/+=.&%@~#]+$/i.test(e)},K=function(e){return z(e)&&/.(gif|jpe?g|png)$/.test(e)},U=function(e,t,n){return!(!1!==e.selection.isCollapsed()||!z(t)||(a=t,i=n,(r=e).undoManager.extra(function(){i(r,a)},function(){r.execCommand("mceInsertLink",!1,a)}),0));var r,a,i},G=function(e,t,n){return!!K(t)&&(a=t,i=n,(r=e).undoManager.extra(function(){i(r,a)},function(){r.insertContent('<img src="'+a+'">')}),!0);var r,a,i},X=function(e,t){var n,r;!1===h.isSmartPasteEnabled(e)?V(e,t):(n=e,r=t,w.each([U,G,V],function(e){return!0!==e(n,r,V)}))},q=function(e,t,n){var r=n||k(t),a=N(e,C(t),r);!1===a.cancelled&&X(e,a.content)},Y=function(e,t){t=e.dom.encode(t).replace(/\r\n/g,"\n"),t=M(t,e.settings.forced_root_block,e.settings.forced_root_block_attrs),q(e,t,!1)},Z=function(e){var t={};if(e){if(e.getData){var n=e.getData("Text");n&&0<n.length&&-1===n.indexOf("data:text/mce-internal,")&&(t["text/plain"]=n)}if(e.types)for(var r=0;r<e.types.length;r++){var a=e.types[r];try{t[a]=e.getData(a)}catch(D){t[a]=""}}}return t},J=function(e,t){return t in e&&0<e[t].length},Q=function(e){return J(e,"text/html")||J(e,"text/plain")},ee=L.createIdGenerator("mceclip"),te=function(e,t,n,r){t&&(e.selection.setRng(t),t=null);var a,i,o,s,l,u,c=n.result,f=-1!==(i=(a=c).indexOf(","))?a.substr(i+1):null,d=ee(),m=e.settings.images_reuse_filename&&r.name?(o=e,(s=r.name.match(/([\s\S]+?)\.(?:jpeg|jpg|png|gif)$/i))?o.dom.encode(s[1]):null):d,p=new Image;if(p.src=c,u=p,!(l=e.settings).images_dataimg_filter||l.images_dataimg_filter(u)){var g,v=e.editorUpload.blobCache,h=void 0;(g=v.findFirst(function(e){return e.base64()===f}))?h=g:(h=v.create(d,r,f,m),v.add(h)),q(e,'<img src="'+h.blobUri()+'">',!1)}else q(e,'<img src="'+c+'">',!1)},ne=function(o,s,l){function e(e){var t,n,r,a=!1;if(e)for(t=0;t<e.length;t++)if(n=e[t],/^image\/(jpeg|png|gif|bmp)$/.test(n.type)){var i=n.getAsFile?n.getAsFile():n;(r=new window.FileReader).onload=te.bind(null,o,l,r,i),r.readAsDataURL(i),s.preventDefault(),a=!0}return a}var t="paste"===s.type?s.clipboardData:s.dataTransfer;if(o.settings.paste_data_images&&t)return e(t.items)||e(t.files)},re=function(e){return _.metaKeyPressed(e)&&86===e.keyCode||e.shiftKey&&45===e.keyCode},ae=function(c,f,d){function m(e,t,n,r){var a,i;J(e,"text/html")?a=e["text/html"]:(a=f.getHtml(),r=r||k(a),f.isDefaultContent(a)&&(n=!0)),a=L.trimHtml(a),f.remove(),i=!1===r&&I(a),a.length&&!i||(n=!0),n&&(a=J(e,"text/plain")&&i?e["text/plain"]:L.innerText(a)),f.isDefaultContent(a)?t||c.windowManager.alert("Please use Ctrl+V/Cmd+V keyboard shortcuts to paste contents."):n?Y(c,a):q(c,a,r)}var p,g=0;c.on("keydown",function(e){function t(e){re(e)&&!e.isDefaultPrevented()&&f.remove()}if(re(e)&&!e.isDefaultPrevented()){if((p=e.shiftKey&&86===e.keyCode)&&x.webkit&&-1!==navigator.userAgent.indexOf("Version/"))return;if(e.stopImmediatePropagation(),g=(new Date).getTime(),x.ie&&p)return e.preventDefault(),void n(c,!0);f.remove(),f.create(),c.once("keyup",t),c.once("paste",function(){c.off("keyup",t)})}}),c.on("paste",function(e){var t,n,r,a=(new Date).getTime(),i=(t=c,n=Z(e.clipboardData||t.getDoc().dataTransfer),L.isMsEdge()?w.extend(n,{"text/html":""}):n),o=(new Date).getTime()-a,s=(new Date).getTime()-g-o<1e3,l="text"===d.get()||p,u=J(i,R());p=!1,e.isDefaultPrevented()||(r=e.clipboardData,-1!==navigator.userAgent.indexOf("Android")&&r&&r.items&&0===r.items.length)?f.remove():Q(i)||!ne(c,e,f.getLastRng()||c.selection.getRng())?(s||e.preventDefault(),!x.ie||s&&!e.ieFake||J(i,"text/html")||(f.create(),c.dom.bind(f.getEl(),"paste",function(e){e.stopPropagation()}),c.getDoc().execCommand("Paste",!1,null),i["text/html"]=f.getHtml()),J(i,"text/html")?(e.preventDefault(),u||(u=k(i["text/html"])),m(i,s,l,u)):P.setEditorTimeout(c,function(){m(i,s,l,u)},0)):f.remove()})},ie=function(e){return x.ie&&e.inline?document.body:e.getBody()},oe=function(e,t){var n;ie(n=e)!==n.getBody()&&e.dom.bind(t,"paste keyup",function(){setTimeout(function(){e.fire("paste")},0)})},se=function(e){return e.dom.get("mcepastebin")},le=function(e,t){return t===e},ue=function(o){var s=f(null),l="%MCEPASTEBIN%";return{create:function(){return t=s,n=l,a=(e=o).dom,i=e.getBody(),t.set(e.selection.getRng()),r=e.dom.add(ie(e),"div",{id:"mcepastebin","class":"mce-pastebin",contentEditable:!0,"data-mce-bogus":"all",style:"position: fixed; top: 50%; width: 10px; height: 10px; overflow: hidden; opacity: 0"},n),(x.ie||x.gecko)&&a.setStyle(r,"left","rtl"===a.getStyle(i,"direction",!0)?65535:-65535),a.bind(r,"beforedeactivate focusin focusout",function(e){e.stopPropagation()}),oe(e,r),r.focus(),void e.selection.select(r,!0);var e,t,n,r,a,i},remove:function(){return function(e,t){if(se(e)){for(var n=void 0,r=t.get();n=e.dom.get("mcepastebin");)e.dom.remove(n),e.dom.unbind(n);r&&e.selection.setRng(r)}t.set(null)}(o,s)},getEl:function(){return se(o)},getHtml:function(){return function(n){var t,e,r,a,i,o=function(e,t){e.appendChild(t),n.dom.remove(t,!0)};for(e=w.grep(ie(n).childNodes,function(e){return"mcepastebin"===e.id}),t=e.shift(),w.each(e,function(e){o(t,e)}),r=(a=n.dom.select("div[id=mcepastebin]",t)).length-1;0<=r;r--)i=n.dom.create("div"),t.insertBefore(i,a[r]),o(i,a[r]);return t?t.innerHTML:""}(o)},getLastRng:function(){return s.get()},isDefault:function(){return e=l,(t=n=se(o))&&"mcepastebin"===t.id&&le(e,n.innerHTML);var e,t,n},isDefaultContent:function(e){return le(l,e)}}},ce=function(n,e){var t=ue(n);return n.on("preInit",function(){return ae(o=n,t,e),void o.parser.addNodeFilter("img",function(e,t,n){var r,a=function(e){e.attr("data-mce-object")||s===x.transparentSrc||e.remove()};if(!o.settings.paste_data_images&&(r=n).data&&!0===r.data.paste)for(var i=e.length;i--;)(s=e[i].attributes.map.src)&&(0===s.indexOf("webkit-fake-url")?a(e[i]):o.settings.allow_html_data_urls||0!==s.indexOf("data:")||a(e[i]))});var o,s}),{pasteFormat:e,pasteHtml:function(e,t){return q(n,e,t)},pasteText:function(e){return Y(n,e)},pasteImageData:function(e,t){return ne(n,e,t)},getDataTransferItems:Z,hasHtmlOrText:Q,hasContentType:J}},fe=function(){},de=function(e,t,n){if(r=e,!1!==x.iOS||r===undefined||"function"!=typeof r.setData||!0===L.isMsEdge())return!1;try{return e.clearData(),e.setData("text/html",t),e.setData("text/plain",n),e.setData(R(),t),!0}catch(_){return!1}var r},me=function(e,t,n,r){de(e.clipboardData,t.html,t.text)?(e.preventDefault(),r()):n(t.html,r)},pe=function(s){return function(e,t){var n=T(e),r=s.dom.create("div",{contenteditable:"false","data-mce-bogus":"all"}),a=s.dom.create("div",{contenteditable:"true"},n);s.dom.setStyles(r,{position:"fixed",top:"0",left:"-3000px",width:"1000px",overflow:"hidden"}),r.appendChild(a),s.dom.add(s.getBody(),r);var i=s.selection.getRng();a.focus();var o=s.dom.createRng();o.selectNodeContents(a),s.selection.setRng(o),setTimeout(function(){s.selection.setRng(i),r.parentNode.removeChild(r),t()},0)}},ge=function(e){return{html:e.selection.getContent({contextual:!0}),text:e.selection.getContent({format:"text"})}},ve=function(e){var t,n;e.on("cut",(t=e,function(e){!1===t.selection.isCollapsed()&&me(e,ge(t),pe(t),function(){setTimeout(function(){t.execCommand("Delete")},0)})})),e.on("copy",(n=e,function(e){!1===n.selection.isCollapsed()&&me(e,ge(n),pe(n),fe)}))},he=tinymce.util.Tools.resolve("tinymce.dom.RangeUtils"),be=function(e,t){return he.getCaretRangeFromPoint(t.clientX,t.clientY,e.getDoc())},ye=function(e,t){e.focus(),e.selection.setRng(t)},xe=function(o,s,l){h.shouldBlockDrop(o)&&o.on("dragend dragover draggesture dragdrop drop drag",function(e){e.preventDefault(),e.stopPropagation()}),h.shouldPasteDataImages(o)||o.on("drop",function(e){var t=e.dataTransfer;t&&t.files&&0<t.files.length&&e.preventDefault()}),o.on("drop",function(e){var t,n;if(n=be(o,e),!e.isDefaultPrevented()&&!l.get()){t=s.getDataTransferItems(e.dataTransfer);var r,a=s.hasContentType(t,R());if((s.hasHtmlOrText(t)&&(!(r=t["text/plain"])||0!==r.indexOf("file://"))||!s.pasteImageData(e,n))&&n&&h.shouldFilterDrop(o)){var i=t["mce-internal"]||t["text/html"]||t["text/plain"];i&&(e.preventDefault(),P.setEditorTimeout(o,function(){o.undoManager.transact(function(){t["mce-internal"]&&o.execCommand("Delete"),ye(o,n),i=L.trimHtml(i),t["text/html"]?s.pasteHtml(i,a):s.pasteText(i)})}))}}}),o.on("dragstart",function(){l.set(!0)}),o.on("dragover dragend",function(e){h.shouldPasteDataImages(o)&&!1===l.get()&&(e.preventDefault(),ye(o,be(o,e))),"dragend"===e.type&&l.set(!1)})},Pe=function(e){var t=e.plugins.paste,n=h.getPreProcess(e);n&&e.on("PastePreProcess",function(e){n.call(t,t,e)});var r=h.getPostProcess(e);r&&e.on("PastePostProcess",function(e){r.call(t,t,e)})},we=function(e){var t,n;x.webkit&&r(e,i),x.ie&&(r(e,a),n=o,(t=e).on("PastePostProcess",function(e){n(t,e.node)}))},_e=function(e){return function(){return e}},De=(_e(!1),_e(!0),function(i){for(var e=[],t=1;t<arguments.length;t++)e[t-1]=arguments[t];for(var o=new Array(arguments.length-1),n=1;n<arguments.length;n++)o[n-1]=arguments[n];return function(){for(var e=[],t=0;t<arguments.length;t++)e[t]=arguments[t];for(var n=new Array(arguments.length),r=0;r<n.length;r++)n[r]=arguments[r];var a=o.concat(n);return i.apply(null,a)}}),Te=function(e,t,n){var r=n.control;r.active("text"===t.pasteFormat.get()),e.on("PastePlainTextToggle",function(e){r.active(e.state)})},Ce=function(e,t){var n=De(Te,e,t);e.addButton("pastetext",{active:!1,icon:"pastetext",tooltip:"Paste as text",cmd:"mceTogglePlainTextPaste",onPostRender:n}),e.addMenuItem("pastetext",{text:"Paste as text",selectable:!0,active:t.pasteFormat,cmd:"mceTogglePlainTextPaste",onPostRender:n})};t.add("paste",function(e){if(!1===s(e)){var t=f(!1),n=f(!1),r=f(h.isPasteAsTextEnabled(e)?"text":"html"),a=ce(e,r),i=we(e);return Ce(e,a),y(e,a,t),Pe(e),ve(e),xe(e,a,n),d(a,i)}})}();