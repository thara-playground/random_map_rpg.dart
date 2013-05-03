part of web_rpg;

class GameMode implements Listener {
  
  Field field;
  Hero hero;
  
  FieldView fieldView;
  HeroStateView heroState;
  
  BattleMode battleMode;
  GameOverMode gameOverMode;
  
  KeyManager keyManager;
  
  GameMode() {
    
    this.field = new Field(FIELD_SIZE_X, FIELD_SIZE_Y);
    field.generateMap();
    
    this.hero = new Hero();
    hero.setPositionRandom(FIELD_SIZE_X, FIELD_SIZE_Y);
    this.initHeroPosition();
    
    this.fieldView = new FieldView(field, hero);
    fieldView.update();
    
    this.heroState = new HeroStateView(hero);
    heroState.update();
    
    keyManager = new KeyManager();
    
    battleMode = new BattleMode(hero, keyManager);
    gameOverMode = new GameOverMode(hero, keyManager);
    
    keyManager.addListener(this);
  }
  
  void initHeroPosition() {
    for(;;) {
      hero.setPositionRandom(FIELD_SIZE_X, FIELD_SIZE_Y);
      
      // 四方に一つでも陸地があるならＯＫ、無いなら位置の設定をやりなおし
      var x = hero.x;
      var y = hero.y;
      if (field.getCellAttr(x + 1, y) == CELL_ATR_GROUND
          || field.getCellAttr(x - 1, y) == CELL_ATR_GROUND
          || field.getCellAttr(x, y + 1) == CELL_ATR_GROUND
          || field.getCellAttr(x, y - 1) == CELL_ATR_GROUND) {
        break;
      }
    }
  }
  
  bool onKeyDown(int keyCode) {
    var oldX = hero.x;
    var oldY = hero.y;
    
    var newX = oldX;
    var newY = oldY;
    
    if (keyCode == "6".codeUnits[0] || keyCode == 39 || keyCode == 102) {
      newX++;
    } else if (keyCode == "4".codeUnits[0] || keyCode == 37 || keyCode == 100) {
      newX--;
    } else if (keyCode == "2".codeUnits[0] || keyCode == 40 || keyCode == 98) {
      newY++;
    } else if (keyCode == "8".codeUnits[0] || keyCode == 38 || keyCode == 104) {
      newY--;
    }
    
    if (newX != oldX || newY != oldY) {
      // rule1.移動不可能地形制約（画面外、水へは移動できない）。移動可能なら移動する
      if (newX < 0 || newX >= field.sizeX || newY < 0 || newY >= field.sizeY) {
        return false; // 画面外
      }
      if (field.getCellAttr(newX, newY) != CELL_ATR_GROUND) {
        return false; // 地面属性以外
      }
      hero.walk(newX - oldX, newY - oldY);
      
      // rule2.移動元の地形属性は水になる
      field.setCellAttr(oldX, oldY, CELL_ATR_WATER);
      
      // rule3.移動後、上下左右が全て移動不可能地形の場合ゲームオーバー
      if (field.getCellAttr(newX + 1, newY) != CELL_ATR_GROUND
          && field.getCellAttr(newX - 1, newY) != CELL_ATR_GROUND
          && field.getCellAttr(newX, newY + 1) != CELL_ATR_GROUND
          && field.getCellAttr(newX, newY - 1) != CELL_ATR_GROUND) {
        var score = (hero.gain + hero.walkCount * 20) * 5;
        this.gameOverMode.start(this.onGameOverEnd);
      } else if (encount.nextDouble() < 0.15) {
        // rule4.移動後、ある確率で敵が出現する
        this.battleMode.start(this.onBattleEnd);
      }
      
    }
    
    fieldView.update();
    
    return true;
  }
  
  bool onKeyUp(int keyCode) => true;
  
  void onBattleEnd() {
    heroState.update();
  }
  
  void onGameOverEnd() {
    field.generateMap();
    hero.init();
    initHeroPosition();
    
    fieldView.update();
    heroState.update();
  }
}

typedef void OnButtleEnd();

class BattleMode implements Listener {
  
  final Hero _hero;
  final KeyManager _keyManager;
  OnButtleEnd _onButtleEnd;
  
  String _state;
  
  TextObj _strApper;
  TextObj _strEnemy;
  TextObj _strHero;
  TextObj _strResult;
  
  int _enemyPower;
  int _heroPower;
  
  Timer _timer;
  
  BattleMode(this._hero, this._keyManager) {
    _state = "ready";
    
    _strApper = new TextObj("敵が現れた！");
    _strEnemy = new TextObj("敵の強さ   :");
    _strHero = new TextObj("あなたの強さ:");
    _strResult = new TextObj("0G手に入れた！");
    
    _strApper.setVisible(false);
    _strEnemy.setVisible(false);
    _strHero.setVisible(false);
    _strResult.setVisible(false);
    
    _strApper.setPosition(20, 50);
    _strEnemy.setPosition(20, 50 + 22);
    _strHero.setPosition(20, 50 + 22 * 2);
    _strResult.setPosition(20, 50 + 22 * 4);
    
    _strApper.setFontWeight("bold");
    _strEnemy.setFontWeight("bold");
    _strHero.setFontWeight("bold");
    _strResult.setFontWeight("bold");
    
    _strApper.setColor(255, 255, 255);
    _strEnemy.setColor(255, 255, 255);
    _strHero.setColor(255, 255, 255);
    _strResult.setColor(255, 255, 255);    
  }
  
