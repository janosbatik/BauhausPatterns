Block[][] blocks; 


int xTiles = 8;
int yTiles= 6;

void setup() {
  size(800, 600);
  frameRate(30);
  noStroke();
  blocks = new Block[xTiles][yTiles];
  InitBlocks();
}

void draw() {

  int x = RnadInt(xTiles); 
  int y = RnadInt(yTiles);
  Block block = blocks[x][y];
  block.Redraw();
}

void InitBlocks()
{
  for (int x = 0; x < xTiles; x ++)
  {
    for (int y =  0; y < yTiles; y ++)
    {
      blocks[x][y]= new Block(x, y);
      blocks[x][y].Draw();
    }
  }
  for (int x = 0; x < xTiles; x ++)
  {
    for (int y =  0; y < yTiles; y ++)
    {
      blocks[x][y].up = GetBlock(x, y + 1 );
      blocks[x][y].down = GetBlock(x, y - 1 );
      blocks[x][y].left = GetBlock(x - 1, y );
      blocks[x][y].right = GetBlock(x +1, y );
    }
  }
}

int RnadInt(int n)
{
  return floor(random(n));
}

Block GetBlock(int x, int y)
{
  if (x < 0 || x >= xTiles)
    return null;
  if (y < 0 || y >= yTiles)
    return null;
  return blocks[x][y];
}
