package lemonui.elements;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;

import lemonui.core.ElementBase;
import lemonui.utils.SpriteUtil;

class Notification extends ElementBase {

    public var outline:FlxSprite;
    public var background:FlxSprite;
    public var line:FlxSprite;
    public var componentWidth:Int = 300;
    public var componentHeight:Int = 125;

    public var title:FlxText;
    public var body:FlxText;

    public var targetAlpha:Int = 1;

    public function new(TITLE:String, BODY:String) {
        super();
        outline = new FlxSprite().makeGraphic(componentWidth, componentHeight, FlxColor.WHITE);
        outline.updateHitbox();
        SpriteUtil.roundSpriteCorners(outline, 5);
        add(outline);

        background = new FlxSprite(2, 2).makeGraphic(componentWidth - 4, componentHeight - 4, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(background, 3);
        add(background);

        title = new FlxText(12, 8, 0, TITLE);
        title.font = Constants.FONT_BOLD;
        title.size = Math.round(16*1.75);
        title.scale.x = title.scale.y /= 1.75;
        title.updateHitbox();
        add(title);

        line = new FlxSprite(10, 33).makeGraphic(componentWidth - 20, 2, FlxColor.WHITE);
        add(line);

        body = new FlxText(12, 37, line.width * 1.75, BODY);
        body.font = Constants.FONT_REGULAR;
        body.size = Math.round(14*1.75);
        body.scale.x = body.scale.y /= 1.75;
        body.updateHitbox();
        add(body);

        elementColor = 0xFF3d3f41;
    }

    override function onColorChange(value:FlxColor) {
        super.onColorChange(value);

        line.color = outline.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.25);
        background.color = value;
        body.color = title.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.7);
    }
}