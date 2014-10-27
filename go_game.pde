int boardSize = 9;  // Number of rows/columns on the board
int boardX = 200;  // X position of the board (top-left corner)
int boardY = 100;  // Y position of the board (top-left corner)
int boxSize = 50;  // Number of pixels between each line on the board
int stoneSize = (int)(0.8 * boxSize);  // Stone size as fraction of box size
int boardLength = boxSize * (boardSize - 1);  // Length of the board in pixels
int[][] board = new int[boardSize][boardSize];  // 0 - Empty, 1 - Black, 2 - White
public static final int EMPTY = 0;
public static final int BLACK = 1;
public static final int WHITE = 2;

void setup(){
	size(1000, 750);
	background(240);
	clearBoard();
	testInitGroup();
	drawBoard();	
}

void draw(){
  ellipse(0,0,10,10);
}

void clearBoard(){
	for (int i = 0; i < boardSize; i++){
		for (int j = 0; j < boardSize; j++){
			board[i][j] = EMPTY;
		}
	}	
}

void drawBoard(){
	fill(220, 179, 92);  // board color
	strokeWeight(2);
	rect(boardX, boardY, boardLength, boardLength);
	strokeWeight(1);
	for (int i = 0; i < boardSize; i++){
		line(boardX + i * boxSize, boardY, boardX + i * boxSize, boardY + boardLength);
		line(boardX, boardY + i * boxSize, boardX + boardLength, boardY + i * boxSize);
	}
	for (int i = 0; i < boardSize; i++){
		for (int j = 0; j < boardSize; j++){
			if (board[i][j] == BLACK) {	
				drawStone(i, j, BLACK);
			}
			else if (board[i][j] == WHITE) {
				drawStone(i, j, WHITE);	
			}
		}
	}
}

void drawStone(int xPos, int yPos, int player){
	if (player == BLACK) {
		fill(0);	
	}
	else {
		fill(255);	
	}
	ellipse(boardX + xPos * boxSize, boardY + yPos * boxSize, stoneSize, stoneSize);
}



////////TODO - move this to separate Group class////////
//depends on boardSize, board

public void testInitGroup(){
	boardSize = 5;
	board = new int[boardSize][boardSize];
	clearBoard();
	board[1][2] = BLACK;
	board[1][3] = BLACK;
	board[2][2] = BLACK;
	board[4][4] = BLACK;
	initGroup(1,2,BLACK);
	System.out.println("stones found:");
	for (int i = 0; i<listPos; i++){
		System.out.println(stones[i][0] + ", " + stones[i][1] );
	}
}


int [][] stones;
int listPos;
int xMin, xMax, yMin, yMax;
int who;

//TODO - make a function that checks if the group stored in "stones" is alive

public void initGroup(int xPos, int yPos, int whoInit){
	listPos = 0;
	stones = new int [boardSize*boardSize][2];
	xMin = 0;
	xMax = boardSize-1;
	yMin = 0;
	yMax = boardSize-1;
	who = whoInit;
	findGroupRecursively(xPos, yPos);
}

public void findGroupRecursively(int xPos, int yPos){
	//System.out.println("DEBUG begin findGroupRecursively" + xPos + ", " + yPos);
	
	boolean checksPass = true;

	//check if stone at this location is proper color
	if(who != board[xPos][yPos]){
		checksPass = false;
	}
	//System.out.println("DEBUG checks" + who + ", " + board[xPos][yPos]);


	//check if stone is in range
	if(xPos < xMin || xMax < xPos || yPos < yMin || yMax < yPos){
		checksPass = false;
	}
	
	//check that location is not already in list
	for(int i = 0; i<listPos; i++){
		if (xPos == stones[i][0] && yPos == stones[i][1]){
			checksPass = false;
		}
	}
		
	if(checksPass){
		//add location to list and run function on each neighboring location
		stones[listPos][0] = xPos;
		stones[listPos][1] = yPos;
		listPos++;
		findGroupRecursively(xPos+1, yPos);
		findGroupRecursively(xPos-1, yPos);
		findGroupRecursively(xPos, yPos+1);
		findGroupRecursively(xPos, yPos-1);
		
	}

}




