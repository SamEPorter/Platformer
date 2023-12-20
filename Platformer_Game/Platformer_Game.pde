import fisica.*;
FWorld world;
FPlayer player;

ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;

//pallete
int white   = #FFFFFF;
int black   = #000000;
int darkGray = #585858;
int gray    = #252525;
int red     = #FF0000;
int treecolor   = #cc6b17;
int green   = #00FF00;
int blue    = #0000FF;
int dirtClr = #124124;
int bridge  = #00ffc3;
int tramp   = #ffca18;
int goombaClr = #ffaec8;
int thwClr  = #ff3333;

// Tiles
PImage map, ice, brick, lava, dirtC, dirtN, dirtE, dirtS, dirtW, dirtNE, dirtNW, dirtSE, dirtSW;
PImage treeT, treeC, treeMid, treeL, treeR, bridgeL, bridgeC, bridgeR;
PImage water, thwSleep, thwMad;

//Sprites
PImage[] goomba;


PImage[] idle;
PImage[] jump;
PImage[] run;
PImage[] action;

int gridSize = 32 ;
float zoom = 1.5f;

boolean canJump = false;
boolean rsJump = false;
boolean lsJump = false;
int WJT = 0;

//keys
boolean wkey, akey, skey, dkey, upkey, downkey, leftkey, rightkey;










void setup() {

  //PImage pic = loadImage();
  //reverseImage(pic).save(image);

  fill(0);
  strokeWeight(2);
  size(600, 600);
  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();
  Fisica.init(this);
  map = loadImage("Map.png");

  // BLOCKS =======================================

  ice = loadImage("mario_terrain/images/blueBlock.png");
  ice.resize(32, 32);

  brick = loadImage("mario_terrain/images/brick.png");
  brick.resize(32, 32);

  lava = loadImage("mario_terrain/images/lava0.png");
  lava.resize(32, 32);

  dirtC = loadImage("mario_terrain/images/dirt_center.png");
  dirtC.resize(32, 32);

  dirtN = loadImage("mario_terrain/images/dirt_n.png");
  dirtN.resize(32, 32);

  dirtE = loadImage("mario_terrain/images/dirt_e.png");
  dirtE.resize(32, 32);

  dirtS = loadImage("mario_terrain/images/dirt_s.png");
  dirtS.resize(32, 32);

  dirtW = loadImage("mario_terrain/images/dirt_w.png");
  dirtW.resize(32, 32);

  dirtNE = loadImage("mario_terrain/images/dirt_ne.png");
  dirtNE.resize(32, 32);

  dirtNW = loadImage("mario_terrain/images/dirt_nw.png");
  dirtNW.resize(32, 32);

  dirtSE = loadImage("mario_terrain/images/dirt_se.png");
  dirtSE.resize(32, 32);

  dirtSW = loadImage("mario_terrain/images/dirt_sw.png");
  dirtSW.resize(32, 32);
  
  treeT = loadImage("mario_terrain/images/tree_trunk.png");
  treeT.resize(32, 32);
  
  treeC = loadImage("mario_terrain/images/tree_intersect.png");
  treeC.resize(32, 32);
  
  treeMid = loadImage("mario_terrain/images/treetop_center.png");
  treeMid.resize(32, 32);
  
  treeR = loadImage("mario_terrain/images/treetop_e.png");
  treeR.resize(32, 32);
  
  treeL = loadImage("mario_terrain/images/treetop_w.png");
  treeL.resize(32, 32);
  
  bridgeC = loadImage("mario_terrain/images/bridge_center.png");
  bridgeC.resize(32, 32);
  
  bridgeR = loadImage("mario_terrain/images/bridge_e.png");
  bridgeR.resize(32, 32);
  
  bridgeL = loadImage("mario_terrain/images/bridge_w.png");
  bridgeL.resize(32, 32);
  
  water = loadImage("mario_terrain/images/water1.png");
  water.resize(32, 32);
  
  thwSleep = loadImage("enemies and more/enemies and more/thwomp0.png");
  
  
  thwMad = loadImage("enemies and more/enemies and more/thwomp1.png");
 
  
 
  
  // ==============================================

  // SPRITES ======================================
  
  idle = new PImage[2];
  idle[0] = loadImage("Mario Sprites 1/imageReverser/idle0.png");
  idle[1] = loadImage("Mario Sprites 1/imageReverser/idle1.png");
   
  jump = new PImage[1];
  jump[0] = loadImage("Mario Sprites 1/imageReverser/jump0.png");
  
  run = new PImage[3];
  run[0] = loadImage("Mario Sprites 1/imageReverser/runright0.png");  
  run[1] = loadImage("Mario Sprites 1/imageReverser/runright1.png");  
  run[2] = loadImage("Mario Sprites 1/imageReverser/runright2.png");

  action = idle;


  // goomba
  goomba = new PImage[2];
  goomba[0] = loadImage("enemies and more/enemies and more/goomba0.png");
  goomba[0].resize(32, 32);
  goomba[1] = loadImage("enemies and more/enemies and more/goomba1.png");
  goomba[1].resize(32, 32);


  loadWorld(map);
  loadPlayer();
}

