const mongoose = require("mongoose");
const Schema = mongoose.Schema;
 
const userSchema = new Schema({
  fullname: {
    type: String,
    required: true,
  },
 
  email: {
    type: String,
    required: true,
  },
 
  phoneNumber: {
    type: Number,
    required: true,
  },
 
  carModel: {
    type: String,
    required: false,
  },
 
  isAvailable: {
    type: String,
    required: false,
  },
 
  destination: {
    type: String,
    required: false,
  },
 
  password: {
    type: String,
    required: true,
  },
  refreshToken: String
  /*
  verificationCode: {
    type: String,
  },*/
});
module.exports = mongoose.model("User", userSchema);