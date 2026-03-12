package lemonui.utils;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MathUtil {
	public static function getElapsedRatio(ratio:Float, fps:Float = 60):Float
		return FlxMath.bound(ratio * fps * FlxG.elapsed, 0, 1);

	public static function lerp(a:Float, b:Float, ratio:Float, fpsSensitive:Bool = true):Float
		return FlxMath.lerp(a, b, fpsSensitive ? getElapsedRatio(ratio) : ratio);
}