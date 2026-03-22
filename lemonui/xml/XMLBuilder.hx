package lemonui.xml;

import lemonui.core.ElementBase;
import lemonui.elements.*;
import lemonui.layout.VBox;
import lemonui.layout.HBox;

using StringTools;

class XMLBuilder {

    public static function build(xmlString:String, ?handlers:Dynamic):XMLResult {
        var xml = Xml.parse(xmlString);
        var root = new ElementBase();
        var result = new XMLResult(root);

        for (element in xml.elements()) {
            processNode(element, root, result, handlers);
        }

        return result;
    }

    public static function buildFromAsset(path:String, ?handlers:Dynamic):XMLResult {
        var content = sys.io.File.getContent(path);
        if (content == null) {
            trace('XMLBuilder: asset not found "$path"');
            return new XMLResult(new ElementBase());
        }
        return build(content, handlers);
    }

    static function normalizeTag(tag:String):String {
        return tag.replace("-", "").toLowerCase();
    }

    static function processNode(node:Xml, parent:ElementBase, result:XMLResult, handlers:Dynamic) {
        if (node.nodeType != Xml.Element) return;

        var tag = normalizeTag(node.nodeName);
        var el = createElement(tag, node);
        if (el == null) {
            trace('XMLBuilder: unknown element "${node.nodeName}"');
            return;
        }

        var xAttr = node.get("x");
        var yAttr = node.get("y");
        if (xAttr != null) el.x = Std.parseFloat(xAttr);
        if (yAttr != null) el.y = Std.parseFloat(yAttr);

        el.id = node.get("id");

        result.register(node.get("id"), node.get("class"), el);

        wireEvents(el, node, handlers);

        var colorAttr = node.get("color");
        if (colorAttr != null && Std.isOfType(el, ElementBase)) {
            cast(el, ElementBase).elementColor = Std.parseInt(colorAttr);
        }

        if (Std.isOfType(parent, VBox)) {
            cast(parent, VBox).addElement(el);
        } else if (Std.isOfType(parent, HBox)) {
            cast(parent, HBox).addElement(el);
        } else if (Std.isOfType(parent, Menu)) {
            cast(parent, Menu).addElement(el);
        } else if (Std.isOfType(parent, MenuBar)) {
            cast(parent, MenuBar).addElement(el);
        } else {
            parent.add(el);
        }

        if (Std.isOfType(el, TabPanel)) {
            var tabPanel:TabPanel = cast(el, TabPanel);
            for (child in node.elements()) {
                if (normalizeTag(child.nodeName) == "tab") {
                    var tabName = attrStr(child, "name", "Tab");
                    var tabIndex = tabPanel.addTab(tabName);
                    for (tabChild in child.elements()) {
                        var childEl = createElement(normalizeTag(tabChild.nodeName), tabChild);
                        if (childEl == null) continue;
                        var xA = tabChild.get("x");
                        var yA = tabChild.get("y");
                        if (xA != null) childEl.x = Std.parseFloat(xA);
                        if (yA != null) childEl.y = Std.parseFloat(yA);
                        result.register(tabChild.get("id"), tabChild.get("class"), childEl);
                        wireEvents(childEl, tabChild, handlers);
                        tabPanel.addToTab(tabIndex, childEl);
                        if (Std.isOfType(childEl, ElementBase)) {
                            for (nested in tabChild.elements()) {
                                processNode(nested, cast(childEl, ElementBase), result, handlers);
                            }
                        }
                    }
                }
            }
        } else if (Std.isOfType(el, ElementBase)) {
            for (child in node.elements()) {
                processNode(child, cast(el, ElementBase), result, handlers);
            }
        }
    }

