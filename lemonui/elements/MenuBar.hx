package lemonui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import lemonui.core.ElementBase;

class MenuBar extends ElementBase {

    public var menuItems:Array<Menu> = [];

    public var anyOpened(get, never):Bool;
    function get_anyOpened():Bool {
        var value = false;
        for (i in menuItems) if (i.isOpen) value = true;
        return value;
    }

    public function new(x:Int = 0, y:Int = 0) {
        super(x, y);

        var background = new FlxSprite(0, 0).makeGraphic(FlxG.width, 35, elementColor);
        add(background);
    }

    override function addElement(component:ElementBase) {
        super.addElement(component);

        var newMenu:Menu = cast component;
        newMenu.parent = this;

        var lastItem:Menu = menuItems[menuItems.length-1];
        component.x = lastItem == null ? 0 : lastItem.x + lastItem.background.width;

        menuItems.push(cast component);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed) closeAll();

        if (anyOpened) {
            for (i in menuItems) {
                if (FlxG.mouse.overlaps(i.background) && !i.isOpen) {
                    closeAll();
                    i.open();
                }
            }
        }
    }

    public function closeAll() {
        for (i in menuItems) i.close();
    }
}