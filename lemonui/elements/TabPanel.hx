package lemonui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import lemonui.core.ElementBase;
import lemonui.utils.SpriteUtil;

class TabPanel extends ElementBase {

    public var background:FlxSprite;
    public var tabBar:FlxSprite;

    public var tabs:Array<{name:String, bg:FlxSprite, label:FlxText, content:Array<FlxSprite>}> = [];
    public var selectedTab(default, set):Int = -1;
    public var panelWidth:Int;
    public var panelHeight:Int;
    public var tabHeight:Int = 28;

    public dynamic function onTabChange(index:Int, name:String) {}

    public function new(x:Float = 0, y:Float = 0, panelWidth:Int = 300, panelHeight:Int = 400) {
        super(x, y);

        this.panelWidth = panelWidth;
        this.panelHeight = panelHeight;

        background = new FlxSprite(0, tabHeight).makeGraphic(panelWidth, panelHeight - tabHeight, FlxColor.WHITE);
        SpriteUtil.roundSpriteCorners(background, 4);
        add(background);

        tabBar = new FlxSprite(0, 0).makeGraphic(panelWidth, tabHeight, FlxColor.WHITE);
        add(tabBar);

        elementColor = 0xFF3d3f41;
    }

    public function addTab(name:String):Int {
        var tabIndex = tabs.length;
        var tabWidth = Math.round(panelWidth / (tabIndex + 1));

        var tabBG = new FlxSprite(0, 0).makeGraphic(tabWidth, tabHeight, FlxColor.WHITE);
        add(tabBG);

        var tabLabel = new FlxText(0, 6, tabWidth, name);
        tabLabel.font = Constants.FONT_BOLD;
        tabLabel.size = Math.round(12 * 1.75);
        tabLabel.scale.x = tabLabel.scale.y /= 1.75;
        tabLabel.updateHitbox();
        tabLabel.alignment = CENTER;
        add(tabLabel);

        tabs.push({name: name, bg: tabBG, label: tabLabel, content: []});

        reflowTabs();

        if (selectedTab == -1) selectedTab = 0;

        return tabIndex;
    }

    public function addToTab(tabIndex:Int, element:FlxSprite) {
        if (tabIndex < 0 || tabIndex >= tabs.length) return;
        tabs[tabIndex].content.push(element);

        element.y += tabHeight;
        add(element);

        element.visible = (tabIndex == selectedTab);
    }

    function reflowTabs() {
        var tabWidth = Math.round(panelWidth / tabs.length);
        for (i in 0...tabs.length) {
            var tab = tabs[i];
            tab.bg.makeGraphic(tabWidth, tabHeight, FlxColor.WHITE);
            tab.bg.x = this.x + i * tabWidth;
            tab.bg.y = this.y;
            tab.label.fieldWidth = tabWidth;
            tab.label.x = this.x + i * tabWidth;
            tab.label.y = this.y + 6;
        }
        applyTabColors();
    }

    function set_selectedTab(v:Int):Int {
        if (tabs.length == 0) return selectedTab = v;
        if (v < 0) v = 0;
        if (v >= tabs.length) v = tabs.length - 1;
        selectedTab = v;
        for (i in 0...tabs.length) {
            for (el in tabs[i].content) el.visible = (i == v);
        }
        applyTabColors();
        return selectedTab;
    }

    function applyTabColors() {
        for (i in 0...tabs.length) {
            var tab = tabs[i];
            if (i == selectedTab) {
                tab.bg.color = elementColor;
                tab.label.color = FlxColor.interpolate(elementColor, FlxColor.WHITE, 0.85);
            } else {
                tab.bg.color = FlxColor.interpolate(elementColor, FlxColor.BLACK, 0.25);
                tab.label.color = FlxColor.interpolate(elementColor, FlxColor.WHITE, 0.5);
            }
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!this.visible) return;

        // Sync content visibility (parent group cascade protection)
        for (i in 0...tabs.length) {
            for (el in tabs[i].content) {
                if (el.visible != (i == selectedTab)) el.visible = (i == selectedTab);
            }
        }

        if (FlxG.mouse.justPressed) {
            for (i in 0...tabs.length) {
                if (FlxG.mouse.overlaps(tabs[i].bg)) {
                    selectedTab = i;
                    onTabChange(i, tabs[i].name);
                    break;
                }
            }
        }
    }

    override function onColorChange(value:FlxColor) {
        super.onColorChange(value);
        if (background != null) background.color = value;
        if (tabBar != null) tabBar.color = FlxColor.interpolate(value, FlxColor.BLACK, 0.3);
        applyTabColors();
    }
}
