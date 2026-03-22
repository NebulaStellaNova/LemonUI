package lemonui.elements;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import flixel.FlxG;
import lemonui.controllers.TooltipController;
import lemonui.core.ElementBase;
import lemonui.utils.SpriteUtil;

class Tooltip extends ElementBase {

    public var outline:FlxSprite;
    public var background:FlxSprite;
    public var label:FlxText;
    public var targetAlpha:Float = 0;

    public function new() {
        super();

        outline = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
        add(outline);

        background = new FlxSprite(2, 2).makeGraphic(1, 1, FlxColor.WHITE);
        add(background);

        label = new FlxText(10, 6, 0, "");
        label.font = Constants.FONT_REGULAR;
        label.size = Math.round(12 * 1.75);
        label.scale.x = label.scale.y /= 1.75;
        label.updateHitbox();
        add(label);

        outline.scrollFactor.set();
        background.scrollFactor.set();
        label.scrollFactor.set();

        elementColor = 0xFF3d3f41;
        alpha = 0;
    }

    // Called before showing
    // Remakes the outline and background to fit the new text
    public function setText(text:String) {
        label.text = text;
        label.updateHitbox();

        var bgWidth = Math.round(label.width + 20);
        var bgHeight = Math.round(label.height + 12);

        outline.makeGraphic(bgWidth + 4, bgHeight + 4, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(outline, 5);
        outline.updateHitbox();

        background.makeGraphic(bgWidth, bgHeight, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(background, 3);
        background.updateHitbox();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        TooltipController.instance.update(elapsed);
    }

    override function onColorChange(value:FlxColor) {
        super.onColorChange(value);
        if (outline != null) outline.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.25);
        if (background != null) background.color = value;
        if (label != null) label.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
    }
}
