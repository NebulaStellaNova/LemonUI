package lemonui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.display.Shape;

import lemonui.core.ElementBase;
import lemonui.utils.SpriteUtil;

class Tickbox extends ElementBase {

    public var box:FlxSprite;
    public var fill:FlxSprite;
    public var checkmark:FlxSprite;
    public var label:FlxText;

    public var checked(default, set):Bool = false;

    public dynamic function onChange(value:Bool) {}

    public function new(x:Float = 0, y:Float = 0, text:String, defaultChecked:Bool = false) {
        super(x, y);

        box = new FlxSprite().makeGraphic(22, 22, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(box, 4);
        add(box);

        fill = new FlxSprite(2, 2).makeGraphic(18, 18, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(fill, 3);
        add(fill);

        checkmark = new FlxSprite(2, 2);
        drawCheckmark();
        checkmark.visible = false;
        add(checkmark);

        label = new FlxText(30, 2, 0, text);
        label.font = Constants.FONT_REGULAR;
        label.size = Math.round(13 * 1.75);
        label.scale.x = label.scale.y /= 1.75;
        label.updateHitbox();
        add(label);

        elementColor = 0xFF3d3f41;
        checked = defaultChecked;
    }

    function drawCheckmark() {
        var shape = new Shape();
        shape.graphics.lineStyle(2.5, 0xFFFFFF);
        shape.graphics.moveTo(3, 9);
        shape.graphics.lineTo(7, 14);
        shape.graphics.lineTo(15, 4);
        var bmd = new BitmapData(18, 18, true, 0x00000000);
        bmd.draw(shape);
        checkmark.pixels = bmd;
    }

    function set_checked(value:Bool):Bool {
        checked = value;
        if (checkmark != null) checkmark.visible = value;
        return value;
    }

    var hovered:Bool = false;

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!this.visible) return;

        if (checkmark.visible != checked) checkmark.visible = checked;

        var mouseOver = FlxG.mouse.overlaps(box);
        if (hovered != mouseOver) hovered = mouseOver;

        if (mouseOver && FlxG.mouse.justPressed) {
            checked = !checked;
            onChange(checked);
        }
    }

    override function onColorChange(value:FlxColor) {
        super.onColorChange(value);
        if (box != null) box.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.25);
        if (fill != null) fill.color = value;
        if (checkmark != null) checkmark.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
        if (label != null) label.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
    }
}