  void setEnemyPowerRandom() {
    _enemyPower = (new math.Random().nextDouble() * 100).floor();
    _strEnemy.setText("敵の強さ   :$_enemyPower");
  }
  
  void setHeroPowerRandom() {
    _heroPower = (new math.Random().nextDouble() * 100).floor();
    _strHero.setText("あなたの強さ :$_heroPower");
  }
  
  void judge() {
    var money = (new math.Random().nextDouble() * 200).floor();
    if (_heroPower > _enemyPower) {
      _strResult.setText("あなたの勝ち ${money}G 手に入れた");
      _hero.addMoney(money);
    } else {
      _strResult.setText("あなたの負け ${money}G 盗られた");
      _hero.addMoney(-money);
    }
    _strResult.setVisible(true);
  }
  
  void start(OnButtleEnd onButtleEnd) {
    if (_state != "ready") return;
    
    _onButtleEnd = onButtleEnd;
    
    _strApper.setVisible(true);
    _strEnemy.setVisible(true);
    _strHero.setVisible(true);
    _strResult.setVisible(true);
    
    _keyManager.addListener(this);
    
    setHeroPowerRandom();
    setEnemyPowerRandom();
    
    _state = "battle";
    startTimer();
  }
  
  bool onKeyDown(int keyCode) {
    if (keyCode != 13 && keyCode != 32) return false;
    
    if (_state == "battle") {
      stopTimer();
      judge();
      _state = "result";
    } else if (_state == "result") {
      _state = "ready";
      _strApper.setVisible(false);
      _strEnemy.setVisible(false);
      _strHero.setVisible(false);
      _strResult.setVisible(false);
      _keyManager.removeListener(this);
      if (_onButtleEnd != null) {
        _onButtleEnd();
      }
    }
    
    return false;
  }
  
  bool onKeyUp(int keyCode) => false;
  
  void onTimeout(Timer timer) {
    if (_state == "battle") {
      setHeroPowerRandom();
      startTimer();
    }    
  }
  
  void startTimer() {
    _timer = new Timer.periodic(new Duration(milliseconds:100), onTimeout);
  }
  
  void stopTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}

typedef void OnGameOverEnd();

class GameOverMode implements Listener {
  
  final Hero _hero;
  final KeyManager _keyManager;
  OnGameOverEnd _onGameOverEnd;
  
  String _state;
  
  Timer _timer;
  
  TextObj _strGameOver;
  TextObj _strMoney;
  TextObj _strWalk;
  TextObj _strScore;
  
  GameOverMode(this._hero, this._keyManager) {
    _state = "ready";
    
    _strGameOver = new TextObj("もう動けない！");
    _strMoney = new TextObj(" G獲得！");
    _strWalk = new TextObj(" 歩移動！");
    _strScore = new TextObj("総合得点:");
    
    _strGameOver.setVisible(false);
    _strMoney.setVisible(false);
    _strWalk.setVisible(false);
    _strScore.setVisible(false);
    
    _strGameOver.setPosition(50, 50);
    _strMoney.setPosition(50, 50 + 20 * 2);
    _strWalk.setPosition(50, 50 + 20 * 3);
    _strScore.setPosition(50, 50 + 20 * 5);

    _strGameOver.setFontWeight("bold");
    _strMoney.setFontWeight("bold");
    _strWalk.setFontWeight("bold");
    _strScore.setFontWeight("bold");
    
    _strGameOver.setColor(255, 0, 200);
    _strMoney.setColor(255, 0, 200);
    _strWalk.setColor(255, 0, 200);
    _strScore.setColor(255, 0, 200);
  }
  
  void start(OnGameOverEnd onGameOverEnd) {
    if (_state != "ready") return;
    
    _onGameOverEnd = onGameOverEnd;
    
    _strGameOver.setVisible(true);
    
    _keyManager.addListener(this);
    
    startTimer(1000);

    _state = "gameover";
  }
  
  void onTimeout(Timer timer) {
    
    var gain = _hero.gain;
    var walkCount = _hero.walkCount;
    
    switch (_state) {
      case "gameover":
        _strMoney.setText("$gain G獲得！");
        _strMoney.setVisible(true);
        _state = "money";
        startTimer(200);
        break;
      case "money":
        _strWalk.setText("$walkCount 歩移動！");
        _strWalk.setVisible(true);
        _state = "walk";
        startTimer(1000);
        break;
      case "walk":
        var score = (gain + walkCount * 20) * 5;
        _strScore.setText("総合得点: $score");
        _strScore.setVisible(true);
        _state = "score";
    }
  }
  
  bool onKeyDown(int keyCode) {
    
    if (_state == "score") {
      _state = "ready";
      _strGameOver.setVisible(false);
      _strMoney.setVisible(false);
      _strWalk.setVisible(false);
      _strScore.setVisible(false);
      
      _keyManager.removeListener(this);
      
      if (_onGameOverEnd != null) {
        _onGameOverEnd();
      }
    }
    
    return false;
  }
  
  bool onKeyUp(int keyCode) => false;
  
  void startTimer(int time) {
    _timer = new Timer.periodic(new Duration(milliseconds:1), onTimeout);
  }
  
  void stopTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}