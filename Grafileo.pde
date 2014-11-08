

import controlP5.*;
import processing.serial.*;
import java.util.*;
import java.text.SimpleDateFormat;



ControlP5 controlP5;
PrintWriter output; // creates a file printer.
String fileName ;
// Points that mark the corners of the graph plot inside the actuall app
float plotX1, plotX2, plotY1, plotY2;
PImage background;

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
int sensorSelector;
boolean coloring;
int time;
//int wait = 500;
//String number;
//DateFormat fnameFormat= new SimpleDateFormat("yyMMdd_HHmm");
void setup() {
 size(1080,810);
 frameRate(2);
 numberOfTabs = 3; 
 Date now = new Date();
 fileName = new SimpleDateFormat("yyMMdd_HHmm").format(now); 
 output = createWriter ( fileName + ".csv") ;
 output.println("Recorded values are:" );
output.println("Sensor1\t" + "Sensor2\t"+"Sensor3\t"); 
 
 myPort= null;
 plotX1= 100; 
 plotX2= width- 120; 
 plotY1 = 200; 
 plotY2= height-200; 
 background = loadImage("ggg.jpg");
// start = loadImage("start.png"); 
 println(Serial.list()); 
 
 nums = new int[3];
 for (int x= 0; x<nums.length; x++){
 nums[x] = 0; 
 } 
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
 //println(timeIndex);
 run = false;
 coloring=false;
 //createGUI();
 //customGUI();
 noLoop();
 //createGUI();
 myPort = new Serial(this, Serial.list()[3],9600); 
}

void draw() {

  background(background);
  fill(255);
  rectMode(CORNERS); 
  rect(plotX1, plotY1, plotX2, plotY2);
  
  number = myPort.readStringUntil(10);
  
 
  
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
  if(coloring == true){
  stroke(255);
  }
  else if(coloring==false){
  stroke(0);
  }
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
 
  if (coloring==true){
  if (sensorSelector == 0) {
  fill(103,34,103);
  }
  else if ( sensorSelector ==1){
  fill (0,128,128);
  }
  else if (sensorSelector ==2){
  fill(210,105,30);
  }
  }
  else if (coloring ==false){
  noFill();
  }
  stroke(0);
  strokeWeight(2);
  beginShape();
  for(int i =0; i<pointIndex; i++){
  if(i+1 !=pointIndex){
  points[i]=points[i+1];
  
  }
  else if ( i+1 ==pointIndex){
    if(nums !=null){
   points[i] = nums[sensorSelector];
    }
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
if(key=='f'){
if(coloring == false) {
    coloring = true; 
   
    
  }
 
 else{
   coloring = false;
  
 }
}
}

void serialEvent(Seial myPort){
  
// get the ASCII String

  for (int i = 0; i<3; i++) {
 
  String number = myPort.readStringUntil(10);
  
  if(number != null){
    
  int test[]=int(split(number, ','));
  if(int x =0 ; x<test.length();x++){
    if (test[x]!=null){
      nums[x] = test[x];
    }
    else{
      
    }
  
  }
 
   print(nums[0]); 
   print(',');
   print(nums[1]);
   print(',');
   println(nums[2]);
   
   
  
   output.println(nums[0]+"\t"+nums[1]+"\t"+nums[2]); 
  }
  
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
 output.flush(); 
 output.close();
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
  String title = ("Sensor " + (tabCount+1)); 
  tabLeft[tabCount]=runningX;
  float titleWidth = textWidth(title); 
  tabRight[tabCount] = tabLeft[tabCount] + tabPad + titleWidth +tabPad; 
  
  //if the current tab is selected then set its background white else
  // make other tabs gray. 
  
  fill( tabCount == sensorSelector ? 255: 224); 
  rect(tabLeft[tabCount], tabTop, tabRight[tabCount], tabBottom) ;
  
  //if the current tab, use  black for the text; otherwise use dark gray
  fill(tabCount == sensorSelector? 0 :64);
  text(title, runningX+tabPad, plotY1-10);
  
  runningX= tabRight[tabCount];
  
  
}

}


void mousePressed(){
  if(mouseY > tabTop && mouseY < tabBottom) {
   for(int tabCount =0 ; tabCount<numberOfTabs; tabCount++){
   if (mouseX>tabLeft[tabCount] && mouseX <tabRight[tabCount]){
    if (sensorSelector!=tabCount){
     sensorSelector = tabCount;
    }
   }
   }
    
  } 
} 


