
// console.log('working22');
const express = require('express');
const mongoose = require("mongoose");
const Message = require("./entities/message")

const app = express();



const PORT = process.env.PORT || 4000


mongoose.connect('mongodb+srv://maryemtayeb:OdmDnK0czdgksPQB@cluster0.w0lp418.mongodb.net/test').then(()=>console.log("connected to database"));
const server = app.listen(PORT,()=>{
        console.log('Server is Stated on',PORT);
});

const io = require('socket.io')(server);
 
const connectedUser = new Set();

io.on('connection', (socket) => {
    console.log('Client connected:', socket.id);
    io.emit('connected-user', connectedUser.size)
    connectedUser.add(socket.id)
    io.emit('connected-user', connectedUser.size)


    socket.on('disconnect', () => {
      console.log('Client disconnected:', socket.id);
      connectedUser.delete(socket.id)
      io.emit('connected-user', connectedUser.size)

    });
  
    socket.on('message', async (data) => {
      const {message, sentByMe} = data;
      
      const newMessage = await Message.create({
        message,
        sentByMe
      })
      socket.broadcast.emit('message-recieve',data)
    });
  });