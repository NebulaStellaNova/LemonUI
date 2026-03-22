package lemonui.layout;

import flixel.FlxSprite;
import lemonui.core.ElementBase;

class HBox extends ElementBase {

    public var spacing:Float;

    public function new(x:Float = 0, y:Float = 0, spacing:Float = 0) {
        super(x, y);
        this.spacing = spacing;
    }

     override public function addElement(element:FlxSprite) {
        add(element);
        reflow();
    }

    public function reflow() {
        var currentX:Float = 0;
        for (member in members) {
            if (member == null) continue;
            member.x = currentX;
            member.y = 0;
            currentX += member.width + spacing;
        }
    }
}
