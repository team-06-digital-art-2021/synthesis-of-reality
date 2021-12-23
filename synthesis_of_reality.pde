//Part of the code adapted from a tutorial by The Coding Train, thank you Daniel Shiffman
//https://thecodingtrain.com/CodingChallenges/102-2d-water-ripple.html

//Coded for a 2021 Digital Art project, at Politecnico di Milano
//Coded by shmanfredi

PGraphics mask;
PImage bgImg, topImg;
Ripple ripple;

int value;

void setup() {
  size (1024, 576);

  mask = createGraphics(width, height);

  bgImg = loadImage("assets/sea.png");
  bgImg.resize(width, height);
  topImg = loadImage("assets/dune.jpeg");
  topImg.resize(width, height);
  
  ripple = new Ripple();
  frameRate(60);
}

void draw() {
  
  noCursor ();

int w;

  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.ellipseMode(CENTER);

  //change size on mouseClick
  if (mousePressed == false) {
      w = 300;
      }
      else {
        w = 500;
        }

    //gradient - feather on mask
    for (int i = 1; i < 150; i++)   {
      //noShow mouse
        if (mouseX < 1 || mouseY < 1) {
    mask.fill (0);
    }
    else {
    mask.fill(i*2);
    }
    mask.ellipse(mouseX, mouseY, w-(2*i), w-(2*i));         
  }

  mask.noStroke();
  mask.endDraw(); 

 
 loadPixels();  
    bgImg.loadPixels();  
    topImg.loadPixels();

  for (int loc = 0; loc < width * height; loc++) {
    pixels[loc] = ripple.col[loc];
  }
 
  image(bgImg, 0, 0, width, height);

  topImg.mask(mask);
   
  updatePixels();
    
  image(topImg, 0, 0, width, height);
    ripple.newframe();
    if (mouseX > 0 || mouseY >0){
    for (int j = mouseY - ripple.riprad; j < mouseY + ripple.riprad; j++) {
    for (int k = mouseX - ripple.riprad; k < mouseX + ripple.riprad; k++) {
      if (j >= 0 && j < height && k>= 0 && k < width) {
        ripple.ripplemap[ripple.oldind + (j * width) + k] += 100;
      }
    }
  }
}
}

class Ripple {
  int i, a, b;
  int oldind, newind, mapind;
  short ripplemap[];
  int col[];
  int riprad;
  int rwidth, rheight;
  int ttexture[];
  int ssize;

  Ripple() {
    riprad = 20;
    rwidth = width >> 1;
    rheight = height >> 1;
    ssize = width * (height + 2) * 2;
    ripplemap = new short[ssize];
    col = new int[width * height];
    ttexture = new int[width * height];
    oldind = width;
    newind = width * (height + 3);
  }

  void newframe() {
    i = oldind;
    oldind = newind;
    newind = i;

    i = 0;
    mapind = oldind;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        short data = (short)((ripplemap[mapind - width] + ripplemap[mapind + width] + 
          ripplemap[mapind - 1] + ripplemap[mapind + 1]) >> 1);
        data -= ripplemap[newind + i];
        data -= data >> 5;
        if (x == 0 || y == 0)
          ripplemap[newind + i] = 0;
        else
          ripplemap[newind + i] = data;

        data = (short)(1024 - data);

        a = ((x - rwidth) * data / 1024) + rwidth;
        b = ((y - rheight) * data / 1024) + rheight;

        if (a >= width) 
          a = width - 1;
        if (a < 0) 
          a = 0;
        if (b >= height) 
          b = height-1;
        if (b < 0) 
          b=0;

        col[i] = bgImg.pixels[a + (b * width)];
        mapind++;
        i++;
      }
    }
  }
}