void loadWorld(PImage img) {
  world = new FWorld(-2000, -2000, 2000, 2000);
  world.setGravity(0, 900);

  for ( int y = 0; y < img.height; y++) {
    for ( int x = 0; x < img.width; x++) {
      color c = img.get(x, y);
      color n = img.get(x, y-1);
      color e = img.get(x+1, y);
      color s = img.get(x, y+1);
      color w = img.get(x-1, y);
      FBox b = new FBox(gridSize, gridSize);
      b.setPosition(x*gridSize, y*gridSize);

      if (c == black) {
        b.attachImage(brick);
        b.setName("brick");
        b.setStatic(true);
        b.setFriction(4);
        b.setGrabbable(false);
        world.add(b);
      }
      
       if (c == darkGray) {
        b.attachImage(brick);
        b.setName("wall");
        b.setStatic(true);
        b.setFriction(4);
        b.setGrabbable(false);
        world.add(b);
      }
      
      if  (c == blue) { // ice

        b.attachImage(ice);
        b.setName("ice");
        b.setStatic(true);
        b.setFriction(0);
        b.setGrabbable(false);
        world.add(b);
      }
      if (c == red) {
        b.attachImage(lava);
        b.setName("lava");
        b.setStatic(true);
        b.setFriction(4);
        b.setGrabbable(false);
        world.add(b);
      }
      if (c == dirtClr) {
        if (s == dirtClr && e == dirtClr && n == dirtClr && w == dirtClr) {
          b.attachImage(dirtC);
        } else if (s == dirtClr && e == dirtClr && n != dirtClr && w == dirtClr) {
          b.attachImage(dirtN);
        } else if (s == dirtClr && e != dirtClr && n == dirtClr && w == dirtClr) {
          b.attachImage(dirtE);
        } else if (s != dirtClr && e == dirtClr && n == dirtClr && w == dirtClr) {
          b.attachImage(dirtS);
        } else if (s == dirtClr && e == dirtClr && n == dirtClr && w != dirtClr) {
          b.attachImage(dirtW);
        } else if (s == dirtClr && e == dirtClr && n != dirtClr && w != dirtClr) {
          b.attachImage(dirtNW);
        } else if (s == dirtClr && e != dirtClr && n != dirtClr && w == dirtClr) {
          b.attachImage(dirtNE);
        } else if (s != dirtClr && e == dirtClr && n == dirtClr && w != dirtClr) {
          b.attachImage(dirtSW);
        } else if (s != dirtClr && e != dirtClr && n == dirtClr && w == dirtClr) {
          b.attachImage(dirtSE);
        } else {
          b.attachImage(dirtN);
        }
        b.setStatic(true);
        b.setFriction(4);
        b.setGrabbable(false);
        world.add(b);
        b.setName("dirt");
      }
      if (c == green) {
        if (e == green && w == green && s != treecolor) {
          b.attachImage(treeMid);
        } else if (e != green && w == green ) {
          b.attachImage(treeR);
        } else if (e == green && w != green) {
          b.attachImage(treeL);
        }  else if (s == treecolor) {
          b.attachImage(treeC);
        }
        b.setStatic(true);
        b.setFriction(4);
        b.setGrabbable(false);
        world.add(b);
        b.setName("tree");
    }
    if (c == treecolor) {
     b.attachImage(treeT); 
     b.setStatic(true);       
     b.setSensor(true);
     b.setGrabbable(false);
     world.add(b);
     b.setName("trunk");
    }
    
    if (c == bridge) {
     
     //b.attachImage(bridgeC);
     FBridge br = new FBridge(x*gridSize, y*gridSize);
     terrain.add(br);
     world.add(br);
     
    }
    
    if (c == goombaClr) {
     FGoomba gmb = new FGoomba(x*gridSize, y*gridSize);
     enemies.add(gmb);
     world.add(gmb);
    }
    
    if (c == tramp) {
     
    b.attachImage(water); 
     b.setStatic(true);       
     b.setSensor(false);
     b.setFriction(2);
     b.setGrabbable(false);
     b.setRestitution(1.3);
     world.add(b);
     b.setName("tramp");
     
    }
    
    if (c == thwClr) {
     FThwomp thw = new FThwomp(x*gridSize+16, y*gridSize+16);
     enemies.add(thw);
     world.add(thw);
    }
    
  }
}
}
void loadPlayer() {
  player = new FPlayer();
  
}

void draw() {
  background(white);
  drawWorld();
  actWorld();
  
}

void drawWorld() {
  pushMatrix();
  translate(-player.getX()*zoom+width/2, -player.getY()*zoom+height/2);
  scale(zoom);
  world.step();
  world.draw();
  popMatrix();
}

void actWorld() {
 player.act();
 for(int i = 0; i < terrain.size(); i++) {
  FGameObject t = terrain.get(i);
  t.act();
 }
 for(int i = 0; i < enemies.size(); i++) {
  FGameObject e = enemies.get(i);
  e.act();
 }
}
