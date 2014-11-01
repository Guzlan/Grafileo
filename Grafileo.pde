
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
void setup() {
 size (1080,835);
 plotX1= 100; 
 plotX2= width- 120; 
 plotY1 = 200; 
 plotY2= height-200; 
 background = loadImage("ggg.png");
 
 timeLapsed=0;
 timeSeries= new int[10];
 for(int i=0; i<timeSeries.length; i++){
 timeSeries[i]=0; 
 }
 timeIndex=timeSeries.length;
 smooth();
 println(timeIndex);
 run = false; 
 noLoop();
 
}
void draw() {
  frameRate(5);
  background(background);
  fill(255);
  rectMode(CORNERS); 
  rect(plotX1, plotY1, plotX2, plotY2);
  timeCounter(); 
  println(timeSeries[0]);
  noStroke();
  //this will draw our inside rectangle of plot 
  
 
   
 
}
// this method is responsible for drawing the time flow on the X axis
void drawXaxis() {
  //fill(0);
  //textSize(30); 
  //textAlign(CENTER, TOP); 
  for(int plot = 0; 0<10; plot++){
   
  }
  
  
}
//this method updates an array with currenttimelapse 
void timeCounter(){
  fill(255); 
  textSize(20); 
  textAlign(CENTER,TOP);
  for(int i =0; i<timeIndex; i++){
  if(i+1 !=10){
  timeSeries[i]=timeSeries[i+1];
  }
  float x = map(i, 0, 9, plotX1,plotX2);
  if(timeSeries[i]!=0){ 
  text(timeSeries[i],x,plotY2+10);
  }
  stroke(0);
  strokeWeight(0.5);
  line(x,plotY1, x,plotY2);
  }
  timeSeries[9]=timeLapsed++;
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
