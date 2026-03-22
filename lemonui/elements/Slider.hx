package lemonui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

import lemonui.core.ElementBase;
import lemonui.utils.SpriteUtil;

class Slider extends ElementBase {

    public var track:FlxSprite;
    public var trackFill:FlxSprite;
    public var handle:FlxSprite;
    public var label:FlxText;

    public var value(default, set):Float;
    public var min:Float;
    public var max:Float;
    public var step:Float;
    public var trackWidth:Int;

    public dynamic function onChange(value:Float) {}

    var dragging:Bool = false;
    var _scrPoint:FlxPoint = FlxPoint.get();

    public function new(x:Float = 0, y:Float = 0, text:String, min:Float = 0, max:Float = 1, defaultValue:Float = 0.5, step:Float = 0.01, trackWidth:Int = 200) {
        super(x, y);

        this.min = min;
        this.max = max;
        this.step = step;
        this.trackWidth = trackWidth;

        label = new FlxText(0, 0, 0, text);
        label.font = Constants.FONT_REGULAR;
        label.size = Math.round(13 * 1.75);
        label.scale.x = label.scale.y /= 1.75;
        label.updateHitbox();
        add(label);

        var trackY = Math.round(label.height + 8);

        track = new FlxSprite(0, trackY).makeGraphic(trackWidth, 6, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(track, 3);
        add(track);

        trackFill = new FlxSprite(0, trackY).makeGraphic(trackWidth, 6, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(trackFill, 3);
        add(trackFill);

        handle = new FlxSprite(0, trackY - 5).makeGraphic(16, 16, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(handle, 8);
        add(handle);

        elementColor = 0xFF3d3f41;
        value = defaultValue;
    }

    function set_value(v:Float):Float {
        v = Math.round(v / step) * step;
        if (v < min) v = min;
        if (v > max) v = max;
        value = v;
        updateVisuals();
        return value;
    }

    function updateVisuals() {
        if (handle == null || track == null || trackFill == null) return;
        var ratio:Float = (value - min) / (max - min);
        var fillWidth = Math.round(ratio * trackWidth);
        if (fillWidth < 1) fillWidth = 1;

        handle.x = track.x + Math.round(ratio * (trackWidth - handle.width));
        trackFill.clipRect = new FlxRect(0, 0, fillWidth, 6);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!this.visible) return;

        if ((FlxG.mouse.overlaps(track) || FlxG.mouse.overlaps(handle)) && FlxG.mouse.justPressed) {
            dragging = true;
        }
        if (dragging) {
            if (FlxG.mouse.pressed) {
                track.getScreenPosition(_scrPoint);
                var mouseRelX:Float = FlxG.mouse.getScreenPosition().x - _scrPoint.x;
                var ratio:Float = mouseRelX / trackWidth;
                if (ratio < 0) ratio = 0;
                if (ratio > 1) ratio = 1;
                value = min + ratio * (max - min);
                onChange(value);
            } else {
                dragging = false;
            }
        }
    }

    override function onColorChange(value:FlxColor) {
        super.onColorChange(value);
        if (track != null) track.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.25);
        if (trackFill != null) trackFill.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.4);
        if (handle != null) handle.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.6);
        if (label != null) label.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
    }
}
