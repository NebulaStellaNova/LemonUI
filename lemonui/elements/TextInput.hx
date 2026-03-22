package lemonui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import lemonui.core.ElementBase;
import lemonui.utils.SpriteUtil;

class TextInput extends ElementBase {

    public var background:FlxSprite;
    public var label:FlxText;
    public var textDisplay:FlxText;

    public var text(default, set):String;
    public var fieldWidth:Int;
    public var hasFocus(default, set):Bool = false;
    public var maxLength:Int;

    public dynamic function onChange(text:String) {}
    public dynamic function onSubmit(text:String) {}

    var cursor:FlxSprite;
    var cursorPos:Int = 0;
    var cursorTimer:Float = 0;

    // This reeks
    static var PRINTABLE_KEYS:Array<{key:FlxKey, lower:String, upper:String}> = [
        {key: A, lower: "a", upper: "A"}, {key: B, lower: "b", upper: "B"},
        {key: C, lower: "c", upper: "C"}, {key: D, lower: "d", upper: "D"},
        {key: E, lower: "e", upper: "E"}, {key: F, lower: "f", upper: "F"},
        {key: G, lower: "g", upper: "G"}, {key: H, lower: "h", upper: "H"},
        {key: I, lower: "i", upper: "I"}, {key: J, lower: "j", upper: "J"},
        {key: K, lower: "k", upper: "K"}, {key: L, lower: "l", upper: "L"},
        {key: M, lower: "m", upper: "M"}, {key: N, lower: "n", upper: "N"},
        {key: O, lower: "o", upper: "O"}, {key: P, lower: "p", upper: "P"},
        {key: Q, lower: "q", upper: "Q"}, {key: R, lower: "r", upper: "R"},
        {key: S, lower: "s", upper: "S"}, {key: T, lower: "t", upper: "T"},
        {key: U, lower: "u", upper: "U"}, {key: V, lower: "v", upper: "V"},
        {key: W, lower: "w", upper: "W"}, {key: X, lower: "x", upper: "X"},
        {key: Y, lower: "y", upper: "Y"}, {key: Z, lower: "z", upper: "Z"},
        {key: ZERO, lower: "0", upper: ")"}, {key: ONE, lower: "1", upper: "!"},
        {key: TWO, lower: "2", upper: "@"}, {key: THREE, lower: "3", upper: "#"},
        {key: FOUR, lower: "4", upper: "$"}, {key: FIVE, lower: "5", upper: "%"},
        {key: SIX, lower: "6", upper: "^"}, {key: SEVEN, lower: "7", upper: "&"},
        {key: EIGHT, lower: "8", upper: "*"}, {key: NINE, lower: "9", upper: "("},
        {key: NUMPADZERO, lower: "0", upper: "0"}, {key: NUMPADONE, lower: "1", upper: "1"},
        {key: NUMPADTWO, lower: "2", upper: "2"}, {key: NUMPADTHREE, lower: "3", upper: "3"},
        {key: NUMPADFOUR, lower: "4", upper: "4"}, {key: NUMPADFIVE, lower: "5", upper: "5"},
        {key: NUMPADSIX, lower: "6", upper: "6"}, {key: NUMPADSEVEN, lower: "7", upper: "7"},
        {key: NUMPADEIGHT, lower: "8", upper: "8"}, {key: NUMPADNINE, lower: "9", upper: "9"},
        {key: SPACE, lower: " ", upper: " "},
        {key: PERIOD, lower: ".", upper: ">"}, {key: COMMA, lower: ",", upper: "<"},
        {key: SLASH, lower: "/", upper: "?"}, {key: BACKSLASH, lower: "\\", upper: "|"},
        {key: SEMICOLON, lower: ";", upper: ":"}, {key: QUOTE, lower: "'", upper: "\""},
        {key: LBRACKET, lower: "[", upper: "{"}, {key: RBRACKET, lower: "]", upper: "}"},
        {key: MINUS, lower: "-", upper: "_"}, {key: PLUS, lower: "=", upper: "+"},
        {key: GRAVEACCENT, lower: "`", upper: "~"},
    ];

