class FPlayer extends FGameObject {

  FBox feet;
  FBox rightSide;
  FBox leftSide;

  int frame;
  int direction;


  FPlayer() {

    super();
    noStroke();
    frame = 0;
    direction = R;
    setPosition(400, 0);
    setRotatable(false);
    setFillColor(gray);
    setRestitution(0);
    setName("player");

    feet = new FBox(26, 8);
    feet.setRotatable(false);
    feet.setSensor(true);
    feet.setStatic(false);
    feet.setFillColor(white);

    rightSide = new FBox(6, 16);
    rightSide.setRotatable(false);
    rightSide.setSensor(true);
    rightSide.setStatic(false);
    rightSide.setFillColor(white);

    leftSide = new FBox(6, 16);
    leftSide.setRotatable(false);
    leftSide.setSensor(true);
    leftSide.setStatic(false);
    leftSide.setFillColor(white);

    world.add(this);
    world.add(feet);
    world.add(rightSide);
    world.add(leftSide);
  }

  void act() {
    handleInput();
    animate();
    collisions();
  }

  void handleInput() {
    float vy = getVelocityY();
    float vx = getVelocityX();

    if (direction == R) {
      vx = min(vx, 225);
    } else vx = max(vx, -225);

    if (canJump == true) {
      action = idle;
    }
    if (akey) {
      if (canJump == false) {
        setVelocity(vx-10, vy);
      } else setVelocity(-195, vy);
      action = run;
      direction = L;
    }
    if (dkey) {
      if (canJump == false) {
        setVelocity(vx+10, vy);
      } else setVelocity(195, vy);
      action = run;
      direction = R;
    }

    if (wkey) {
      if (canJump == true) {
        setVelocity(vx, -450);
        WJT = 30;
      } else if (rsJump == true && WJT == 0) {
        setVelocity(-200, -300);
      } else if (lsJump == true && WJT == 0) {
        setVelocity(200, -300);
      }
    }


    if (abs(vy) > 0.3)
      action = jump;
  }


  void collisions() {
    if (isTouching("lava")) {
      setPosition(0, 0);
    }

    float x = getX();
    float y = getY();

    float vy = getVelocityY();
    float vx = getVelocityX();

    feet.setPosition(x, y+16);
    feet.setVelocity(getVelocityX(), getVelocityY());

    ArrayList<FContact> fcontacts = feet.getContacts();
    if (fcontacts.size() >2) {
      canJump = true;
    } else canJump = false;
    // println(fcontacts.size());


    rightSide.setPosition(x+14, y);
    rightSide.setVelocity(getVelocityX(), getVelocityY());
if (WJT == 0) {
    ArrayList<FContact> rscontacts = rightSide.getContacts();
    if (rscontacts.size() >3) {
      if  (fcontacts.size() < 3) {
        if (dkey) {
          player.setVelocity(vx, 90);
          rsJump = true;
        }
      }
    } else rsJump = false;
  }
    if (canJump == true && rsJump == true) {
      rsJump = false;
    }
  


    leftSide.setPosition(x-14, y);
    leftSide.setVelocity(getVelocityX(), getVelocityY());
 if (WJT == 0) {
    ArrayList<FContact> lscontacts = leftSide.getContacts();
    if (lscontacts.size() >3) {
      if  (fcontacts.size() < 3) {
        if (akey) {
          player.setVelocity(vx, 90);
          lsJump = true;
        }
      }
    } else lsJump = false;
  }
    
    if (canJump == true && lsJump == true) {
      lsJump = false;
    }
    
    WJT--;
    WJT = max(WJT, 0);
    println(WJT);
  }

  void animate() {

    if (frame >= action.length) frame = 0;
    if (frameCount % 5 == 0) {
      if (direction == R) attachImage(action[frame]);
      if (direction == L) attachImage(reverseImage(action[frame]));
      frame++;
    }
  }
}
