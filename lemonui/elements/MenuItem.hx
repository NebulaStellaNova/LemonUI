package lemonui.elements;

class MenuItem extends Button {

    override public function new(width:Int = 300, height:Int = 40, text:String) {
        super(0, 0, width, height, text);
        this.buttonText.x = 10;
    }
}