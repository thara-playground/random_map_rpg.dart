part of random_map_rpg;

const int CELL_ATR_WATER = 0;
const int CELL_ATR_GROUND = 1;

class Field {
  
  final int sizeX;
  final int sizeY;
  final List<int> fields;
  
  Field(int sizeX, int sizeY)
    : this.sizeX = sizeX,
      this.sizeY = sizeY,
      this.fields = new List(sizeX * sizeY);
  
  void setCellAttr(int x, int y, int atr) {
    if (x >= 0 && x < sizeX && y >= 0 && y < sizeY) {
      fields[x + y * sizeX] = atr;
    }
  }
  
  int getCellAttr(int x, int y) {
    if (x >= 0 && x < sizeX && y >= 0 && y < sizeY) {
      return fields[x + y * sizeX];
    } else {
      return CELL_ATR_WATER;
    }
  }
  
  void generateMap() {
    
    var random = new math.Random();
    
    for (var y = 0; y < sizeY; y++) {
      for (var x = 0; x < sizeX; x++) {
        var attr = 
            (random.nextDouble() < 0.8) ?CELL_ATR_GROUND : CELL_ATR_WATER;
        setCellAttr(x, y, attr);
      }
    }
    
  }
}