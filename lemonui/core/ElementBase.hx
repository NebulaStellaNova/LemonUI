package lemonui.core;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class ElementBase extends FlxSpriteGroup {

    public var id:String;

    public var elementColor(default, set):FlxColor = 0xFF3d3f41;
    function set_elementColor(value:FlxColor) {
        onColorChange(value);
        return elementColor = value;
    }

    public function onColorChange(value:FlxColor) {}

    public function addElement(component:ElementBase) {
        add(component);
    }

    public function findElement(id:String, doTrace:Bool = true):Null<ElementBase> {
        for (i in members) {
            if (Std.isOfType(i, ElementBase)) {
                var el:ElementBase = cast i;
                if (el.id == id) return el;
                var out = el.findElement(id, false);
                if (out != null) return out;
            }
        }
        if (doTrace) trace('Could not find element with id "$id"');
        return null;
    }

}