    static function createElement(tag:String, node:Xml):Null<ElementBase> {
        return switch (tag) {
            case "button":
                new Button(0, 0,
                    attrInt(node, "width", 100),
                    attrInt(node, "height", 50),
                    attrStr(node, "text", ""));
            case "slider":
                new Slider(0, 0,
                    attrStr(node, "label", ""),
                    attrFloat(node, "min", 0),
                    attrFloat(node, "max", 1),
                    attrFloat(node, "defaultValue", 0.5),
                    attrFloat(node, "step", 0.01),
                    attrInt(node, "trackWidth", 200));
            case "tickbox":
                new Tickbox(0, 0,
                    attrStr(node, "label", ""),
                    attrBool(node, "checked", false));
            case "textinput":
                new TextInput(0, 0,
                    attrStr(node, "label", ""),
                    attrInt(node, "fieldWidth", 150),
                    attrStr(node, "defaultValue", ""),
                    attrInt(node, "maxLength", 0),
                    attrBool(node, "wordWrap", false));
            case "numericstepper":
                new NumericStepper(0, 0,
                    attrStr(node, "label", ""),
                    attrFloat(node, "defaultValue", 0),
                    attrFloat(node, "min", 0),
                    attrFloat(node, "max", 999),
                    attrFloat(node, "step", 1),
                    attrInt(node, "decimals", 0));
            case "dropdown":
                new Dropdown(0, 0,
                    attrStr(node, "label", ""),
                    attrStrArray(node, "options"),
                    attrInt(node, "dropWidth", 150));
            case "tabpanel":
                new TabPanel(0, 0,
                    attrInt(node, "width", 300),
                    attrInt(node, "height", 400));
            case "menubar":
                new MenuBar(0, 0);
            case "menu":
                new Menu(attrStr(node, "text", "Menu"));
            case "menuitem":
                new MenuItem(
                    attrInt(node, "width", 300),
                    attrInt(node, "height", 40),
                    attrStr(node, "text", ""));
            case "notification":
                new Notification(
                    attrStr(node, "title", ""),
                    attrStr(node, "body", ""));
            case "vbox":
                new VBox(0, 0,
                    attrFloat(node, "spacing", 0));
            case "hbox":
                new HBox(0, 0,
                    attrFloat(node, "spacing", 0));
            case "collapsible":
                new Collapsible(0, 0,
                    attrStr(node, "title", ""),
                    attrInt(node, "width", 250),
                    attrBool(node, "open", true));
            default:
                null;
        };
    }

    static function wireEvents(el:flixel.FlxSprite, node:Xml, handlers:Dynamic) {
        if (handlers == null) return;

        var eventAttrs = ["onClick", "onChange", "onSubmit", "onTabChange"];
        for (attr in eventAttrs) {
            var handlerName = node.get(attr);
            if (handlerName == null) continue;
            if (!Reflect.hasField(el, attr)) {
                trace('XMLBuilder: element has no event "$attr"');
                continue;
            }
            var fn = Reflect.field(handlers, handlerName);
            if (fn == null) {
                trace('XMLBuilder: handler "$handlerName" not found');
                continue;
            }
            Reflect.setField(el, attr, fn);
        }
    }

    static function attrStr(node:Xml, name:String, def:String):String {
        var v = node.get(name);
        return v != null ? v : def;
    }

    static function attrInt(node:Xml, name:String, def:Int):Int {
        var v = node.get(name);
        if (v == null) return def;
        var parsed = Std.parseInt(v);
        return parsed != null ? parsed : def;
    }

    static function attrFloat(node:Xml, name:String, def:Float):Float {
        var v = node.get(name);
        if (v == null) return def;
        var parsed = Std.parseFloat(v);
        return Math.isNaN(parsed) ? def : parsed;
    }

    static function attrBool(node:Xml, name:String, def:Bool):Bool {
        var v = node.get(name);
        if (v == null) return def;
        return v == "true" || v == "1";
    }

    static function attrStrArray(node:Xml, name:String):Array<String> {
        var v = node.get(name);
        if (v == null) return [];
        return v.split(",").map(function(s) return StringTools.trim(s));
    }
}
