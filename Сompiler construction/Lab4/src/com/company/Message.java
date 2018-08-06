package com.company;

/**
 * Created by anastasiya on 30.03.17.
 */
class Message {
    public  boolean isError;
    public  String textMessage ;

    public Message(boolean isError, String textMessage) {
        this.isError = isError;
        this.textMessage = textMessage;
    }
}
