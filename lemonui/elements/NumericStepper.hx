package lemonui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import lemonui.core.ElementBase;
import lemonui.utils.SpriteUtil;

class NumericStepper extends ElementBase {

    public var input:TextInput;
    public var btnUp:FlxSprite;
    public var btnDown:FlxSprite;
    public var lblUp:FlxText;
    public var lblDown:FlxText;
    public var label:FlxText;

    public var value(default, set):Float;
    public var min:Float;
    public var max:Float;
    public var step:Float;
    public var decimals:Int;

    public dynamic function onChange(value:Float) {}

    public function new(x:Float = 0, y:Float = 0, labelText:String, defaultValue:Float = 0, min:Float = 0, max:Float = 999, step:Float = 1, decimals:Int = 0) {
        super(x, y);

        this.min = min;
        this.max = max;
        this.step = step;
        this.decimals = decimals;

        label = new FlxText(0, 0, 0, labelText);
        label.font = Constants.FONT_REGULAR;
        label.size = Math.round(13 * 1.75);
        label.scale.x = label.scale.y /= 1.75;
        label.updateHitbox();
        add(label);

        var fieldY = Math.round(label.height + 4);

        input = new TextInput(0, 0, "", 70, "", 10);
        input.y = fieldY - Math.round(input.label.height + 4);
        input.onChange = function(txt) { validateAndApply(txt); };
        input.onSubmit = function(txt) { validateAndApply(txt); };
        add(input);

        var btnSize = 12;
        var btnX = 74;

        btnUp = new FlxSprite(btnX, fieldY).makeGraphic(20, btnSize, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(btnUp, 3);
        add(btnUp);

        lblUp = new FlxText(btnX, fieldY - 1, 20, "+");
        lblUp.font = Constants.FONT_BOLD;
        lblUp.size = Math.round(10 * 1.75);
        lblUp.scale.x = lblUp.scale.y /= 1.75;
        lblUp.updateHitbox();
        lblUp.alignment = CENTER;
        add(lblUp);

        btnDown = new FlxSprite(btnX, fieldY + btnSize).makeGraphic(20, btnSize, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(btnDown, 3);
        add(btnDown);

        lblDown = new FlxText(btnX, fieldY + btnSize - 1, 20, "-");
        lblDown.font = Constants.FONT_BOLD;
        lblDown.size = Math.round(10 * 1.75);
        lblDown.scale.x = lblDown.scale.y /= 1.75;
        lblDown.updateHitbox();
        lblDown.alignment = CENTER;
        add(lblDown);

        elementColor = 0xFF3d3f41;
        value = defaultValue;
    }

    function validateAndApply(txt:String) {
        var parsed = Std.parseFloat(txt);
        if (Math.isNaN(parsed)) {
            value = 0;
        } else {
            value = parsed;
        }
        onChange(value);
    }

    function set_value(v:Float):Float {
        v = roundToDecimals(v, decimals);
        if (v < min) v = min;
        if (v > max) v = max;
        value = v;
        if (input != null) input.text = formatValue(v);
        return value;
    }

    function formatValue(v:Float):String {
        if (decimals <= 0) return Std.string(Std.int(v));
        var s = Std.string(v);
        var dotIndex = s.indexOf(".");
        if (dotIndex == -1) {
            s += ".";
            dotIndex = s.length - 1;
        }
        var currentDecimals = s.length - dotIndex - 1;
        while (currentDecimals < decimals) {
            s += "0";
            currentDecimals++;
        }
        if (currentDecimals > decimals) {
            s = s.substr(0, dotIndex + decimals + 1);
        }
        return s;
    }

    function roundToDecimals(v:Float, d:Int):Float {
        if (d <= 0) return Math.round(v);
        var pow = Math.pow(10, d);
        return Math.round(v * pow) / pow;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!this.visible) return;

        if (FlxG.mouse.justPressed) {
            if (FlxG.mouse.overlaps(btnUp)) {
                value = value + step;
                onChange(value);
            } else if (FlxG.mouse.overlaps(btnDown)) {
                value = value - step;
                onChange(value);
            }
        }

        if (input.hasFocus != true) return;
    }

    override function onColorChange(value:FlxColor) {
        super.onColorChange(value);
        if (input != null) input.elementColor = value;
        if (btnUp != null) btnUp.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.3);
        if (btnDown != null) btnDown.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.3);
        if (lblUp != null) lblUp.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.3);
        if (lblDown != null) lblDown.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.3);
        if (label != null) label.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
    }
}
