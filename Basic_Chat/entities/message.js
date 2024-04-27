const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const messageSchema = new Schema({
  message: {
    type: String,
    required: true
  },
  sentByMe: {
    type: String,
    required: true
  }
});

// No need to define a constructor in Mongoose schemas

// Static method for creating a Message from JSON data
messageSchema.statics.fromJson = function(json) {
  return new this({
    message: json["message"] || "", // Use || operator for default value
    sentByMe: json["sentByMe"] || ""  // Default to false
  });
};

module.exports = mongoose.model('Message', messageSchema);
