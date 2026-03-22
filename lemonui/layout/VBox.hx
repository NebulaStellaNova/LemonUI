package lemonui.layout;

import flixel.FlxSprite;
import lemonui.core.ElementBase;

class VBox extends ElementBase {

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
        var currentY:Float = 0;
        for (member in members) {
            if (member == null) continue;
            member.y = currentY;
            member.x = 0;
            currentY += member.height + spacing;
        }
    }
}