    public function new(x:Float = 0, y:Float = 0, labelText:String, fieldWidth:Int = 150, defaultValue:String = "", maxLength:Int = 0, wordWrap:Bool = false) {
        super(x, y);

        this.fieldWidth = fieldWidth;
        this.maxLength = maxLength;

        label = new FlxText(0, 0, 0, labelText);
        label.font = Constants.FONT_REGULAR;
        label.size = Math.round(13 * 1.75);
        label.scale.x = label.scale.y /= 1.75;
        label.updateHitbox();
        add(label);

        var fieldY = Math.round(label.height + 4);

        background = new FlxSprite(0, fieldY).makeGraphic(fieldWidth, 24, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(background, 4);
        add(background);

        textDisplay = new FlxText(6, fieldY + 4, wordWrap ? fieldWidth - 12 : 0, defaultValue);
        textDisplay.font = Constants.FONT_REGULAR;
        textDisplay.size = Math.round(13 * 1.75);
        textDisplay.scale.x = textDisplay.scale.y /= 1.75;
        textDisplay.updateHitbox();
        add(textDisplay);

        cursor = new FlxSprite(6, fieldY + 4).makeGraphic(1, 14, FlxColor.WHITE);
        cursor.visible = false;
        add(cursor);

        elementColor = 0xFF3d3f41;
        text = defaultValue;
        cursorPos = defaultValue.length;
    }

    function set_text(v:String):String {
        if (maxLength > 0 && v.length > maxLength) v = v.substr(0, maxLength);
        text = v;
        if (textDisplay != null) {
            textDisplay.text = v;
            textDisplay.updateHitbox();
        }
        return text;
    }

    function set_hasFocus(v:Bool):Bool {
        hasFocus = v;
        if (cursor != null) cursor.visible = v;
        if (v) {
            cursorTimer = 0;
            cursorPos = text.length;
            updateCursorPosition();
        }
        return v;
    }

    function updateCursorPosition() {
        if (cursor == null || textDisplay == null) return;
        var sub = text.substr(0, cursorPos);
        var tempText = new FlxText(0, 0, 0, sub);
        tempText.font = Constants.FONT_REGULAR;
        tempText.size = Math.round(13 * 1.75);
        tempText.scale.x = tempText.scale.y /= 1.75;
        tempText.updateHitbox();
        cursor.x = textDisplay.x + tempText.width;
        tempText.destroy();
    }

    function insertChar(char:String) {
        if (maxLength > 0 && text.length >= maxLength) return;
        text = text.substr(0, cursorPos) + char + text.substr(cursorPos);
        cursorPos += char.length;
        updateCursorPosition();
        resetCursorBlink();
        onChange(text);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!this.visible) return;

        if (FlxG.mouse.justPressed) {
            hasFocus = FlxG.mouse.overlaps(background);
        }

        if (!hasFocus) return;

        // Blink cursor
        cursorTimer += elapsed;
        if (cursorTimer >= 0.5) {
            cursor.visible = !cursor.visible;
            cursorTimer = 0;
        }

        // Control keys
        if (FlxG.keys.justPressed.LEFT) {
            if (cursorPos > 0) cursorPos--;
            updateCursorPosition();
            resetCursorBlink();
        }
        if (FlxG.keys.justPressed.RIGHT) {
            if (cursorPos < text.length) cursorPos++;
            updateCursorPosition();
            resetCursorBlink();
        }
        if (FlxG.keys.justPressed.HOME) {
            cursorPos = 0;
            updateCursorPosition();
            resetCursorBlink();
        }
        if (FlxG.keys.justPressed.END) {
            cursorPos = text.length;
            updateCursorPosition();
            resetCursorBlink();
        }
        if (FlxG.keys.justPressed.BACKSPACE) { // Should probs make it so holding backspace deletes characters faster
            if (cursorPos > 0) {
                text = text.substr(0, cursorPos - 1) + text.substr(cursorPos);
                cursorPos--;
                updateCursorPosition();
                resetCursorBlink();
                onChange(text);
            }
        }
        if (FlxG.keys.justPressed.DELETE) {
            if (cursorPos < text.length) {
                text = text.substr(0, cursorPos) + text.substr(cursorPos + 1);
                onChange(text);
            }
        }
        if (FlxG.keys.justPressed.ENTER) {
            onSubmit(text);
            hasFocus = false;
        }
        if (FlxG.keys.justPressed.ESCAPE) {
            hasFocus = false;
        }

        // Character input
        var shifted = FlxG.keys.pressed.SHIFT;
        for (entry in PRINTABLE_KEYS) {
            if (FlxG.keys.checkStatus(entry.key, JUST_PRESSED)) {
                insertChar(shifted ? entry.upper : entry.lower);
                break;
            }
        }
    }

    function resetCursorBlink() {
        cursorTimer = 0;
        cursor.visible = true;
    }

    override function onColorChange(value:FlxColor) {
        super.onColorChange(value);
        if (background != null) background.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.15);
        if (textDisplay != null) textDisplay.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
        if (label != null) label.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
        if (cursor != null) cursor.color = FlxColor.interpolate(value, FlxColor.WHITE, 0.85);
    }
}
