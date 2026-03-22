package lemonui.elements;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import lemonui.core.ElementBase;

class Menu extends Button {
    public var menuBG:FlxSprite;

    public var isOpen:Bool = false;

    public var menuItems:Array<Button> = [];

    public var parent:MenuBar;

    override public function new(text:String) {
        super(0, 0, 100, 35, text);
        menuBG = new FlxSprite(0, this.height-2);
        insert(0, menuBG);

    }

    override function addElement(component:ElementBase) {
        super.addElement(component);

        var newItem:Button = cast component;
        var lastItem:Button = menuItems[menuItems.length-1];
        if (lastItem == null) {
            component.y = this.background.height;
            component.visible = false;
            component.x += 2;
            // component.y += 2;
        } else {
            component.x = lastItem.x;
            component.y = lastItem.y + lastItem.background.height;
            component.visible = false;
        }

        lastItem ??= newItem;

        menuBG.makeGraphic(Math.round((newItem.x - 2) + (newItem.background.width + 5)), Math.round(lastItem.y + newItem.background.height + 10), FlxColor.interpolate(elementColor, FlxColor.BLACK, 0.25));

        menuItems.push(cast component);
        updateVisibilty();
    }

    override function _onClick() {
        super._onClick();
        isOpen ? close() : open();
    }

    public function close() {
        isOpen = false;
        updateVisibilty();
        background.setGraphicSize(100, 30);
    }

    public function open() {
        if (parent != null) parent.closeAll();
        isOpen = true;
        updateVisibilty();
        background.setGraphicSize(100, 35);
    }

    public function updateVisibilty() {
        for (i in menuItems) i.visible = isOpen;
        menuBG.visible = isOpen;
    }
}