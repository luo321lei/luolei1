<%@page import="org.springframework.web.context.request.SessionScope"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>聊天室</title>
	<link rel="shortcut icon" href="./static/images/favicon.jpg" />
    <link rel="stylesheet" href="./static/css/beatu.css" media="screen" type="text/css" />
    <link rel="stylesheet" href="./static/css/input.css" media="screen" type="text/css" />
    <link rel="stylesheet" href="./static/css/amazeui.css" media="screen" type="text/css" />
</head>

<body>
	<div>
		<p style="color: white;" >当前在线人数:<input id="num" readonly="readonly"/></p>
	</div>
  <div id="convo" data-from="Sonu Joshi"> 
		<ul class="chat-thread"  id="console">
		</ul>
  </div>
	<!-- <div class="credits">
		<p>
        <input type="text" placeholder="type and press enter to chat" id="chat">
    	</p>
    </div> -->
    <div class="panel"> 
	  <div class="wrap">
	    <input type="text" placeholder="Your message here" id="chat"/>
	    enter
	  </div>
  </div>
  <script src='./static/js/jquery-1.11.0.js'></script>
 
</body>
 <style type="text/css">
        input#chat {
            width: 410px
        }

        #console-container {
            width: 400px;
        }

       /*  #console {
            border: 1px solid #CCCCCC;
            border-right-color: #999999;
            border-bottom-color: #999999;
            height: 170px;
            overflow-y: scroll;
            padding: 5px;
            width: 100%;
        } */

        #console p {
            padding: 0;
            margin: 0;
        }
    </style>
    <script type="text/javascript">
     window.setInterval("showNum()",1000); 
    function getUrlParameter(paramKey) {
        var sURLVariables, i, sParameterName, sPageURL = window.location.search.substring(1);
        if (sPageURL) {
            sURLVariables = sPageURL.split("&");
            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split("=");
                if (sParameterName[0] === paramKey) return sParameterName[1]
            }
        }
    }
   //alert(decodeURI(getUrlParameter('username')));
        var Chat = {};

        Chat.socket = null;

        Chat.connect = (function(host) {
            if ('WebSocket' in window) {
                Chat.socket = new WebSocket(host);
            } else if ('MozWebSocket' in window) {
                Chat.socket = new MozWebSocket(host);
            } else {
                //Console.log('Error: WebSocket is not supported by this browser.');
                Console.log('Error: 你的浏览器不支持WebSocket功能.');
                return;
            }

            Chat.socket.onopen = function () {
               //Console.log('Info: WebSocket connection opened.');
                Console.log('Info: WebSocket连接打开.');
                document.getElementById('chat').onkeydown = function(event) {
                    if (event.keyCode == 13) {
                        Chat.sendMessage();
                    }
                };
            };

            Chat.socket.onclose = function () {
                document.getElementById('chat').onkeydown = null;
                Console.log('Info: WebSocket连接关闭,请尝试重新登录.');
            };

            Chat.socket.onmessage = function (message) {
                Console.log(message.data);
            };
        });

        Chat.initialize = function() {
            if (window.location.protocol == 'http:') {
               // Chat.connect('ws://localhost:8080/ilikeyou/websocket/chat');
                Chat.connect('ws://' + window.location.host + '/ilikeyou/websocket/chat/'+decodeURI(getUrlParameter('username')));
            } else {
                Chat.connect('wss://' + window.location.host + '/ilikeyou/websocket/chat'+decodeURI(getUrlParameter('username')));
            	//Chat.connect('wss://localhost:8080/ilikeyou/websocket/chat');
            }
        };

        Chat.sendMessage = (function() {
            var message = document.getElementById('chat').value;
            if (message != '') {
                Chat.socket.send(message);
                document.getElementById('chat').value = '';
            }
        });

        var Console = {};

        Console.log = (function(message) {
            var console = document.getElementById('console');
            //var p = document.createElement('p');
            var p = document.createElement('li');
            p.style.wordWrap = 'break-word';
            p.innerHTML = message;
            console.appendChild(p);
            while (console.childNodes.length > 25) {
                console.removeChild(console.firstChild);
            }
            console.scrollTop = console.scrollHeight;
        });

        Chat.initialize();
	function showNum(){
		var size=${num};
		document.getElementById("num").setAttribute("value", size);
	}
    </script>
</html>