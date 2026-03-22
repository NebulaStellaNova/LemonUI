package lemonui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import lemonui.Constants;
import lemonui.core.ElementBase;
import lemonui.utils.SpriteUtil;

class Collapsible extends ElementBase {

    public var header:FlxSprite;
    public var arrow:FlxText;
    public var titleText:FlxText;

    public var isOpen(default, set):Bool;
    public var panelWidth:Int;
    public var headerHeight:Int = 26;
    public var contentItems:Array<FlxSprite> = [];

    public dynamic function onToggle(open:Bool) {}

    var contentY:Float;

    public function new(x:Float = 0, y:Float = 0, title:String, panelWidth:Int = 250, open:Bool = true) {
        super(x, y);

        this.panelWidth = panelWidth;

        header = new FlxSprite(0, 0).makeGraphic(panelWidth, headerHeight, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(header, 3);
        add(header);

        arrow = new FlxText(4, 4, 16, open ? "v" : ">");
        arrow.font = Constants.FONT_BOLD;
        arrow.size = Math.round(11 * 1.75);
        arrow.scale.x = arrow.scale.y /= 1.75;
        arrow.updateHitbox();
        add(arrow);

        titleText = new FlxText(18, 4, panelWidth - 22, title);
        titleText.font = Constants.FONT_BOLD;
        titleText.size = Math.round(12 * 1.75);
        titleText.scale.x = titleText.scale.y /= 1.75;
        titleText.updateHitbox();
        add(titleText);

        contentY = headerHeight + 4;
        elementColor = 0xFF3d3f41;
        isOpen = open;
    }

    public function addContent(element:FlxSprite) {
        contentItems.push(element);
        element.y += contentY;
        add(element);
        element.visible = isOpen;
    }

    function set_isOpen(v:Bool):Bool {
        isOpen = v;
        if (arrow != null) arrow.text = v ? "v" : ">";
        for (el in contentItems) el.visible = v;
        return isOpen;
    }

    public function getContentHeight():Float {
        if (!isOpen || contentItems.length == 0) return headerHeight;
        var maxY:Float = 0;
        for (el in contentItems) {
            var bottom = (el.y - this.y) + el.height;
            if (bottom > maxY) maxY = bottom;
        }
        return maxY + 4;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!this.visible) return;

        // Sync content visibility (FlxSpriteGroup cascade protection)
        for (el in contentItems) {
            if (el.visible != isOpen) el.visible = isOpen;
        }

        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(header)) {
            isOpen = !isOpen;
            onToggle(isOpen);
        }
    }

    override function onColorChange(value:FlxColor) {
        super.onColorChange(value);
        if (header != null) header.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.2);
        if (arrow != null) arrow.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.7);
        if (titleText != null) titleText.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
    }
}
