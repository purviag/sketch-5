import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddressList IPaddressList = new NetAddressList();

int myListeningPort = 9000;
int myBroadcastPort = 8000;

String myMessageTag = "/RAIN2";
int myPositionX;
int myPositionY;

String yourMessageTag = "/RAIN1";
String yourIPaddress = "127.0.0.1";
int yourPositionX;
int yourPositionY;

Drop[] drops = new Drop[100];

void setup()
{
 size(1280,640);
  for (int i = 0; i < drops.length; i++) {
 drops[i] = new Drop();
 }
 
 oscP5 = new OscP5(this, myListeningPort); 
  
 //add the IP of the devices you want to send to
 //use the command multiple times for multiple IP addresses
 //*****UPDATE THIS WITH YOUR IP ADDRESSES
 connect(yourIPaddress);
  
  
}
void draw()
{
 background(255);
 fill(100,150,255);
 /// draw my rain
 // for (int i = 0; i < drops.length; i++) {
// drops[i].fall();
// drops[i].show();
 //}
 
 ///Draw my circle
 int myPositionX = mouseX;
 int myPositionY = mouseY;
 
ellipse(myPositionX,myPositionY,50,50);
 
 ///send the data to everyone
 //create the message object with the appropriate tag
 OscMessage mPosition = new OscMessage(myMessageTag);
 //add the data to it
 mPosition.add(myPositionX);
 mPosition.add(myPositionY);
 //send the message to all the IP addresses
 oscP5.send(mPosition,IPaddressList);
 
 
///draw your circle
fill(255,150,100);
ellipse(yourPositionX,yourPositionY,20,20);

///draw your rain 
for (int i = 0; i < drops.length; i++) {
 drops[i].fall();
 drops[i].show();
 }

  
}

void oscEvent(OscMessage incomingMessage) 
  {
    println(incomingMessage);
    if(incomingMessage.checkAddrPattern(yourMessageTag)==true) 
    {
      yourPositionX = incomingMessage.get(0).intValue();
      yourPositionY = incomingMessage.get(1).intValue();
    }
    
    
  }



void connect(String theIPaddress) {
     if (!IPaddressList.contains(theIPaddress, myBroadcastPort)) {
       IPaddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
       println("### adding "+theIPaddress+" to the list.");
     } else {
       println("### "+theIPaddress+" is already connected.");
     }
     println("### currently there are "+IPaddressList.list().size()+" remote locations connected.");
 }
