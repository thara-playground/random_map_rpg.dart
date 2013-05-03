library web_rpg;

import 'dart:html';
import 'dart:math' as math;
import 'dart:async';
import 'package:random_map_rpg/random_map_rpg.dart';

part "field_view.dart";
part "hero_view.dart";

part "key_manager.dart";
part "game_mode.dart";

const int FIELD_SIZE_X = 24;
const int FIELD_SIZE_Y = 12;

math.Random encount = new math.Random();

void main() {
  
  var gameMode = new GameMode();
  gameMode.keyManager.listenTo(document);
  
//  
//  var field = new Field(FIELD_SIZE_X, FIELD_SIZE_Y);
//  field.generateMap();
//  
//  var hero = new Hero();
//  hero.setPositionRandom(FIELD_SIZE_X, FIELD_SIZE_Y);
//  
//  var fieldView = new FieldView(field, hero);
//  fieldView.update();
//  var heroState = new HeroState(hero);
//  heroState.update();
//  
//  document.onKeyDown.listen((KeyboardEvent e) {
//    var keyCode = e.keyCode;
//    
//    var oldX = hero.x;
//    var oldY = hero.y;
//    var newX = oldX;
//    var newY = oldY;
//    
//    if (keyCode == "6".codeUnits[0] || keyCode == 39 || keyCode == 102) {
//      newX++;
//    } else if (keyCode == "4".codeUnits[0] || keyCode == 37 || keyCode == 100) {
//      newX--;
//    } else if (keyCode == "2".codeUnits[0] || keyCode == 40 || keyCode == 98) {
//      newY++;
//    } else if (keyCode == "8".codeUnits[0] || keyCode == 38 || keyCode == 104) {
//      newY--;
//    }
//    
//    if (newX != oldX || newY != oldY) {
//      // rule1.移動不可能地形制約（画面外、水へは移動できない）。移動可能なら移動する
//      if (newX < 0 || newX >= field.sizeX || newY < 0 || newY >= field.sizeY) {
//        return; // 画面外
//      }
//      if (field.getCellAttr(newX, newY) != CELL_ATR_GROUND) {
//        return; // 地面属性以外
//      }
//      hero.walk(newX - oldX, newY - oldY);
//      
//      // rule2.移動元の地形属性は水になる
//      field.setCellAttr(oldX, oldY, CELL_ATR_WATER);
//      
//      // rule3.移動後、上下左右が全て移動不可能地形の場合ゲームオーバー
//      if (field.getCellAttr(newX + 1, newY) != CELL_ATR_GROUND
//          && field.getCellAttr(newX - 1, newY) != CELL_ATR_GROUND
//          && field.getCellAttr(newX, newY + 1) != CELL_ATR_GROUND
//          && field.getCellAttr(newX, newY - 1) != CELL_ATR_GROUND) {
//        var score = (hero.gain + hero.walkCount * 20) * 5;
//        window.alert("""
//          Game Over
//          歩行回数:${hero.walkCount}
//          所持金:${hero.money}
//          総合得点:$score
//        """);
//      } else if (encount.nextDouble() < 0.15) {
//        // rule4.移動後、ある確率で敵が出現する
//        window.alert("敵が現れた！");
//        var enemyPower = (encount.nextDouble() * 100).floor();
//        var heroPower = (encount.nextDouble() * 100).floor();
//        var money = (encount.nextDouble() * 200).floor();
//        if (heroPower > enemyPower) {
//          window.alert("あなたの勝ち ${money}G手に入れた");
//          hero.addMoney(money);
//        } else {
//          window.alert("あなたの負け ${money}G盗られた");
//          hero.addMoney(-money);
//        }
//      }
//      
//    }
//    
//    fieldView.update();
//    heroState.update();
//  });
}