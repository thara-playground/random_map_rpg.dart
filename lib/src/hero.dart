part of random_map_rpg;

const int INIT_MONEY = 500;

class Hero {
  
  int _x;
  int _y;
  int _walkCount;
  int _money;
  
  Hero() {
    init();
  }
  
  void init() {
    _x = 0;
    _y = 0;
    _walkCount = 0;
    _money = INIT_MONEY;
  }
  
  void setPosition(int x, int y) {
    this._x = x;
    this._y = y;
  }
  
  void setPositionRandom(int fieldSizeX, int fieldSizeY) {
    var random = new math.Random();
    setPosition(
        (random.nextDouble() * fieldSizeX).floor(),
        (random.nextDouble() * fieldSizeY).floor());
  }
  
  int get x => _x;
  int get y => _y;
  
  int get walkCount => _walkCount;
  
  void walk(int dx, int dy) {
    _x += dx;
    _y += dy;
    _walkCount++;
  }
  
  void addMoney(int m) {
    _money += m;
  }
  
  int get money => _money;
  
  int get gain => money - INIT_MONEY;
}