
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
int dataMax; 
int dataMin; 
int yAxisInterval; 
int points[];
int pointIndex; 
void setup() {
 size (1080,835);
 plotX1= 100; 
 plotX2= width- 120; 
 plotY1 = 200; 
 plotY2= height-200; 
 background = loadImage("ggg.png");
 
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
 dataMax = 10;
 yAxisInterval=1;  
 timeIndex=timeSeries.length;
 pointIndex= points.length;
 smooth();
 println(timeIndex);
 run = false; 
 noLoop();
 
}
void draw() {
  frameRate(10);
  background(background);
  fill(255);
  rectMode(CORNERS); 
  rect(plotX1, plotY1, plotX2, plotY2);
  
  drawYaxis();
  plotPoints();
  drawXaxis(); 
  
 

  
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
 fill(255); 
 textSize(20); 
 textAlign(RIGHT, CENTER);
 
 for ( float v=1;v <=dataMax;v += yAxisInterval){
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
  noFill();
  fill(103,34,103);
  strokeWeight(1);
  beginShape();
  for(int i =0; i<pointIndex; i++){
  if(i+1 !=pointIndex){
  points[i]=points[i+1];
  
  }
  else if ( i+1 ==pointIndex){
   points[i] = (int)random(0,10);
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

  setup();
}
}
