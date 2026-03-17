package lemonui.controllers;

import flixel.FlxG;
import flixel.util.FlxTimer;

import lemonui.elements.Tooltip;
import lemonui.utils.MathUtil;

class TooltipController {

    public static var instance(get, default):TooltipController;
    static function get_instance():TooltipController {
        return instance ??= new TooltipController();
    }

    public var tooltip:Tooltip;
    var showTimer:FlxTimer = new FlxTimer();
    var active:Bool = false;

    public function new() {
        tooltip = new Tooltip();
    }

    public function show(text:String, delay:Float = 0.6) {
        showTimer.cancel();
        showTimer.start(delay, (_)->{
            tooltip.setText(text);
            positionAtCursor();
            if (!active) {
                FlxG.state.add(tooltip);
                active = true;
            }
            tooltip.targetAlpha = 1;
        });
    }

    public function hide() {
        showTimer.cancel();
        tooltip.targetAlpha = 0;
    }

    public function positionAtCursor() {
        var outW:Float = tooltip.outline.width;
        var outH:Float = tooltip.outline.height;
        var screenW:Float = FlxG.width;
        var screenH:Float = FlxG.height;
        var mx:Float = FlxG.game.mouseX;
        var my:Float = FlxG.game.mouseY;
        var tx:Float = mx + 14;
        var ty:Float = my + 14;
        if (tx + outW > screenW) tx = mx - outW - 6;
        if (ty + outH > screenH) ty = my - outH - 6;
        tooltip.x = tx;
        tooltip.y = ty;
    }

    public function update(elapsed:Float) {
        if (!active) return;
        if (tooltip.targetAlpha > 0) positionAtCursor();
        tooltip.alpha = MathUtil.lerp(tooltip.alpha, tooltip.targetAlpha, 0.2);
        if (tooltip.targetAlpha == 0 && Math.round(tooltip.alpha * 100) / 100 == 0) {
            tooltip.alpha = 0;
                FlxG.state.remove(tooltip);
                    active = false;
        }
    }
}
