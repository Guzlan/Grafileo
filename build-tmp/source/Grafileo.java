import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import java.util.*; 
import java.text.SimpleDateFormat; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Grafileo extends PApplet {





//import java.util.Formatter;


PrintWriter output; // creates a file printer.
String fileName ;
// Points that mark the corners of the graph plot inside the actuall app
float plotX1, plotX2, plotY1, plotY2;
PImage background;

// the font for our axis; 
PFont plotFont; 
int currentTime; 
float timeLapsed; 
float timeSeries[];
int timeIndex; 
boolean run;
short LF = 10;
int dataMax; 
int dataMin; 
int yAxisInterval; 
int points[];
int pointIndex; 
float serialRead;// the value read from the serial port to be graphed
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



public void setup() {
 size(1080,720);
 frameRate(2);
 numberOfTabs = 3; 
 /*
 Date now = new Date();
 fileName = new SimpleDateFormat("yyMMdd_HHmm").format(now); 
 output = createWriter ( fileName + ".csv") ;
 output.println("Recorded values are:" );
 output.println("Time"+"," + "Sensor2"+","+"Sensor3"); 
 */
 myPort= null;
 plotX1= 100; 
 plotX2= width- 120; 
 plotY1 = 200; 
 plotY2= height-200; 
 background = loadImage("bla3.jpg"); 
 println(Serial.list()); 
 nums = new int[3];
 
 for (int x= 0; x<nums.length; x++){
 nums[x] = 0; 
 } 
 timeLapsed=0;
 timeSeries= new float[20];
 
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
 run = false;
 coloring=false;
 noLoop();
 myPort = new Serial(this, Serial.list()[3],9600); 
}


public void draw() {
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
}
// this method is responsible for drawing the time flow on the X axis
//this method updates an array with currenttimelapse 
public void drawXaxis(){
  fill(255); 
  textSize(15); 
  textAlign(CENTER,TOP);
  for(int i =0; i<timeIndex; i++){
  if(i+1 !=timeIndex){
  timeSeries[i]=timeSeries[i+1];
  }
  else if ( i+1 ==timeIndex){
    
   timeSeries[i] = timeLapsed;
   timeLapsed = timeLapsed+0.5f;
  }
  float x = map(i, 0, timeIndex-1, plotX1,plotX2);
  if(timeSeries[i]!=0 ){ 
   String show = String.format("%.1f", timeSeries[i]);
  text(show,x,plotY2+10);
  }
  if(coloring == true){
  stroke(255);
  }
  else if(coloring==false){
  stroke(0);
  }
  strokeWeight(0.5f);
  line(x,plotY1, x,plotY2);
  }
}

public void drawYaxis(){
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


public void plotPoints(){
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


public void keyPressed () {
 // if 's' is pressed on key board it would stop or stop the plotting.
  if (key=='s'){
  if(run == false) {
    run = true;
 Date now = new Date();
 fileName = new SimpleDateFormat("yyMMdd_HHmm").format(now); 
 output = createWriter ( fileName + ".csv") ;
 output.println("Recorded values are:" );
 output.println("Time"+"," + "Sensor2"+","+"Sensor3"); 
   myPort.write ("s"); 
    loop();  
  }
 
 else{
   run = false;
   myPort.write ("s"); 
   noLoop();
   restart();
 }
}

// if 'r' is pressed on the keyboard it would restart the program.  
/*
if(key=='r'){
  
 restart();
}
*/
if(key=='f'){
if(coloring == false) {
    coloring = true;  
  }
 else{
   coloring = false;
 }
}
}
public void serialEvent(Serial myPort){
  
// get the ASCII String
  for (int i = 0; i<3; i++) {
  String number = myPort.readStringUntil(10);
  if(number != null){ 
  int test[]=PApplet.parseInt(split(number, ','));
  for(int x =0 ; x<test.length;x++){
    if (test[x] != 0){
      nums[x] = test[x];
    }
  }
   print(nums[0]); 
   print(',');
   print(nums[1]);
   print(',');
   println(nums[2]); 
   output.println(nums[0]+","+nums[1]+","+nums[2]); 
  }
}

}
public void restart(){
 timeLapsed=0;
 timeSeries= new float[20];
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
public void drawTitleTabs() {
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

public void mousePressed(){
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


// first line of the file should be the column headers
// first column should be the row titles
// all other values are expected to be floats
// getFloat(0, 0) returns the first data value in the upper lefthand corner
// files should be saved as "text, tab-delimited"
// empty rows are ignored
// extra whitespace is ignored


class FloatTable {
  int rowCount;
  int columnCount;
  float[][] data;
  String[] rowNames;
  String[] columnNames;
  
  
  FloatTable(String filename) {
    String[] rows = loadStrings(filename);
    
    String[] columns = split(rows[0], TAB);
    columnNames = subset(columns, 1); // upper-left corner ignored
    scrubQuotes(columnNames);
    columnCount = columnNames.length;

    rowNames = new String[rows.length-1];
    data = new float[rows.length-1][];

    // start reading at row 1, because the first row was only the column headers
    for (int i = 1; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }

      // split the row on the tabs
      String[] pieces = split(rows[i], TAB);
      scrubQuotes(pieces);
      
      // copy row title
      rowNames[rowCount] = pieces[0];
      // copy data into the table starting at pieces[1]
      data[rowCount] = parseFloat(subset(pieces, 1));

      // increment the number of valid rows found so far
      rowCount++;      
    }
    // resize the 'data' array as necessary
    data = (float[][]) subset(data, 0, rowCount);
  }
  
  
  public void scrubQuotes(String[] array) {
    for (int i = 0; i < array.length; i++) {
      if (array[i].length() > 2) {
        // remove quotes at start and end, if present
        if (array[i].startsWith("\"") && array[i].endsWith("\"")) {
          array[i] = array[i].substring(1, array[i].length() - 1);
        }
      }
      // make double quotes into single quotes
      array[i] = array[i].replaceAll("\"\"", "\"");
    }
  }
  
  
  public int getRowCount() {
    return rowCount;
  }
  
  
  public String getRowName(int rowIndex) {
    return rowNames[rowIndex];
  }
  
  
  public String[] getRowNames() {
    return rowNames;
  }

  
  // Find a row by its name, returns -1 if no row found. 
  // This will return the index of the first row with this name.
  // A more efficient version of this function would put row names
  // into a Hashtable (or HashMap) that would map to an integer for the row.
  public int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (rowNames[i].equals(name)) {
        return i;
      }
    }
    //println("No row named '" + name + "' was found");
    return -1;
  }
  
  
  // technically, this only returns the number of columns 
  // in the very first row (which will be most accurate)
  public int getColumnCount() {
    return columnCount;
  }
  
  
  public String getColumnName(int colIndex) {
    return columnNames[colIndex];
  }
  
  
  public String[] getColumnNames() {
    return columnNames;
  }


  public float getFloat(int rowIndex, int col) {
    // Remove the 'training wheels' section for greater efficiency
    // It's included here to provide more useful error messages
    
    // begin training wheels
    if ((rowIndex < 0) || (rowIndex >= data.length)) {
      throw new RuntimeException("There is no row " + rowIndex);
    }
    if ((col < 0) || (col >= data[rowIndex].length)) {
      throw new RuntimeException("Row " + rowIndex + " does not have a column " + col);
    }
    // end training wheels
    
    return data[rowIndex][col];
  }
  
  
  public boolean isValid(int row, int col) {
    if (row < 0) return false;
    if (row >= rowCount) return false;
    //if (col >= columnCount) return false;
    if (col >= data[row].length) return false;
    if (col < 0) return false;
    return !Float.isNaN(data[row][col]);
  }
  
  
  public float getColumnMin(int col) {
    float m = Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      if (!Float.isNaN(data[i][col])) {
        if (data[i][col] < m) {
          m = data[i][col];
        }
      }
    }
    return m;
  }

  
  public float getColumnMax(int col) {
    float m = -Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      if (isValid(i, col)) {
        if (data[i][col] > m) {
          m = data[i][col];
        }
      }
    }
    return m;
  }

  
  public float getRowMin(int row) {
    float m = Float.MAX_VALUE;
    for (int i = 0; i < columnCount; i++) {
      if (isValid(row, i)) {
        if (data[row][i] < m) {
          m = data[row][i];
        }
      }
    }
    return m;
  } 

  
  public float getRowMax(int row) {
    float m = -Float.MAX_VALUE;
    for (int i = 1; i < columnCount; i++) {
      if (!Float.isNaN(data[row][i])) {
        if (data[row][i] > m) {
          m = data[row][i];
        }
      }
    }
    return m;
  }
  
  
  public float getTableMin() {
    float m = Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (isValid(i, j)) {
          if (data[i][j] < m) {
            m = data[i][j];
          }
        }
      }
    }
    return m;
  }

  
  public float getTableMax() {
    float m = -Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (isValid(i, j)) {
          if (data[i][j] > m) {
            m = data[i][j];
          }
        }
      }
    }
    return m;
  }
}
class Integrator {

