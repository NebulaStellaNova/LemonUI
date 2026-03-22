package lemonui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import lemonui.core.ElementBase;
import lemonui.controllers.TooltipController;

class Button extends ElementBase {

    public var background:FlxSprite;
    public var hoverSprite:FlxSprite;
    public var buttonText:FlxText;

    // TODO: Learn/Implement signals.
    public var onClickSignal:FlxSignal = new FlxSignal();
    public var onMouseInSignal:FlxSignal = new FlxSignal();
    public var onMouseOutSignal:FlxSignal = new FlxSignal();

    public dynamic function onClick() {}
    public dynamic function onHeld() {}
    public dynamic function onMouseIn() {}
    public dynamic function onMouseOut() {}

    public function new(x:Float = 0, y:Float = 0, width:Int = 100, height:Int = 50, text:String) {
        super(x, y);

        background = new FlxSprite().makeGraphic(width, height, elementColor);
        add(background);

        hoverSprite = new FlxSprite().makeGraphic(width, height, FlxColor.interpolate(elementColor, FlxColor.WHITE, 0.25));
        hoverSprite.alpha = 0;
        add(hoverSprite);

        buttonText = new FlxText(5, 5, 0, text);
        buttonText.font = Constants.FONT_BOLD;
        buttonText.size = Math.round(13*1.75);
        buttonText.scale.x = buttonText.scale.y /= 1.75;
        buttonText.updateHitbox();
        buttonText.x = (background.width/2) - (buttonText.width/2);
        buttonText.y = (background.height/2) - (buttonText.height/2);
        add(buttonText);
    }

    public var tooltipText:String = "";
    public var hovered:Bool = false;

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (hovered != FlxG.mouse.overlaps(background) && this.visible) {
            hovered = FlxG.mouse.overlaps(background);
            if (hovered) {
                onMouseIn();
                _onMouseIn();
            } else {
                onMouseOut();
                _onMouseOut();
            }
        }
        hoverSprite.alpha = 0;
        if (FlxG.mouse.overlaps(background) && this.visible) {
            if (FlxG.mouse.justPressed) {
                onClick();
                _onClick();
            }
            if (FlxG.mouse.pressed) {
                onHeld();
                _onHeld();
                hoverSprite.alpha = 0.75;
            } else hoverSprite.alpha = 0.5;
        }
    }

    private function _onClick() {}
    private function _onHeld() {}
    private function _onMouseIn() {
        if (tooltipText != "") TooltipController.instance.show(tooltipText);
    }
    private function _onMouseOut() {
        if (tooltipText != "") TooltipController.instance.hide();
    }
}