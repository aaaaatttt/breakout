import processing.sound.*;     

SoundFile file; 
SoundFile startSound;      // Game start sound
SoundFile endSound;        // Game end sound
Ball ball;

Paddle paddle;
Block[][] block;
int rows, columns, score, lives, level;
PImage bg;
boolean isPaused = false;
boolean gameOver = false;  // Flag to track if the game is over
boolean gameStarted = false; // Flag to track if the game has started

void setup(){
  size(1000,700);
  textSize(24);
  level = 0;
  score=0;
  lives = 3;  
  rows = 3;
  columns = 8;
  makeLevel(columns,rows);
  file = new SoundFile(this, "song.mp3");
  startSound = new SoundFile(this, "game_start.mp3");
  endSound = new SoundFile(this, "game_end.mp3");
  // Play start sound as soon as the game opens
  startSound.play();
  // Load background image
  bg = loadImage("background.jpg");
}

void draw(){
  //background(0);
  image(bg, 0, 0, width, height);
  // If the game hasn't started, display "Click to start" message
  if (!gameStarted) {
    fill(255, 0, 255);
    textSize(36);
    textAlign(CENTER);
    text("Click anywhere to start the game!", width / 2, height / 2);
    return;  // Don't proceed with the rest of the game until the player clicks
  }
  // Check if the game is paused
  if(!isPaused && !gameOver && gameStarted){
    ball.display();
    ball.checkPaddle(paddle);
    paddle.display();
    showBlocks();
    moveBricks();
   
  }
  showLives();
  showScore();  
  checkLevel();
  showLevel();
  // If the game is paused, display the pause message
  if(isPaused && !gameOver && gameStarted){
    fill(255, 0, 255);
    text("Game Paused. Press 'P' to resume.", width/2 - 150, height/2);
  }
  // Handle game over state
  if (gameOver) {
    //noLoop();
    fill(255, 0, 0);
    textSize(36);
    text("Game Over!", width / 2 - 100, height / 2);
    textSize(24);
    text("Click anywhere to restart", width / 2 - 100, height / 2 + 50);
  }
}
void moveBricks() {
  if (level >= 2){
  for (int i = 0; i < block.length; i++) {
    for (int j = 0; j < block[0].length; j++) {
      if (i % 2 == 0) {  // Only move certain rows (e.g., every second row)
        block[i][j].x += sin(frameCount * 0.05) * 2; // Oscillate left and right
      }
    }
  }
 }

}

void keyPressed(){
  // Toggle the pause state when the 'P' key is pressed
  if(key == 'P' || key == 'p'){
    isPaused = !isPaused;
  }
}

void showLevel(){
  fill(255, 0, 255); // Set text color
  text("Level: " + level, width / 2 - 50, height - 10); // Display the current level at the bottom center
}

void showScore(){
  strokeWeight(2);
  fill(255,0,255);
  text("Score: " + score, width - 140, height - 10); 
}

void showLives(){
  fill(255,0,255);  
  text("Lives: " + lives, 40, height - 10);  
  if(lives == 0&& !gameOver) {
    gameOver = true;  // Set the game over flag

    // Stop the background music
    file.stop();
    
    // Play the game over sound
    endSound.play(); 
  }
}
void checkLevel(){
  if(clearBlocks()){
    ball.canMove = false;
    ball.y = paddle.y - ball.d/2;    
    fill(0);
    rect(190, height/2 + 130, 400, 30);
    rect(250, height/2 + 160, 400, 30);    
    fill(255,0,255);  
    text("You Cleared all the blocks!" , 200, height/2+152);
    text("Click anywhere to continue" , 260, height/2+182); 
    if(mousePressed){
      if(level%2==0){
        rows *= 2;
      } else {
        columns *= 2;
      }
      makeLevel(columns,rows); 
      // Increase ball speed after each level up      
      ball.Vx *= 1.05; // Increase the ball's horizontal velocity by 5%
      ball.Vy *= 1.05; // Increase the ball's vertical velocity by 5%
      // Cap the speed so it's not too fast
      float maxSpeed = 40;
      if (ball.Vx > maxSpeed) {
        ball.Vx = maxSpeed;
      }
      if (ball.Vy > maxSpeed) {
        ball.Vy = maxSpeed;
      }
      ball.canMove = true;      
    }
  }
}
void showBlocks(){
  for(int i = 0; i < block.length; i++){
    for(int j = 0; j < block[0].length; j++){
      block[i][j].display();
      block[i][j].checkBall(ball);
    }
  }  
}

void makeLevel(int rows, int columns){
  ball = new Ball();  // Create single ball
  paddle = new Paddle();
  block = new Block[rows][columns];
  for(int i = 0; i < block.length; i++){
    for(int j = 0; j < block[0].length; j++){
      block[i][j] = new Block(i,j+5,block.length);
    }
  }
  level++;
}

boolean clearBlocks(){
  for(int i = 0; i < block.length; i++){
    for(int j = 0; j < block[0].length; j++){
      if(block[i][j].status){
        return false;  
      }
    }
  }
  return true;
}

void mousePressed(){
   if (!gameStarted) {
     //startSound.play();
     // Start the game when the player clicks
    gameStarted = true; 
    file.loop();
    return;
  }
  if(lives > 0 && !isPaused && !gameOver){    
    ball.y -= 5;
    ball.canMove = true;     
  } else if (gameOver) {
    // Reset game when user clicks after game over
    gameOver = false;
    gameStarted = true;
    setup();
    file.loop();
  } 
}
