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