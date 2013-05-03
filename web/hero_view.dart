part of web_rpg;

class TextObj {
  
  Element _span;
  
  TextObj(String text) {
    this._span = new Element.tag('span');
    _span.text = text;
    _span.style.position = "absolute";
    query("#main").append(_span);
  }
  
  void destroy() {
    this._span.remove();
  }
  
  void setPosition(int x, int y) {
    this._span.style.left = "${x}px";
    this._span.style.top = "${y}px";
  }
  
  void setText(String text) {
    if(_span.text != text) {
      _span.text = text;
    }
  }
  
  void setVisible(bool visible) {
    _span.style.visibility = visible ? "visible" : "hidden";
  }
  
  void setFontWeight(String weight) {
    _span.style.fontWeight = weight;
  }
  
  void setColor(int red, int green, int blue) {
    _span.style.color = "rbg($red, $green, $blue)";
  }
}

class HeroStateView {
  
  Hero hero;
  TextObj text;
  
  HeroStateView(this.hero) {
    text = new TextObj("所持金");
    text.setPosition(0, 24 * 12);
  }
  
  void update() {
    text.setText("所持金:${hero.money}G");
  }
}