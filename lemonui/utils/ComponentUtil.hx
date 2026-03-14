package lemonui.utils;

import lemonui.elements.MenuItem;
import lemonui.elements.Menu;
import lemonui.elements.MenuBar;
import lemonui.core.ElementBase;

typedef ObjectComponent = {
    var id:String;
    var type:String;
    var ?text:String;
    var ?children:Array<ObjectComponent>;
}

class ComponentUtil {

    public static var example:ObjectComponent = {
        id: "test",
        type: "MenuBar",
        children: [
            {
                id: "fileMenu",
                text: "Test Menu",
                type: "Menu",
                children: [{
                    id: "test",
                    text: "Test Item",
                    type: "MenuItem"
                }]
            }
        ]
    }

    public static function buildFromObject(object:ObjectComponent):ElementBase {
        var component:ElementBase = new ElementBase();
        switch (object.type) {
            case "MenuBar":
                component = new MenuBar(0, 0);
            case "Menu":
                component = new Menu(object.text);
            case "MenuItem":
                component = new MenuItem(object.text);
            default:
                trace('Unknown ui element typed "${object.type}"');
        }
        for (i in object?.children ?? []) {
            component.addComponent(buildFromObject(i));
        }
        return component;
    }

    public static function buildFromXML(object:Dynamic) {

    }
}