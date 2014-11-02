import controlP5.*;
import processing.serial.*;

ControlP5 controlP5;
// Points that mark the corners of the graph plot inside the actuall app
float plotX1, plotX2, plotY1, plotY2;
PImage background;
PImage start;
// the font for our axis; 
PFont plotFont; 
int currentTime; 
int timeLapsed; 
int timeSeries[];
int timeIndex; 
boolean run;
short LF = 10;
int dataMax; 
int dataMin; 
int yAxisInterval; 
int points[];
int pointIndex; 
float serialRead; // the value read from the serial port to be graphed
Serial myPort; 
// the following is the coordinates for tabbed data. 
float[] tabLeft, tabRight; 
float tabTop, tabBottom; 
float tabPad = 10; 
int numberOfTabs;
int[] nums;
void setup() {
 numberOfTabs = 3; 
 size (1080,835);
 myPort= null;
 plotX1= 100; 
 plotX2= width- 120; 
 plotY1 = 200; 
 plotY2= height-200; 
 background = loadImage("ggg.png");
 start = loadImage("start.png"); 
 println(Serial.list()); 
 
 
 timeLapsed=0;
 timeSeries= new int[20];
 for(int i=0; i<timeSeries.length; i++){
 timeSeries[i]=0; 
 }
 points= new int[20];
 for(int i=0; i<points.length; i++){
 points[i]=0; 
 }
 dataMin =0; 
 dataMax = 1024;
 yAxisInterval=100;  
 timeIndex=timeSeries.length;
 pointIndex= points.length;
 smooth();
 println(timeIndex);
 run = false;

 noLoop();
 myPort = new Serial(this, Serial.list()[3],9600); 
}

void draw() {
  frameRate(20);
  background(background);
  fill(255);
  rectMode(CORNERS); 
  rect(plotX1, plotY1, plotX2, plotY2);
  
  drawYaxis();
  plotPoints();
  drawXaxis();
  drawTitleTabs(); 
  
  println(timeSeries[0]);
  noStroke();
  //this will draw our inside rectangle of plot 

}
// this method is responsible for drawing the time flow on the X axis

//this method updates an array with currenttimelapse 
void drawXaxis(){
  fill(255); 
  textSize(20); 
  textAlign(CENTER,TOP);
  for(int i =0; i<timeIndex; i++){
  if(i+1 !=timeIndex){
  timeSeries[i]=timeSeries[i+1];
  
  }
  else if ( i+1 ==timeIndex){
   timeSeries[i] = timeLapsed++;
  }
  
  float x = map(i, 0, timeIndex-1, plotX1,plotX2);
  if(timeSeries[i]!=0 ){ 
  text(timeSeries[i],x,plotY2+10);
  }

  stroke(255);
  strokeWeight(0.5);
  line(x,plotY1, x,plotY2);
  }
  
}
void drawYaxis(){
 noFill();  
 textSize(20); 
 textAlign(RIGHT, CENTER);
 
 for ( float v=100;v <=dataMax;v += yAxisInterval){
   float y = map(v, dataMin, dataMax, plotY2,plotY1);
   if ( v%yAxisInterval==0){
   text(floor(v),plotX1-10,y); 
   line(plotX1-4, y, plotX1,y); 
 }
 else {
   line(plotX1-2, y, plotX1,y);
 }
 }
}
void plotPoints(){
  //noFill();
  fill(103,34,103);
  stroke(0);
  strokeWeight(2);
  beginShape();
  for(int i =0; i<pointIndex; i++){
  if(i+1 !=pointIndex){
  points[i]=points[i+1];
  
  }
  else if ( i+1 ==pointIndex){
   points[i] = nums[0];
  }
  
  float x = map(i, 0, pointIndex-1, plotX1,plotX2);
  float y = map(points[i], dataMin, dataMax, plotY2, plotY1); 
  if(y!=plotY2){
  curveVertex(x,y);
  
  if ((i == 0) || (i == pointIndex-1)) {
    curveVertex(x, y); 
  }

 }
 }
 vertex(plotX2, plotY2);
 vertex(plotX1, plotY2);
 endShape();
}

void keyPressed () {
 // if 's' is pressed on key board it would stop or stop the plotting.
  if (key=='s'){
  if(run == false) {
    run = true; 
    loop();
    
  }
 
 else{
   run = false;
   noLoop();
 }
}
// if 'r' is pressed on the keyboard it would restart the program.  
if(key=='r'){
  
 restart();
}
}

void serialEvent( Serial myPort){
// get the ASCII String
  String numbers = myPort.readStringUntil(LF);
  //String inString = myPort.readStringUntil('\n');
  // trim or remove any white spaces. 
  //inString = trim(inString);
  //float inByte = float(inString);
  if(numbers != null){
  nums = int(split(numbers, ',')); 
  // print(message);
  //print(serialRead);
   //output.print(message); 
  }
  
}
void restart(){
 timeLapsed=0;
 timeSeries= new int[20];
 for(int i=0; i<timeSeries.length; i++){
 timeSeries[i]=0; 
 }
 points= new int[20];
 for(int i=0; i<points.length; i++){
 points[i]=0; 
 }
 dataMin =0; 
 dataMax = 1024;
 yAxisInterval=100;  
 timeIndex=timeSeries.length;
 pointIndex= points.length;
 smooth();
 println(timeIndex);
 run = false; 
 noLoop();
}
// This function draws tabs. 

void drawTitleTabs() {
rectMode(CORNERS);
noStroke(); 
textSize(16); 
textAlign(LEFT);
// allocating space for an array to store the 
// right and left values of edges of the tabs.
if(tabLeft==null){
  tabLeft = new float[numberOfTabs];
  tabRight = new float [numberOfTabs];
}

float runningX = plotX1; 
tabTop = plotY1- textAscent()- 15; 
tabBottom = plotY1;  

for ( int tabCount = 0; tabCount < numberOfTabs; tabCount++){
  String title = ("Sensor " + tabCount+1); 
  tabLeft[tabCount]=runningX;
  float titleWidth = textWidth(title); 
  tabRight[tabCount] = tabLeft[tabCount] + tabPad + titleWidth +tabPad; 
  
  //if the current tab is selected then set its background white else
  // make other tabs gray. 
  
  fill( tabCount == numberOfTabs ? 255: 244); 
  rect(tabLeft[tabCount], tabTop, tabRight[tabCount], tabBottom) ;
  
  //if the current tab, use  black for the text; otherwise use dark gray
  fill(tabCount == numberOfTabs? 0 :64);
  text(title, runningX+tabPad, plotY1-10);
  
  runningX= tabRight[tabCount];
  
  
}

}

/*
void mousePressed(){
  if(mouseY > tabTop && mouseY < tabBottom) {
   for(int tabCount ; tabCount<numberOfTabs; tabCount++){
   if (moust
   }
    
  } 
} 
*/

