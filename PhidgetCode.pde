import com.phidgets.*;
import com.phidgets.event.*;


InterfaceKitPhidget ik;
Shape myShape;
//moving circle global varible
int rad = 100;         // Radius of the circle
float cX1, cY1;        // Starting position of circle   
float cX2, cY2;    
float cX3, cY3;     
float sX1 = 2.8;       //speed 
float sY1 = 2.2;  
float sX2 = 7.6;  
float sY2 = 1.3;  
float sX3 = 13.8;  
float sY3 = 6.0;  
int dX1 = 1;          // Left or Right
int dY1 = 1;          // Top to Bottom
int dX2 = 1;  
int dY2 = 1;  
int dX3 = 1;  
int dY3 = 1;  

int countR = 0;
int countB = 0;
int countO = 0;

//text
String message = "Stay Away";
float mX, mY; //X and Y coordinates of message
float hr, vr; // horizontal and vertical radius of the message

void setup() {
 size(1000, 1000);
 
 //moving circle
 frameRate(30);
 ellipseMode(RADIUS);
 cX1 = width/2;
 cY1 = height/2;
 cX2 = width/3;
 cY2 = height/3;
 cX3 = width/4;
 cY3 = height/4;

 // Text
 fill(242,137,0);
 textAlign(CENTER, CENTER);
 textSize(40);
 hr = textWidth(message) / 2;
 vr = (textAscent() + textDescent()) / 2;
 noStroke();
 mX = width/2;
 mY = height/2;

try {
   ik = new InterfaceKitPhidget();
   ik.openAny();
   println("Waiting for Phidget...");
   ik.waitForAttachment();
   println("Ready to go!");
   ik.setOutputState(0,false);
   ik.setOutputState(1,false);
   ik.setOutputState(2,false);
 } catch(Exception e) {
   println("ERROR!");
   System.out.println(e);
 }
//ik.addSensorChangeListener(myShape);
}

void draw() {
   background(100,100,100);
   fill(0);
   float addX = 10;
   float addY = 10;
   float size = 0;
   int r = 0;
   int g = 0;
   int b = 0;
   myShape = new Shape(width/16,7*height/8); //starting point for X and Y
 
//moving circles intersect rectangle
   cX1 = cX1 + ( sX1 * dX1 );
   cY1 = cY1 + ( sY1 * dY1 );
   if (cX1 > width-rad || cX1 < rad) {
      dX1 *= -1; 
   }
   if (cY1 > height-rad || cY1 < rad) {
      dY1 *= -1;
   }
   fill(191,19,19); // red circle
   ellipse(cX1, cY1, rad, rad); 

   cX2 = cX2 + ( sX2 * dX2 );
   cY2 = cY2 + ( sY2 * dY2 );
   if (cX2 > width-rad || cX2 < rad) {
      dX2 *= -1;
   }
   if (cY2 > height-rad || cY2 < rad) {
      dY2 *= -1;
   }
   fill(0,222,252); //blue circle
   ellipse(cX2, cY2, rad, rad);
 
   cX3 = cX3 + ( sX3 * dX3 );
   cY3 = cY3 + ( sY3 * dY3 );
   if (cX3 > width-rad || cX3 < rad) {
      dX3 *= -1;
   }
   if (cY3 > height-rad || cY3 < rad) {
      dY3 *= -1;
   }
   fill(252,134,0); //orange circle
   ellipse(cX3, cY3, rad, rad);

   try {
     addX = width*ik.getSensorValue(1)/(1000);
     addY = -height*ik.getSensorValue(0)/(1000);
     size = ik.getSensorValue(2);
     r = ik.getSensorValue(3);
     g = ik.getSensorValue(4);
     //b = ik.getOutputState(5);
   } catch (Exception e) {
     println(e.toString());
   }
  myShape.setSensorValues(addX,addY,size,r,g,b);
  myShape.draw();
}

//my rectangle
class Shape implements SensorChangeListener {
  float posX = 0;
  float posY = 0;
  float addX = 10;
  float addY = 10;
  float size = 5;
  int r = 0;
  int g = 0;
  int b = 0;
  
  Shape(float x, float y) {
    this.posX = x;
    this.posY = y;
  }

  void draw() {
    float x = posX+addX;
    float y = posY+addY;
    fill(r,g,b);
    rect(x, y, size, size);
   
   
    // If my rectangle is over the circles, change background color
    if (sqrt(sq(cX1 - (x+size) ) + sq(cY1 - (y+size)))< rad) {
      background(191,19,19); //rurns red
      countR++;
      try{
         ik.setOutputState(0,true);
         //countR++;
      }catch(PhidgetException pe){
        print("No!");
      }
    }

    if (sqrt(sq(cX2 - (x+size) ) + sq( cY2 - (y+size)))< rad) {
       background(0,222,252); //blue
       countB++;
       try{
           ik.setOutputState(1,true);
           //countB++;
        }catch(PhidgetException pe){
           print("No!");
       }
    }
 
    if (sqrt(sq(cX3 - (x+size) ) + sq( cY3 - (y+size)))< rad) {
        background(252,134,0); //orange
        countO++;
        try{
           ik.setOutputState(2,true);
           //countO++;
        }catch(PhidgetException pe){
           print("No!");
        }
    }
    
  // If my rectangle is over the text, change the text position
    if (abs(x - mX) < hr && abs(y - y) < vr) {
      mX += random(-5, 5);
      mY += random(-5, 5);
    }
      text("Stay Away", mX, mY);  
      
        //if(countR>0 && countB >0 && countO >0
  if(countR>0 && countB >0 && countO >0 && mX != width/2 && mY != height/2) {
      background(255);
      fill(0);
      textSize(40);
      textAlign(CENTER);
      text("GAME OVER", width/2, height/2);
  }

}

  public void setSensorValues(float x, float y, float s, int r, int g, int b) {
      this.addX = x;
      this.addY = y;
      this.size = s;
      this.r = r;
      this.g = g;
      this.b = b;
  }
  
  void sensorChanged(SensorChangeEvent sce) {
    if (sce.getIndex()==1) {
      addX = sce.getValue()*width/(4*1000);
    }
    if (sce.getIndex()==0) {
      addY = -sce.getValue()*height/(4*1000);
    }
    if (sce.getIndex()==2) {
      size = sce.getValue();
    }
    if (sce.getIndex()==3){
      r=sce.getValue();
    }
  } 
}