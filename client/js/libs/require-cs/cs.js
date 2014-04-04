define(['module', 'require'], function (module, req) {
  'use strict';
  var getXhr, fs,
    progIds = ['Msxml2.XMLHTTP', 'Microsoft.XMLHTTP', 'Msxml2.XMLHTTP.4.0'],
    fetchText = function () {
      throw new Error('Environment unsupported.');
    };

  // Browser action
  getXhr = function () {
    //Would love to dump the ActiveX crap in here. Need IE 6 to die first.
    var xhr, i, progId;
    if (typeof XMLHttpRequest !== "undefined") {
      return new XMLHttpRequest();
    } else {
      for (i = 0; i < 3; i += 1) {
        progId = progIds[i];
        try {
          xhr = new ActiveXObject(progId);
        } catch (e) {}

        if (xhr) {
          progIds = [progId];  // so faster next time
          break;
        }
      }
    }

    if (!xhr) {
      throw new Error("getXhr(): XMLHttpRequest not available");
    }

    return xhr;
  };

  if (typeof window != 'undefined')
    fetchText = function (url, callback, errback) {
      var xhr = getXhr();
      xhr.open('GET', url, requirejs.inlineRequire ? false : true);
      xhr.onreadystatechange = function (evt) {
        var status, err;
        //Do not explicitly handle errors, those should be
        //visible via console output in the browser.
        if (xhr.readyState === 4) {
          status = xhr.status;
          if ((status > 399 && status < 600)) {
            err = new Error(url + ' HTTP status: ' + status);
            err.xhr = xhr;
            if (errback)
              errback(err);
          }
          else
            callback(xhr.responseText);
        }
      };
      xhr.send(null);
    }
  if (typeof process !== "undefined" && process.versions && !!process.versions.node) {
    //Using special require.nodeRequire, something added by r.js.
    fs = require.nodeRequire('fs');
    fetchText = function (path, callback) {
      callback(fs.readFileSync(path, 'utf8'));
    };
  } else if (typeof Packages !== 'undefined') {
    //Why Java, why is this so awkward?
    fetchText = function (path, callback) {
      var stringBuffer, line,
        encoding = "utf-8",
        file = new java.io.File(path),
        lineSeparator = java.lang.System.getProperty("line.separator"),
        input = new java.io.BufferedReader(new java.io.InputStreamReader(new java.io.FileInputStream(file), encoding)),
        content = '';
      try {
        stringBuffer = new java.lang.StringBuffer();
        line = input.readLine();

        // Byte Order Mark (BOM) - The Unicode Standard, version 3.0, page 324
        // http://www.unicode.org/faq/utf_bom.html

        // Note that when we use utf-8, the BOM should appear as "EF BB BF", but it doesn't due to this bug in the JDK:
        // http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4508058
        if (line && line.length() && line.charAt(0) === 0xfeff) {
          // Eat the BOM, since we've already found the encoding on this file,
          // and we plan to concatenating this buffer with others; the BOM should
          // only appear at the top of a file.
          line = line.substring(1);
        }

        stringBuffer.append(line);

        while ((line = input.readLine()) !== null) {
          stringBuffer.append(lineSeparator);
          stringBuffer.append(line);
        }
        //Make sure we return a JavaScript string and not a Java string.
        content = String(stringBuffer.toString()); //String
      } finally {
        input.close();
      }
      callback(content);
    };
  }

  return {
    pluginBuilder: './cs-builder',

    fetchText: fetchText,

    version: '0.4.3',
    
    writeFile: function(pluginName, moduleName, req, write, config) {
      var load = function(module) {}
      load.fromText = function(jsSource) {
        write.asModule(pluginName + '!' + moduleName, req.toUrl(moduleName) + '.js', jsSource);
      }
      this.load(moduleName, req, load, config);
    },

    load: function (name, parentRequire, load, config) {
      var path = parentRequire.toUrl(name + '.coffee');
      
      // check if we're on the same domain or not
      var sameDomain = true,
        domainCheck = /^(\w+:)?\/\/([^\/]+)/.exec(path);
      if (typeof window != 'undefined' && domainCheck) {
        sameDomain = domainCheck[2] === window.location.host;
        if (domainCheck[1])
          sameDomain &= domainCheck[1] === window.location.protocol;
      }
      
      if (sameDomain)
        fetchText(path, function (text) {
          req(['coffee-script'], function(CoffeeScript) {

            //Do CoffeeScript transform.
            try {
              text = CoffeeScript.compile(text, config.CoffeeScript);
            } catch (err) {
              err.message = "In " + path + ", " + err.message;
              throw err;
            }
  
            //IE with conditional comments on cannot handle the
            //sourceURL trick, so skip it if enabled.
            /*@if (@_jscript) @else @*/
            text += "\r\n//@ sourceURL=" + path;
            /*@end@*/
  
            load.fromText(module.id + '!' + name, text);
  
            //Give result to load. Need to wait until the module
            //is fully parse, which will happen after this
            //execution.
            parentRequire([module.id + '!' + name], function (value) {
              load(value);
            });
          }, function (err) {
            if (load.error)
              load.error(err);
          });
        }, function(err) {
          if (load.error)
            load.error(err);
        });
      else
        parentRequire([name + '.coffee'], load);
        
    }
  };
});
