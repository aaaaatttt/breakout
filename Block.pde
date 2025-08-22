public class Block{
    private float x, y, w, h;
    private int numBlocks;  //CHANGED FROM EPISODE 3
    private boolean status;
    private int r, g, b;
    private boolean isSpecial; // New flag to mark a special block
    private int specialEffect;  // 0 = None, 1 = Increase Paddle, 2 = Decrease Paddle, 3 = Increase Lives, 4 = Decrease Lives, 5 = Destroy Surrounding Bricks
    private int hitsRequired; // How many hits are needed to destroy this block
    private int currentHits;  // How many times the block has been hit
    
    public Block(){
      x = 0;
      numBlocks = 6;
      y = 0;
      w = width / numBlocks;
      h = 30;
    }
    public Block(int col, int row, int theNumBlocks){
      numBlocks = theNumBlocks;
      w = width / numBlocks;
      h = 30;
      x = w * col;
      y = h * row;
      setColors(row, col);
      status = true;
      hitsRequired = (int)random(1, 3);  // Randomly set between 1 and 2 hits
      currentHits = 0;
      // 40% chance of being a special block
        if (random(1) < 0.4) {
            isSpecial = true;
            specialEffect = (int)random(1, 6); // Randomly select one of 5 special effects
        } else {
            isSpecial = false;
            specialEffect = 0; // No special effect
        }
    }
      
    public void setColors(int col, int row){
        b = 250;
        if(col%9==0){
          r = 50;
        } else if (col%9==1){
          r = 100;
        } else if (col%9==2){
          r = 150;
        } else if (col%9==3){
          r = 200;
        } else if (col%9==4){ 
          r = 250;
        } else if (col%9==5){
          r = 200;
        } else if (col%9==6){
          r = 150;
        } else if (col%9==7){
          r = 100;
        } else if (col%9==8){ 
          r = 50;
        }
        
        if(row%2==0){
          g = 70;
          b = 150;
        }
    }
    public void display(){
      stroke(0);
      strokeWeight(1);
      if (isSpecial) {
            fill(255, 0, 0); // Special bricks are red
        } else {            
             // Color darkens with each hit
            fill(r - (currentHits * 50), g - (currentHits * 50), b - (currentHits * 50));
        }
      
      if(status){
        rect(x,y, w, h, 10);
        fill(255,255,0);
        rect(x+8, y+8, w-16, h-16, 2);
        fill(r,g,b);
        rect(x+10, y+10, w-20, h-20, 3);
        
        /*// Display remaining hits
        fill(0);
        textSize(12);
        text(hitsRequired - currentHits, x + w / 2 - 5, y + h / 2 + 5);  // Display remaining hits*/
      }
    }
    
    public void checkBall(Ball ball){
       if(status){
         boolean collisionDetected = false;
        
         //Bottom
         if(ball.x > x && ball.x < x+w && ball.y < (y+h+ball.d/2)&& ball.y>y+h){
           ball.Vy*=-1;
           collisionDetected = true;
         }
         //Top
         if(ball.x > x && ball.x < x+w && ball.y > y-ball.d/2 && ball.y < y){
           ball.Vy*=-1;
           collisionDetected = true;
         }
         //Left
         if(ball.x > x - ball.d/2 && ball.y > y && ball.y < y+h && ball.x < x){
           ball.Vx*=-1;
           collisionDetected = true;
         }
         //Right
         if(ball.x > x+w  && ball.y > y && ball.y < y+h && ball.x<x+w+ball.d/2){
           ball.Vx*=-1;
           collisionDetected = true;
         } 
         if (collisionDetected) {
           // Increment currentHits and check if block is destroyed
           currentHits++;
           if (currentHits >= hitsRequired) {
              status = false;  // Block is destroyed
              // Check if the block is special and adjust score
              if (isSpecial) {
                score += 5;  // Special block, increase score by 5
                } else {
                   score++;  // Regular block, increase score by 1
                }
              applySpecialEffect();  // Apply special effect if it's a special block
            }
         }
       
       }
    }
 
    
    // New function to handle the special effect
    private void applySpecialEffect() {
        if (isSpecial) {
            switch (specialEffect) {
                case 1: 
                    increasePaddleSize();
                    break;
                case 2: 
                    decreasePaddleSize();
                    break;
                case 3: 
                    increaseLives();
                    break;
                case 4: 
                    decreaseLives();
                    break;
                case 5: 
                    destroySurroundingBricks();
                    break;
            }
        }
    }

    // Effect: Increase Paddle Size
    private void increasePaddleSize() {
        paddle.w += 50;
        if (paddle.w > 300) {
            paddle.w = 300; // Cap the paddle size
        }
    }

    // Effect: Decrease Paddle Size
    private void decreasePaddleSize() {
        paddle.w -= 50;
        if (paddle.w < 50) {
            paddle.w = 50; // Minimum paddle size
        }
    }

    // Effect: Increase Lives
    private void increaseLives() {
        lives += 2;
    }

    // Effect: Decrease Lives
    private void decreaseLives() {
        lives--;
        if (lives < 0) {
            lives = 0;
            noLoop();
        }
    }

    // Effect: Destroy Surrounding Bricks
    private void destroySurroundingBricks() {
        for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
                int row = (int)(y / h); // Convert y position to row index
                int col = (int)(x / w); // Convert x position to column index

                int newRow = row + i;
                int newCol = col + j;

                // Ensure the neighboring block is within bounds
                if (newRow >= 0 && newRow < block.length && newCol >= 0 && newCol < block[0].length) {
                    block[newRow][newCol].status = false;
                }
            }
        }
    }
}
