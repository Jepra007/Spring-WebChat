<!DOCTYPE html>
<html>
<head>
    <title>Spring Simple Web Chat by JePra</title>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.0.3/sockjs.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
   
    <script type="text/javascript">
        var stompClient = null;

        function setConnected(connected) {
            document.getElementById('connect').disabled = connected;
            document.getElementById('disconnect').disabled = !connected;
            document.getElementById('conversationDiv').style.visibility = connected ? 'visible' : 'hidden';
            document.getElementById('response').innerHTML = '';
        }

        function connect() {
            var socket = new SockJS('/ROOT/chat');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function(frame) {
                setConnected(true);
                console.log('Connected: ' + frame);
                stompClient.subscribe('/topic/chatting', function(chatting){
                    console.log(chatting);
                    showChatting(JSON.parse(chatting.body).content);
                });
            });
        }

        function disconnect() {
            if (stompClient != null) {
                stompClient.disconnect();
            }
            setConnected(false);
            console.log("Disconnected");
        }

        function sendChat() {
        	var myname = document.getElementById('myname').value;
            var chat = document.getElementById('chat').value;
            var date = new Date();
            stompClient.send("/app/chat", {}, JSON.stringify({ 'chat': "(" + myname + " - " + date.toLocaleTimeString() + "): "+ chat }));
        }

        function showChatting(message) {
            var response = document.getElementById('response');
            var p = document.createElement('p');
            p.style.wordWrap = 'break-word';
            p.appendChild(document.createTextNode(message));
            response.appendChild(p);
        }
    </script>
</head>
<body onload="disconnect()">
<noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websocket relies on Javascript being enabled. Please enable
    Javascript and reload this page!</h2></noscript>
<div>
    <div>
    	<label>Your Name: </label><input type="text" id="myname" />
        <button id="connect" onclick="connect();">Connect</button>
        <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>
    </div>
    <div></div>
    <div id="conversationDiv">
        <label>Message: </label><input type="text" id="chat" />
        <button id="sendChat" onclick="sendChat();">Send</button>
        <p id="response"></p>
    </div>
</div>
</body>
</html>