  final float DAMPING = 0.5f;
  final float ATTRACTION = 0.2f;

  float value;
  float vel;
  float accel;
  float force;
  float mass = 1;

  float damping = DAMPING;
  float attraction = ATTRACTION;
  boolean targeting;
  float target;


  Integrator() { }


  Integrator(float value) {
    this.value = value;
  }


  Integrator(float value, float damping, float attraction) {
    this.value = value;
    this.damping = damping;
    this.attraction = attraction;
  }


  public void set(float v) {
    value = v;
  }


  public void update() {
    if (targeting) {
      force += attraction * (target - value);      
    }

    accel = force / mass;
    vel = (vel + accel) * damping;
    value += vel;

    force = 0;
  }


  public void target(float t) {
    targeting = true;
    target = t;
  }


  public void noTarget() {
    targeting = false;
  }
}
class Table {
  String[][] data;
  int rowCount;
  
  
  Table() {
    data = new String[10][10];
  }

  
  Table(String filename) {
    String[] rows = loadStrings(filename);
    data = new String[rows.length][];
    
    for (int i = 0; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }
      
      // split the row on the tabs
      String[] pieces = split(rows[i], TAB);
      // copy to the table array
      data[rowCount] = pieces;
      rowCount++;
      
      // this could be done in one fell swoop via:
      //data[rowCount++] = split(rows[i], TAB);
    }
    // resize the 'data' array as necessary
    data = (String[][]) subset(data, 0, rowCount);
  }


  public int getRowCount() {
    return rowCount;
  }
  
  
  // find a row by its name, returns -1 if no row found
  public int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (data[i][0].equals(name)) {
        return i;
      }
    }
    println("No row named '" + name + "' was found");
    return -1;
  }
  
  
  public String getRowName(int row) {
    return getString(row, 0);
  }


  public String getString(int rowIndex, int column) {
    return data[rowIndex][column];
  }

  
  public String getString(String rowName, int column) {
    return getString(getRowIndex(rowName), column);
  }

  
  public int getInt(String rowName, int column) {
    return parseInt(getString(rowName, column));
  }

  
  public int getInt(int rowIndex, int column) {
    return parseInt(getString(rowIndex, column));
  }

  
  public float getFloat(String rowName, int column) {
    return parseFloat(getString(rowName, column));
  }

  
  public float getFloat(int rowIndex, int column) {
    return parseFloat(getString(rowIndex, column));
  }
  
  
  public void setRowName(int row, String what) {
    data[row][0] = what;
  }


  public void setString(int rowIndex, int column, String what) {
    data[rowIndex][column] = what;
  }

  
  public void setString(String rowName, int column, String what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = what;
  }

  
  public void setInt(int rowIndex, int column, int what) {
    data[rowIndex][column] = str(what);
  }

  
  public void setInt(String rowName, int column, int what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }

  
  public void setFloat(int rowIndex, int column, float what) {
    data[rowIndex][column] = str(what);
  }


  public void setFloat(String rowName, int column, float what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }
  
  
  // Write this table as a TSV file
  public void write(PrintWriter writer) {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < data[i].length; j++) {
        if (j != 0) {
          writer.print(TAB);
        }
        if (data[i][j] != null) {
          writer.print(data[i][j]);
        }
      }
      writer.println();
    }
    writer.flush();
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "Grafileo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
