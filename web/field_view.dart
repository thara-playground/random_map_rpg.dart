part of web_rpg;

const int CELL_VIEW_SIZE_X = 12;
const int CELL_VIEW_SIZE_Y = 24;

class ImageObj {
  
  String _src;
  
  final ImageElement image;
  
  ImageObj(String src)
    : this._src = src,
      this.image = new ImageElement(src:src) {
    this.image.style.position = "absolute";
    query("#main").children.add(image);
  }
  
  void destroy() {
    image.remove();
  }
  
  void setPosition(int x, int y) {
    image.style.left = "${x}px";
    image.style.top = "${y}px";
  }
  
  void setSrc(String src) {
    if (this._src != src) {
      this._src = src;
      this.image.src = src; 
    }
  }
}

class FieldView {
  
  final Field field;
  final Hero hero;
  
  int sizeX;
  int sizeY;
  
  List<ImageObj> images;
  
  FieldView(this.field, this.hero) {
    sizeX = field.sizeX;
    sizeY = field.sizeY;
    images = new List(sizeX * sizeY);
    
    for (var y = 0; y < this.sizeY; y++) {
      for (var x = 0; x < this.sizeX; x++) {
        var index = x + y * this.sizeX;
        images[index] = new ImageObj("blue.gif")
                          ..setPosition(x * CELL_VIEW_SIZE_X,
                                          y * CELL_VIEW_SIZE_Y);
        
      }
    }
  }
  
  void update() {
    for (var y = 0; y < this.sizeY; y++) {
      for (var x = 0; x < this.sizeX; x++) {
        
        var cellSrc;
        if (x == hero.x && y == hero.y) {
          cellSrc = "red.gif";
        } else {
          var atr = field.getCellAttr(x, y);
          if (atr == CELL_ATR_GROUND) {
            cellSrc = "green.gif";
          } else if (atr == CELL_ATR_WATER) {
            cellSrc = "blue.gif";
          }
        }
        
        this.images[x + y * this.sizeX].setSrc(cellSrc);
      }
    }
  }
}
