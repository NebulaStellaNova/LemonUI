package lemonui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import lemonui.core.ElementBase;
import lemonui.utils.SpriteUtil;

class Dropdown extends ElementBase {

    public var background:FlxSprite;
    public var label:FlxText;
    public var selectedText:FlxText;
    public var arrow:FlxText;

    public var listBG:FlxSprite;
    public var listItems:Array<FlxSprite> = [];
    public var listLabels:Array<FlxText> = [];

    public var options:Array<String>;
    public var selectedIndex(default, set):Int = 0;
    public var selectedLabel(get, set):String;
    public var isOpen:Bool = false;
    public var dropWidth:Int;

    public dynamic function onChange(index:Int, label:String) {}

    var itemHeight:Int = 22;

    public function new(x:Float = 0, y:Float = 0, labelText:String, options:Array<String>, dropWidth:Int = 150) {
        super(x, y);

        this.options = options;
        this.dropWidth = dropWidth;

        label = new FlxText(0, 0, 0, labelText);
        label.font = Constants.FONT_REGULAR;
        label.size = Math.round(13 * 1.75);
        label.scale.x = label.scale.y /= 1.75;
        label.updateHitbox();
        add(label);

        var fieldY = Math.round(label.height + 4);

        background = new FlxSprite(0, fieldY).makeGraphic(dropWidth, 24, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(background, 4);
        add(background);

        selectedText = new FlxText(6, fieldY + 4, 0, "");
        selectedText.font = Constants.FONT_REGULAR;
        selectedText.size = Math.round(13 * 1.75);
        selectedText.scale.x = selectedText.scale.y /= 1.75;
        selectedText.updateHitbox();
        add(selectedText);

        arrow = new FlxText(dropWidth - 16, fieldY + 2, 16, "v");
        arrow.font = Constants.FONT_BOLD;
        arrow.size = Math.round(11 * 1.75);
        arrow.scale.x = arrow.scale.y /= 1.75;
        arrow.updateHitbox();
        arrow.alignment = CENTER;
        add(arrow);

        var listHeight = options.length * itemHeight;
        listBG = new FlxSprite(0, fieldY + 25).makeGraphic(dropWidth, listHeight > 0 ? listHeight : 1, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(listBG, 4);
        listBG.visible = false;
        add(listBG);

        // Build option items
        for (i in 0...options.length) {
            var itemY = fieldY + 25 + i * itemHeight;

            var itemBG = new FlxSprite(0, itemY).makeGraphic(dropWidth, itemHeight, FlxColor.WHITE);
            itemBG.visible = false;
            add(itemBG);
            listItems.push(itemBG);

            var itemLabel = new FlxText(6, itemY + 3, 0, options[i]);
            itemLabel.font = Constants.FONT_REGULAR;
            itemLabel.size = Math.round(13 * 1.75);
            itemLabel.scale.x = itemLabel.scale.y /= 1.75;
            itemLabel.updateHitbox();
            itemLabel.visible = false;
            add(itemLabel);
            listLabels.push(itemLabel);
        }

        elementColor = 0xFF3d3f41;
        if (options.length > 0) selectedIndex = 0;
    }

    function set_selectedIndex(v:Int):Int {
        if (options.length == 0) return selectedIndex = 0;
        if (v < 0) v = 0;
        if (v >= options.length) v = options.length - 1;
        selectedIndex = v;
        if (selectedText != null) {
            selectedText.text = options[v];
            selectedText.updateHitbox();
        }
        return selectedIndex;
    }

    function get_selectedLabel():String {
        if (options.length == 0) return "";
        return options[selectedIndex];
    }

    function set_selectedLabel(v:String):String {
        for (i in 0...options.length) {
            if (options[i] == v) {
                selectedIndex = i;
                return v;
            }
        }
        return v;
    }

    function open() {
        isOpen = true;
        listBG.visible = true;
        for (item in listItems) item.visible = true;
        for (lbl in listLabels) lbl.visible = true;
        arrow.text = "^";
    }

    function close() {
        isOpen = false;
        listBG.visible = false;
        for (item in listItems) item.visible = false;
        for (lbl in listLabels) lbl.visible = false;
        arrow.text = "v";
    }

    function syncListVisibility() {
        if (!isOpen) {
            if (listBG.visible) listBG.visible = false;
            for (item in listItems) if (item.visible) item.visible = false;
            for (lbl in listLabels) if (lbl.visible) lbl.visible = false;
        }
    }

    override function draw() {
        syncListVisibility();
        super.draw();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!this.visible) return;

        if (FlxG.mouse.justPressed) {
            if (isOpen) {
                var clicked = false;
                for (i in 0...listItems.length) {
                    if (FlxG.mouse.overlaps(listItems[i])) {
                        selectedIndex = i;
                        onChange(i, options[i]);
                        clicked = true;
                        break;
                    }
                }
                close();
                if (!clicked && FlxG.mouse.overlaps(background)) {
                }
            } else if (FlxG.mouse.overlaps(background)) {
                open();
            }
        }

        if (isOpen) {
            for (i in 0...listItems.length) {
                if (FlxG.mouse.overlaps(listItems[i])) {
                    listItems[i].color = FlxColor.interpolate(elementColor, FlxColor.WHITE, 0.15);
                } else {
                    listItems[i].color = elementColor;
                }
            }
        }
    }

    override function onColorChange(value:FlxColor) {
        super.onColorChange(value);
        if (background != null) background.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.15);
        if (selectedText != null) selectedText.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
        if (arrow != null) arrow.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.6);
        if (label != null) label.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
        if (listBG != null) listBG.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.1);
        for (item in listItems) item.color = value;
        for (lbl in listLabels) lbl.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
    }
}
