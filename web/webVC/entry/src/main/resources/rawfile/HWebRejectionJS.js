;function commonFunc() {
    // window添加message监听
    var h5Port;
    window.addEventListener('message', function (event) {
        if (event.data === '__init_port__') {
            if (event.ports[0] !== null) {
                h5Port = event.ports[0]; // 1. 保存从应用侧发送过来的端口。
                h5Port.onmessage = function (event) {
                // 2. 接收ets侧发送过来的消息。
                    var msg = 'Got message from ets:';
                    var result = event.data;
                    if (typeof(result) === 'string') {
                        console.info(`received string message from html5, string is: ${result}`);
                        msg = msg + result;
                        let resultJson = JSON.parse(result)
                        let callbackId = resultJson['callbackId']
                        console.log("callbackId == " + resultJson['callbackId'])
                        // let paramsStr = resultJson['params']
                        let pipe = resultJson['pipe'];
                        let params = resultJson['params']
                        hebaoWkjs.msgCallback(callbackId, pipe, params)
                    } else if (typeof(result) === 'object') {
                        if (result instanceof ArrayBuffer) {
                            console.info(`received arraybuffer from html5, length is: ${result.byteLength}`);
                            msg = msg + 'lenght is ' + result.byteLength;
                        } else {
                            console.info('not support');
                        }
                    } else {
                        console.info('not support');
                    }

                }
            }
        }
    })

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
        msgCallback: function (callbackId, pip, params) {
            let hbCallback = _hbCallbacks[callbackId];
            if (typeof hbCallback == 'function') {
                // hblog("已成功回调ID=" + callbackId + ", 传递参数：" + params1);
                hbCallback(params);
            } else {
                // hblog("未找到回调ID=" + callbackId + ", 传递参数：" + params1);
            }
            if (pipe == false) {
                _hbCallbacks[callbackId] = undefined;
            }
        },

        // 通过runJavaScript方式回调JS
        callback: function (params) {
            let callbackId = params['callbackId'];
            let params1 = params['params'];
            let pipe = params['pipe'];
            this.msgCallback(callbackId, pipe, params1)
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
        },

        //打印函数：分别打印到js控制台同时输出到iOS
        // hblog: function (msg) {
        //     var c = _wkmsgHandlers.hblog;
        //     if (c != null) {
        //         console.log(msg);
        //         c.postMessage(msg);
        //     }
        // }

    }

    window.hebaoWkjs = hebaoWkjs;
}

commonFunc();
