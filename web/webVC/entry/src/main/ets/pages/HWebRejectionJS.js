;(function () {

    if (window.hebaoWkjs != null) return;
    //oc调用js的回调
    var _hbCallbacks = {};
    //消息回调id
    var _hbCbId = 1;
    //webkit的交互对象
    var _wkmsgHandlers = window.webkit.messageHandlers;
    //注入的交互对象
    var hebaoWkjs = {
        //所有的方法
        allmethods : [],
        //方法名对应的回调函数
        callbacks : {},
        //JS调用原生方法： name 方法名 param 参数 callback 回调方法
        doCall: function (name, param, callback) {
            var msg = {};
            if (arguments.length == 2 && typeof param == 'function') {
                callback = param;
                param = null;
            }
            if (typeof callback == 'function') {
                this.callbacks[name] = callback;
                var callbackId = 'hb'+(_hbCbId++)+'cb'+ new Date().getTime();
                _hbCallbacks[callbackId] = callback;
                msg['callbackId'] = callbackId;
            }
            if (param) {
                msg['hbwkjsbody'] = param;
            }
            var method = _wkmsgHandlers[name];
            if (method) {
                hblog("JS发出消息：" + name + "，参数：" + JSON.stringify(msg));
                method.postMessage(msg);
            } else {
                hblog("请检查WKWebView-ObjC方法" + name + "的注册是否有误");
            }
        },

        //JS调用原生方法： name 方法名 param 参数 callback 回调方法
        doCallSync: function (name, param) {
            var msg = {};
            if (param) {
                msg['hbwkjsbody'] = param;
            }
            var jsonStr = JSON.stringify(msg);
            hblog("JS发出同步消息：" + name + "，参数：" + jsonStr);
            var string = window.prompt(name,jsonStr);
            return JSON.parse(string);
        },

        //ObjC执行完原生方法后回调JS
        callback: function (name, pipe, args) {
            var hbCallback = _hbCallbacks[name];
            var desc = JSON.stringify(args);
            if (typeof hbCallback == 'function') {
                hblog("已成功回调ID=" + name + ", 传递参数：" + desc);
                hbCallback(args);
            } else {
                hblog("未找到回调ID=" + name + ", 传递参数：" + desc);
            }
            // 执行回调后完清空回调函数
            if (pipe == false) {
                _hbCallbacks[name] = undefined;
            }
        },

        //打印函数：分别打印到js控制台同时输出到iOS
        hblog: function (msg) {
            var c = _wkmsgHandlers.hblog;
            if (c != null) {
                console.log(msg);
                c.postMessage(msg);
            }
        }
    };

    window.hebaoWkjs = hebaoWkjs;

    window.hblog = hebaoWkjs.hblog;

    hblog("和包WKWebview-hebaoWkjs初始化成功...");

    hebaoWkjs.doCall("allmethods",function (e) {
        hebaoWkjs.allmethods = e;
        //var desc = JSON.stringify(hebaoWkjs.allmethods);
        //hblog('hebaoWkjs交互方法如下: hebaoWkjs.allmethods = ' + desc);
    });

    //拓展根据name直接回调
    hebaoWkjs.mdcallback = function (name, args) {
        var hbCallback = this.callbacks[name];
        var desc = JSON.stringify(args);
        if (typeof hbCallback == 'function') {
            hblog("已成功回调name=" + name + ", 传递参数：" + desc);
            hbCallback(args);
        } else {
            hblog("未找到回调name=" + name + ", 传递参数：" + desc);
        }
    };

    /*
    window.onerror = function (msg, url, lineNum, columnNum, error) {
      var string = msg.toLowerCase();
      var substring = "script error";
      if (string.indexOf(substring) > -1){
          hblog('Script Error: See Browser Console for Detail');
      } else {
          var message = [
              'Message: ' + msg,
              'URL: ' + url,
              'Line: ' + lineNum,
              'Column: ' + columnNum,
              'Error object: ' + JSON.stringify(error)
          ].join(' - ');
          hblog(message);
      }
      return false;
    };*/

}());