;function commonFunc() {
    var _hbCallbacks = {}; 
    //消息回调id
    var _hbCbId = 1;
    if (window.hebaoWkjs != null) return;
    var hebaoWkjs = {
        //所有的方法
        allmethods : [],
        //方法名对应的回调函数
        callbacks : {},
        //ObjC执行完原生方法后回调JS
        //通过消息发送的方式回调JS
        msgCallback: function (callbackId, params) {
            let hbCallback = _hbCallbacks[callbackId];
            if (typeof hbCallback == 'function') {
                return hbCallback(params);
            }
        },

        // 通过runJavaScript方式回调JS
        callback: function (params) {
            let callbackId = params['callbackId'];
            let hbCallback = _hbCallbacks[callbackId];
            if (typeof hbCallback == 'function') {
                let params1 = params['params'];
                return hbCallback(params1);
            }
        },

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

            let params = {params: param};
            msg['body'] = params;
            // 使用json字符串做应用侧和前端侧数据传递
            let msgJsonStr = JSON.stringify(msg);
            let str = testObjNameH.onMessage(name, msgJsonStr);
        }

    }

    window.hebaoWkjs = hebaoWkjs;
}

commonFunc();
