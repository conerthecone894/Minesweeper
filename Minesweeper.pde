import de.bezier.guido.*;

public final static int NUM_ROWS = 24;
public final static int  NUM_COLS = 24;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

private Particle[] tony = new Particle[888];
public confetti[] tim = new confetti[400];

void setup ()
{
    size(512, 512);
    textAlign(CENTER,CENTER);
    
    
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    mines = new ArrayList<MSButton>();
    
    for(int i = 0; i < NUM_ROWS; i++){
      for(int o = 0; o < NUM_COLS; o++){
        buttons[i][o] = new MSButton(i, o);
      }
    }
    
    setMines();
    
  //WIN ANIMATION INITIALIZE
  for(int i = 0; i < 400; i++){
    tim[i] = new confetti();
    tim[i].setClr(((int)(Math.random()*7)));
  }
  
  //DEATH ANIMATION INITIALIZE
  
  for(int i = 0; i < 400; i++){
    tony[i] = new Particle();
    tony[i].setClr(((int)(Math.random()*6)));
  }
  
  for(int i = 400; i < 888; i++){
    tony[i] = new smallParticle();
    tony[i].setClr(((int)(Math.random()*6)));
  }
}
public void setMines()
{
    int totalMines = (int)(Math.random()*88)+8;
    int r = 0;
    int c = 0;
    
    for(int i = 0; i < totalMines; i++){
      r = (int)(Math.random()*24);
      c = (int)(Math.random()*24);
      
      if (!mines.contains(buttons[r][c])){
        mines.add(buttons[r][c]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int i = 0; i < mines.size(); i++){
      if(mines.get(i).isFlagged() == false){
        return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
    for(int i = 0; i < 24; i++){
      for(int o = 0; o < 24; o++){
        buttons[i][o].setLabel("");
      }
    }
    
    for(int i = 0; i < mines.size(); i++){
      mines.get(i).reveal(true);
    }
  
    fill(#1F47DE);
    
    buttons[1][1].setLabel("n");
    buttons[1][2].setLabel("i");
    buttons[1][3].setLabel("c");
    buttons[1][4].setLabel("e");
    
    buttons[2][1].setLabel("o");
    buttons[2][2].setLabel("n");
    buttons[2][3].setLabel("e");
}
public void displayWinningMessage()
{
    
    for(int i = 0; i < 24; i++){
      for(int o = 0; o < 24; o++){
        buttons[i][o].setLabel("");
      }
    }
  
    fill(#1F47DE);
  
    buttons[1][1].setLabel("c");
    buttons[1][2].setLabel("o");
    buttons[1][3].setLabel("n");
    buttons[1][4].setLabel("g");
    buttons[1][5].setLabel("r");
    buttons[1][6].setLabel("a");
    buttons[1][7].setLabel("t");
    buttons[1][8].setLabel("s");
}
public boolean isValid(int r, int c)
{
  if(r < 0 || r >= NUM_ROWS) {return false;}
  if(c < 0 || c >= NUM_COLS) {return false;}
  
  return true;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    
    for(int i = row-1; i <= row+1; i++){
      for(int o = col-1; o <= col+1; o++){
        if(isValid(i, o) == true){
          if(i != row || o != col){
            for(int u = 0; u < mines.size(); u++){
              if(mines.get(u) == buttons[i][o])
                numMines++;
            }
          }
        }
      }
    }
    
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged, lost;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 512/NUM_COLS;
        height = 512/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        lost = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
          clicked = true;
          
        if(mouseButton == RIGHT){
          if(flagged == true) {
            clicked = false;
            flagged = false;
          }
          else {flagged = true;} 
        }
        
        else if(mines.contains(this)){
          lost = true;
          displayLosingMessage();
        }
        
        else if(countMines(myRow, myCol) > 0){
          setLabel(countMines(myRow, myCol));
        }
        
        else{
          for(int i = myRow-1; i <= myRow+1; i++){
            for(int o = myCol-1; o <= myCol+1; o++){              
               if(isValid(i, o) == true && buttons[i][o].clicked == false){
                 buttons[i][o].mousePressed();
               }
            }
          }
        }
        
    }
    public void draw () 
    {    
        if (flagged)
            fill(#fff8ed);
        else if( clicked && mines.contains(this)) 
            fill(#e01f3f);
        else if(clicked)
            fill(#271d2c);
        else 
            fill(#7b6960);

        rect(x, y, width, height);
        fill(#fff8ed);
        text(myLabel,x+width/2,y+height/2);
        
        //WIN ANIMATION
        if(isWon() == true){
          for(int i = 0; i < 400; i++){
            tim[i].show();
            tim[i].yeah();
          }
        }
        
        //DEATH ANIMATION
        if(lost == true){
          for(int i = 0; i < tony.length; i++){
            tony[i].show();
            tony[i].boom();
           }
        }
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    
     public void reveal(boolean x){
       clicked = x;
     }
}
//WIN ANIMATION CODE PAST THIS POINT

public class confetti{
  private float myX, myY, mySize, speed;
  private int myClr;
  private int[] clr = new int[7];
  
  public confetti(){
    myX = (float)Math.random()*512;
    myY = -(float)Math.random()*88;
    mySize = (float)Math.random()*8;
    speed = -0.5;
    
    clr[0] = color(#914c89);
    clr[1] = color(#b57e8f);
    clr[2] = color(#ccb5a7);
    clr[3] = color(#eeedda);
    clr[4] = color(#97bfb5);
    clr[5] = color(#667b9d);
    clr[6] = color(#47346a);
  }
  
  public void setClr(int x){
    myClr = x;
  }
  
  public void show(){
    noStroke();
    fill(clr[myClr]);
    ellipse(myX, myY, mySize, mySize);
  }
  
  public void yeah(){
    if(speed < 8){
      speed += Math.random()/2;
    } else {
      speed += Math.random()/3;
    }
    myY += speed;
  }
}


//DEATH ANIMATION CODE PAST THIS POINT

public class Particle{ // blood particles
  protected double myX, myY, speed, angle;
  protected int opacity, mySize, myClr;
  protected int[] clr = new int[6];
  
  public Particle(){
    myX = 256.0;
    myY = 256.0;
    mySize = 3;
    opacity = 255;
    speed = Math.random()*27+2;
    angle = Math.random()*2*PI;
   
    clr[0] = color(#ff252b);
    clr[1] = color(#d3181c);
    clr[2] = color(#a8141d);
    clr[3] = color(#7d0f1f);
    clr[4] = color(#520b20);
    clr[5] = color(#3c0921);
  }
  
  public void setClr(int x){
    myClr = x; 
  }
  
  public void show(){
    noStroke();
    fill(clr[myClr], opacity);
    ellipse((float)myX, (float)myY, mySize, mySize);
  }
  
  public void boom(){
    myX += Math.cos(angle)*speed;
    myY += Math.sin(angle)*speed;
    opacity -= 0;
    
    if(speed <= 0){
      speed = 0;
    } else {
      speed -= 2;
    }
  }
  
}

public class smallParticle extends Particle{ //smaller blood particles
  smallParticle(){
  mySize = 2;
  }
  
  void show(){
    noStroke();
    fill(clr[myClr], opacity);
    ellipse((int)myX, (int)myY, mySize, mySize);
  }
}

//colors: (all on lospec.com)
/* 
LASER LAB by polyphrog (one of the art examples was literally minesweeper I had to.)
BLOODMOON21 by Ademack
HEPTARAINBOW by Dr. Jetson (the code doesn't work as intended. dm @connory94 on discord or conerdoesntsoundlike on instagram if you want the working thing in a seperate .pde file
*/
