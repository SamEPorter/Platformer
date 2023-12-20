class FThwomp extends FGameObject {
 
  final int sleepy = 1;
  final int fall = 2;
  final int rise = 3;
  int thwMode = sleepy;
  
  FThwomp(float x, float y) {
    super();
    setPosition(x, y);
    setName("thwomp");
    setRotatable(false);
    setStatic(true);
  }
  
  
 
 
 
 void act() {
  animate();
  collide();
  move();
 }
 
 
 void animate() {
   if (thwMode == sleepy || thwMode == rise) attachImage(thwSleep);
   if (thwMode == fall) attachImage(thwMad);
 }
 
 void collide() {
   
 }
 
 void move() {
   
 }
}
