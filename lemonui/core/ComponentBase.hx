package lemonui.core;

import flixel.util.FlxColor;

class ComponentBase extends flixel.group.FlxSpriteGroup {

    public var componentColor(default, set):FlxColor;
    function set_componentColor(value:FlxColor) {
        onColorChange(value);
        return componentColor = value;
    }

    public function onColorChange(value:FlxColor) {}

}