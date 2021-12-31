class Block
{
  Block up;
  Block down;
  Block left;
  Block right;
  Block[] neigbours = new Block[4];


  float x;
  float y;
  float size = 100;
  color primaCol;
  color secCol;
  IntList radomOrder =  new IntList();
  float arcRatio = 0.75;
  Type type;

  Block(float _x, float _y)
  {
    Setup(_x, _y, null);
  }

  Block(float _x, float _y, color[] pallet)
  {
    if (pallet.length < 2)
      throw new IllegalArgumentException("Pallet must have more than 2 colours"); 
    Setup(_x, _y, pallet);
  }

  void Setup(float _x, float _y, color[] pallet)
  {
    x =_x; 
    y = _y;
    type = Type.values()[floor(random(Type.values().length))];
    SetArrays();
    SetColours(pallet);
  }
  void SetArrays()
  {        
    for (int i = 0; i < 4; i++)
      radomOrder.append(i);
  }

  void SetColours(color[] pallet)
  {
    if (pallet == null) {
      primaCol= RandomColour();
      secCol= RandomColour();
    } else {
      int primColInd =  floor(random(pallet.length));
      int secColInd = floor(random(pallet.length));
      while (secColInd == primColInd)
        secColInd = floor(random(pallet.length));
      primaCol = pallet[primColInd];
      secCol= pallet[secColInd];
    }
  }

  color RandomColour()
  {
    return color( random(0, 255), random(0, 255), random(0, 255));
  }

  void Redraw()
  {
    neigbours[0] = up; 
    neigbours[1] = down; 
    neigbours[2] = left; 
    neigbours[3] = right; 
    radomOrder.shuffle();

    boolean  isGoodBlock= false;

    for (int i : radomOrder)
    {
      if (neigbours[i] == null)
        continue;
      if ( TypeMatch(neigbours[i]) > random(1))
      {
        //println("Colour Match x:" + x + " y:"+y + " with neighbour x:"+neigbours[i].x+ " y:"+neigbours[i].y );
        isGoodBlock = true;
        ColourMatch(neigbours[i]);
        Draw();
        break;
      }
    }

    if (!isGoodBlock || random(1) > 0.9)
    {
      //println("Swap Block x:" + x + " y:"+y);
      SwapBlock();
      Draw();
    }
  }

  void ColourMatch(Block neigbour)
  {
    if (random(1) > 0.5)
    {
      primaCol = neigbour.primaCol;
    }
    if (random(1) > 0.75)
    {
      secCol = neigbour.secCol;
    }
  }
  boolean ChooseArc()
  {
    return random(1) < arcRatio;
  }
  void SwapBlock()
  {
    radomOrder.shuffle();
    boolean swapped = false;
    for (int i : radomOrder)
    {
      if (neigbours[i] == null)
      {
        Print("Null neighbour at SwapBlock");
        continue;
      }
      switch(i) {
      case 0: // up
        swapped = MatchUp();
        break;
      case 1: // down
        swapped = MatchDown();
        break;
      case 2: // left
        swapped = MatchLeft();
        break;
      case 3: // right
        swapped = MatchRight();
        
      }
      if (swapped)
      {
        ColourMatch(neigbours[i]);
        break;
      }
    }
    
  }

  boolean MatchUp()
  {
    switch(up.type) {
    case TOP_LEFT_ARC: // top left arc
      type = ChooseArc() ? Type.BOTTOM_RIGHT_ARC : Type.VERT_SPLIT;
      return true;
    case TOP_RIGHT_ARC: // top right arc
      type = ChooseArc() ? Type.BOTTOM_RIGHT_ARC : Type.VERT_SPLIT;
      return true;
    case VERT_SPLIT: 
      type = ChooseArc() ? random(1)> 0.5 ? Type.BOTTOM_RIGHT_ARC : Type.BOTTOM_LEFT_ARC : Type.VERT_SPLIT;
      return true;
    default:
      Print("No Up Match");
      return false;
    }
  }


  boolean MatchDown()
  {
    switch(down.type) {
    case BOTTOM_RIGHT_ARC: // bottom right arc
      type = ChooseArc() ? Type.TOP_RIGHT_ARC : Type.VERT_SPLIT;
      return true;
    case BOTTOM_LEFT_ARC: // bottom left arc
      type = ChooseArc() ? Type.TOP_LEFT_ARC : Type.VERT_SPLIT;
      return true;
    case VERT_SPLIT: 
      type = ChooseArc() ? random(1)> 0.5 ? Type.TOP_RIGHT_ARC : Type.TOP_LEFT_ARC : Type.VERT_SPLIT;
      return true;
    default:
      Print("No Down Match");
      return false;
    }
  }

  boolean MatchLeft()
  {
    switch(left.type) {

    case BOTTOM_LEFT_ARC: // bottom left arc
      type = ChooseArc() ? Type.BOTTOM_RIGHT_ARC : Type.HORI_SPLIT;
      return true;
    case TOP_LEFT_ARC: // top left arc
      type = ChooseArc() ? Type.TOP_RIGHT_ARC : Type.HORI_SPLIT;
      return true;
    case HORI_SPLIT: 
      type = ChooseArc() ? random(1)> 0.5 ? Type.TOP_RIGHT_ARC : Type.BOTTOM_RIGHT_ARC : Type.HORI_SPLIT;
      return true;
    default:
      Print("No Left Match");
      return false;
    }
  }
  boolean MatchRight()
  {
    switch(right.type) {
    case BOTTOM_RIGHT_ARC: // bottom right arc
      type = Type.BOTTOM_LEFT_ARC;
      return true;
    case TOP_RIGHT_ARC: // top right arc
      type = Type.TOP_LEFT_ARC;
      return true;
    case HORI_SPLIT: 
      type = ChooseArc() ? random(1)> 0.5 ? Type.TOP_LEFT_ARC : Type.BOTTOM_LEFT_ARC : Type.HORI_SPLIT;
      return true;
    default:
      Print("No Right Match");
      return false;
    }
  }

  /*
  void FlipMatch(Block neigbour)
   {
   type = Type.values()[floor(random(5))];
   }
   */
  float TypeMatch(Block neigbour) {
    return 0.75;
  }
  /*
  float TypeMatch(Block neigbour)
   {
   if (neigbour == null)
   return 0;
   switch(type) {
   case BOTTOM_RIGHT_ARC: // bottom right arc
   if ( (neigbour.type == Type.BOTTOM_LEFT_ARC) || (neigbour.type == Type.TOP_RIGHT_ARC) )
   return 0.95;
   else if ((neigbour.type == Type.TOP_LEFT_ARC) ||  neigbour.type == Type.HORI_SPLIT)
   return 0.5;
   else
   return 0.2;
   case BOTTOM_LEFT_ARC: // bottom left arc
   if ( (neigbour.type == Type.BOTTOM_RIGHT_ARC) || (neigbour.type == Type.TOP_LEFT_ARC) )
   return 0.95;
   else if ((neigbour.type == Type.TOP_RIGHT_ARC) ||  neigbour.type == Type.HORI_SPLIT)
   return 0.5;
   else
   return 0.2;
   case TOP_LEFT_ARC: // top left arc
   if ( (neigbour.type == Type.BOTTOM_RIGHT_ARC) || (neigbour.type == Type.TOP_LEFT_ARC) )
   return 0.95;
   else if ((neigbour.type == Type.TOP_RIGHT_ARC) ||  neigbour.type == Type.HORI_SPLIT)
   return 0.5;
   else
   return 0.2;
   case TOP_RIGHT_ARC: // top right arc
   if ( (neigbour.type == Type.BOTTOM_RIGHT_ARC) || (neigbour.type == Type.TOP_LEFT_ARC) )
   return 0.95;
   else if ((neigbour.type == Type.TOP_RIGHT_ARC) ||  neigbour.type == Type.HORI_SPLIT)
   return 0.5;
   else
   return 0.2;
   case HORI_SPLIT:
   return 1;
   }
   return 0;
   }
   
   */

  void Draw()
  {

    fill(primaCol);
    rect(x * size, y * size, size, size);

    switch(type) {
    case BOTTOM_RIGHT_ARC: // bottom right arc
      DrawArc(x, y, 0, HALF_PI);
      break;
    case BOTTOM_LEFT_ARC: // bottom left arc
      DrawArc(x+1, y, HALF_PI, PI);
      break;
    case TOP_LEFT_ARC: // top left arc
      DrawArc(x+1, y+1, PI, HALF_PI + PI);
      break;
    case TOP_RIGHT_ARC: // top right arc
      DrawArc(x, y+1, HALF_PI + PI, TWO_PI);
      break;
    case VERT_SPLIT:
      fill(secCol);
      rect(x * size, y * size, size/2, size);
      break;
    case HORI_SPLIT:
      fill(secCol);
      rect(x * size, y * size, size, size/2);
      break;
    }
  }

  void DrawArc(float xO, float yO, float startAng, float stopAng)
  {
    fill(secCol);
    arc(xO * size, yO * size, 2*size, 2*size, startAng, stopAng);
    fill(primaCol);
    arc(xO * size, yO * size, size, size, startAng, stopAng);
  }
  void Print(String str)
  {
    //println(str);
  }
}

enum Type 
{
  BOTTOM_LEFT_ARC, 
    BOTTOM_RIGHT_ARC, 
    TOP_LEFT_ARC, 
    TOP_RIGHT_ARC, 
    HORI_SPLIT, 
    VERT_SPLIT
}
