Block[][] blocks; 

color[] pallet;

int fileNum = 1;
int xTiles;
int yTiles;

void setup() {
  size(600, 600);
  frameRate(30);
  noStroke();
  xTiles = width/100;
  yTiles = height/100;
  blocks = new Block[xTiles][yTiles];
  InitPallet();
  InitBlocks();
}

void draw() {

  int x = RnadInt(xTiles); 
  int y = RnadInt(yTiles);
  Block block = blocks[x][y];
  block.Redraw();
  SaveFrame();
}

void InitBlocks()
{
  for (int x = 0; x < xTiles; x ++)
  {
    for (int y =  0; y < yTiles; y ++)
    {
      blocks[x][y]= new Block(x, y, pallet);
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

void SaveFrame()
{
  if (keyPressed) {
    if (key == 's' || key == 'S') {
      String fileName = "samples/bauhaus1-"+NowString()+"-"+nf(fileNum++, 3)+".png";
      save(fileName);
      println("Saved frame: "+fileName);
    }
  }
}

String NowString() {
  return 
    nf(year(), 4)
    +nf(month(), 2)
    +nf(day(), 2) 
    +"-"
    +nf(hour(), 2)+"h"
    +nf(minute(), 2);
}

 void InitPallet() 
 {
   pallet = new color[8];
   pallet[0] = color(0, 0, 0);        // black
   pallet[1] = color(255, 255, 255);  // white
   pallet[2] = color(150, 150, 150);  // grey
   pallet[3] = color(230, 50, 40);    // red
   pallet[4] = color(20, 110, 170);   // blue
   pallet[5] = color(0, 130, 90);     // green
   pallet[6] = color(240, 200, 0);    // yellow
   pallet[7] = color(240, 140, 40);   // orange
 }
