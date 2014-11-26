package com.org.mes;

/**
 * ...
 * @author 
 */
interface Subscriber
{
    function subscribeToMsgs(ofType : String) : Void;
    function unsubscribeToMsgs(ofType : String) : Void;
    function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void;
    //function broadcastMessage(name : String, sender : Cmp, options : Dynamic) : Void;
    function sendMsg(msgType : String, sender : Cmp, options : Dynamic) : Void;
}