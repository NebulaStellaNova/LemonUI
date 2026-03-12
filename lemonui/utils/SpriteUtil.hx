package lemonui.utils;

import openfl.display.Shape;
import openfl.display.BitmapData;
import flixel.FlxSprite;

class SpriteUtil {
    public static function roundSpriteCorners(sprite:FlxSprite, cornerRadius:Float):Void
    {
        var originalBmd:BitmapData = sprite.pixels;
        var shape:Shape = new Shape();
        shape.graphics.beginBitmapFill(originalBmd, null, false, true);
        var ellipseSize:Float = cornerRadius * 2;
        shape.graphics.drawRoundRect(0, 0, originalBmd.width, originalBmd.height, ellipseSize, ellipseSize);
        shape.graphics.endFill();
        var roundedBmd:BitmapData = new BitmapData(originalBmd.width, originalBmd.height, true, 0x00000000);
        roundedBmd.draw(shape);
        sprite.pixels = roundedBmd;
    }
}