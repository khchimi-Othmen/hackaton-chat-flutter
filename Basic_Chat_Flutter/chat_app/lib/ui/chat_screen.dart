import 'dart:io';

import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/model/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Color purple = Color(0xFF6c5ce7);
  Color black = Color(0xFF191919);
  TextEditingController msgInputController = TextEditingController();
  late IO.Socket socket;


ChatController chatController = ChatController();

@override
void initState() {
  
// Example of initializing socket connection
socket = IO.io(
  'http://localhost:4000',
  IO.OptionBuilder()
    .setTransports(['websocket']) // for Flutter or Dart VM
    .disableAutoConnect()  // disable auto-connection
    .build());

socket.connect();

// Print connection status
  socket.onConnect((_) {
    print('Connected to server');
    setUpSocketListener(); // Call the listener function here
  });

socket.onConnectError((error) {
  print('Connection error: $error');
});
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                ()=>Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                   "Connected User ${chatController.connectedUser}",
                  style:TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                   ),
                ),
                ),
            ),
            ),
            Expanded(
              flex: 9,
              child: Obx(
                ()=> ListView.builder(
                    itemCount: chatController.chatMessages.length,
                    itemBuilder: (context, index) {
                      var currentItem = chatController.chatMessages[index];
                      return MessageItem(
                        sentByMe: currentItem.sentByMe == socket.id,
                        message: currentItem.message,
                      );
                    }),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                // color: Colors.red, // Use Colors.red instead of Color.red
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: purple,
                  controller: msgInputController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: purple,
                      ),
                      child: IconButton(
                        onPressed: () {
                          sendMessage(msgInputController.text);
                          msgInputController.text = "";
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  ),
                ),
              ), // Removed the extra comma here
            ),
          ],
        ),
      ),
    );
  }


void sendMessage(String text) {
  var messageJson ={
    "message": text,
    "sentByMe": socket.id
  };
  socket.emit('message', messageJson);
    chatController.chatMessages.add(Message.fromJson(messageJson));
}

void setUpSocketListener (){
  socket.on('message-recieve',(data) {
    print(data);
    chatController.chatMessages.add(Message.fromJson(data));
  });
    socket.on('connected-user',(data) {
    print(data);
    chatController.connectedUser.value = data;
  }); 
}
}





class MessageItem extends StatelessWidget {
  const  MessageItem({Key? key, required this.sentByMe, required this.message}) : super(key: key);
  final bool sentByMe;
  final String message;
  @override
  Widget build(BuildContext context) {
    Color purple = Color(0xFF6c5ce7);
    Color black = Color(0xFF191919);
    Color white = Colors.white;

    return Align(
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            margin: EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: sentByMe ? purple : white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  message,
                    style: TextStyle(
                      color: sentByMe ? white : purple,
                      fontSize: 18,
                    )),
                SizedBox(width: 5),
                Text(
                  "1:10 Am",
                  style: TextStyle(
                    color: (sentByMe ? white : purple).withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            )));
  }
}

