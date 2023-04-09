import controlP5.*;

import netP5.*;
import oscP5.*;

import processing.sound.*;

ControlP5 cp5;
OscP5 oscP5;
NetAddress dest;

PImage[] hungry_img= new PImage[3];
PImage[] sleep_img= new PImage[3];
PImage[] cry_img= new PImage[3];

String getName;

PImage normal_img, meal_img, success_img, good_img;

int frame=0;
  int tempframe;//mealbutton

int score=0;
  int tempscore;

int mode=0; // 
  int normal=0;
  int sleep=1;
  int hungry=2;
  int cry=3;
  int grown_up=4;

int currentmode=0; //0: normal, 1: signal 2: done
int gameState = 0;

int i=0;

boolean getscore=false;
boolean meal_drag_start=false;
boolean mealonmouth=false;
boolean good=false;

SoundFile crying, eating, laughing, hungrySound, finish, sleeping;
int soundClass = 0, prevSoundClass = 0;

void setup()
{
  size(800, 800);
  imageMode(CENTER);
  
  cp5 = new ControlP5(this);

  
  hungry_img[0] = loadImage("hungry1.png");
  hungry_img[1] = loadImage("hungry2.png");
  hungry_img[2] = loadImage("hungry3.png");

  cry_img[0] = loadImage("cry.png");
  cry_img[1] = loadImage("cry2.png");
  cry_img[2] = loadImage("p10_cry3.png");

  sleep_img[0] = loadImage("sleep1.png");
  sleep_img[1] = loadImage("sleep2.png");
  sleep_img[2] = loadImage("sleep3.png");

  normal_img = loadImage("normal.png");

  meal_img= loadImage("bottle.png");

  success_img= loadImage("finish.png");

  good_img= loadImage("good.JPG");
  
  crying =new SoundFile(this, "cry.aiff");
  eating = new SoundFile(this, "drink.aiff");
  laughing = new SoundFile(this, "happy.aiff");
  hungrySound = new SoundFile(this, "hungry.aiff");
  finish = new SoundFile(this, "clap.aiff");
  sleeping = new SoundFile(this,"sleep.aiff");
  
  frameRate(30);
}

void draw()
{
  background(255);
  translate(width/2, height/2);
  
  if (gameState == 0){
    fill(0);
    text("press Enter to Start", 100, 100);
    //  cp5.addTextfield("getName").setPosition(100,100).setSize(100,50).setAutoClear(false);
    //cp5.addBang("getBabyName").setPosition(200,100).setSize(100,50);
  }
  else {
    frameCount();

  time();
  
  if (prevSoundClass != soundClass){
    changeSound();
    prevSoundClass = soundClass;
  }
  
  babyrender();

  if (mode<4)
  {
    gauge();

    if (getscore==true)
    {  
      score++;
      if (score-tempscore==40)getscore=false;
    }

    random_change();
  }
  }
}

void gauge()
{
  if (score<320)
  {
    rectMode(CORNER);
    noStroke();
    fill(255, 235, 0);
    rect(-200, height/2-40, score, 20);
    strokeWeight(5);
    noFill();
    stroke(0);
    rectMode(CORNER);
    rect(-200, height/2-40, 320, 20);
    mealbutton();
  }

  if (score==320)  mode=4;
}

void time()
{
  push();
  colorMode(RGB);
  fill(230, 0, 0);
  noStroke();
  rect(-240, -320, 480-frame/5, 2);

  if (frame==480*5) mode=grown_up;

  pop();
}


void babyrender()
{
  if (mode==normal)
  {  
    if (good==true)
    {
      image(good_img, 0, 0, 300, 400);
      if (frame-tempframe>20) good=false;
    } else image(normal_img, 0, 0, 600, 600);
  } else if (mode==cry)
  {
    image(cry_img[i], 0, 0, 600, 600);
  } else if (mode==sleep)
  {
    image(sleep_img[i], 0, 0, 600, 600);
  } else if (mode==hungry)
  {
    image(hungry_img[i], 0, 0, 600, 600);
  }


  if (mode==grown_up)
  {
    fill(0);
    image(success_img, 0, 0, 600, 600);
    textSize(40);
    fill(255);
    textAlign(LEFT);
    soundClass = 4;
    if ((mouseX>330)&&(mouseY>570)) {
      push();
      stroke(0);
      strokeWeight(3);
      fill(255, 255, 0);
      text("REPLAY", 90, 300);
      pop();
    } else text("REPLAY", 90, 300);
  }
}

void keyPressed()
{
  if ((key == '1')&&(mode==1))
  {
    mode=0;
    soundClass = 0;
    getscore=true;
    tempscore=score;
    tempframe=frame;
  } else if ((key == '2')&&(mode==2)&&(mealonmouth==true)&&(meal_drag_start==false))
  {
    mode=0;
    soundClass = 0;
    mealonmouth=false;
    getscore=true;
    good=true;
    tempscore=score;
    tempframe=frame;
  } else if ((key == '3')&&(mode==3))
  {
    mode=0;
    soundClass = 0;
    getscore=true;
    good=true;
    tempscore=score;
    tempframe=frame;
  } else if ((key == '4')&&(mode==4))
  {
    mode=0;
    soundClass = 0;
    getscore=true;
    good=true;
    tempscore=score;
    tempframe=frame;
  }
  else if (key=='4'){
    mode=4;
    soundClass = 4;
  }
  
  else if (key == ENTER){
    gameState = 1;
  }
    
}

void mealbutton()
{
  if (meal_drag_start==false)
  {
    if (mealonmouth==false)image(meal_img, 240-30, 320-40, 60, 80);
    else image(meal_img, 0, 60, 90, 120);
  }

  if (meal_drag_start==true)
  {
    image(meal_img, mouseX-width/2, mouseY-height/2, 60, 80);
  }
}

void mouseReleased()
{ 
  if (meal_drag_start==true)
  {
    meal_drag_start=false; 
    if ((mouseX-width/2<50)&&(mouseX-width/2>-50)&&(mouseY-height/2>20)&&(mouseY-height/2<100)&&(mealonmouth==false)&&(mode==2))
    {
      mealonmouth=true;
    } else mealonmouth=false;
  }
}
void mousePressed()
{  
  if ((mouseX-width/2>180)&&(mouseY-height/2>240)&&(meal_drag_start==false))
  {
    meal_drag_start=true;
  }

  if ((mode==4)&&(mouseX>330)&&(mouseY>570))
  {
    frame=0;
    score=0;
    mode=normal;
    soundClass = 0;
  }
}

void random_change()
{
  if (mode<4) {
    if (frame%10==0)
    {
      i++;
      if (i==3)  i=0;
    }

    if (frame%240==0)
    {
      i=0;
      mode=int(random(1, 4));
      soundClass = mode;
      mealonmouth=false;
      meal_drag_start=false;
    }
  }
}

void changeSound() {
  crying.stop();
  eating.stop();
  laughing.stop();
  hungrySound.stop();
  finish.stop();
  sleeping.stop();
  
  switch( soundClass ) {
    case 0: 
    laughing.loop();
    break;
  case 1: 
  sleeping.loop();
    break;
  case 2: 
    hungrySound.loop();
    break;
  case 3: 
    crying.loop(); 
    break;
    case 4:
    finish.loop();
    break;
  }
}

//void getBabyName(){
//  print("get baby name");
//  getName = cp5.get(Textfield.class,"getName").getText();
//  print(getName);
//}

void frameCount()
{
  frame++;
}
