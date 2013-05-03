part of web_rpg;


abstract class Listener {
  bool onKeyDown(int keyCode);
  bool onKeyUp(int keyCode);
}

class KeyManager {
  
  static const int MAX_HOOK = 32;
  
  final List<Listener> listeners = new List();
  
  void addListener(Listener listener) {
    if (listeners.length <= MAX_HOOK) {
      listeners.add(listener);
    }
  }
  
  void removeListener(Listener listener) {
    listeners.remove(listener);
  }
  
  void listenTo(HtmlDocument document) {
    document.onKeyDown.listen((e) => forwardKeyEvent(e, true));
    document.onKeyUp.listen((e) => forwardKeyEvent(e, true));
  }
  
  void forwardKeyEvent(KeyboardEvent e, bool isKeyDown) {
    var keyCode = e.keyCode;
    for (var listener in listeners.toList().reversed) {
      var result = isKeyDown ?
                    listener.onKeyDown(keyCode) : listener.onKeyUp(keyCode);
      if (!result) break;      
    }
  }
}