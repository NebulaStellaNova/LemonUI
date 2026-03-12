package lemonui.controllers;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.util.FlxTimer;

import lemonui.utils.MathUtil;
import lemonui.components.Notification;

class NotificationController {
    public static var instance(get, default):NotificationController;
    static function get_instance():NotificationController {
        return instance ??= new NotificationController();
    }

    public var notificationCamera:FlxCamera;

    public var notifications:Array<Notification> = [];

    public function new() {
        FlxG.signals.preUpdate.add(()->this.update(FlxG.elapsed));
        FlxG.signals.preStateSwitch.add(()->{
            FlxG.cameras.remove(this.notificationCamera);
            this.notificationCamera = null;
        });
    }

    public function addNotification(title:String, body:String, duration:Float = 5) {
        notificationCamera ??= new FlxCamera();
        notificationCamera.bgColor = flixel.util.FlxColor.TRANSPARENT;
        if (FlxG.cameras.list.contains(notificationCamera)) FlxG.cameras.remove(notificationCamera, false);
        FlxG.cameras.add(notificationCamera, false);

        var notification = new Notification(title, body);
        notification.camera = notificationCamera;
        notification.x = FlxG.width - notification.componentWidth - 30;
        notification.y = FlxG.height - notification.componentHeight - 30;
        add(notification);

        notification.alpha = 0;
        new FlxTimer().start(duration, (_)->notification.targetAlpha = 0);
    }

    function add(what:Notification) {
        notifications.insert(0, what);
        FlxG.state.add(what);
    }

    function remove(what:Notification) {
        notifications.remove(what);
        FlxG.state.remove(what);
        what.destroy();
    }

    function update(elapsed:Float) {
        for (i=>n in notifications) {
            // trace(i-notifications.length);
            var index = notifications.length-(1+i);
            var notification:Notification = notifications[index];
            notification.y = MathUtil.lerp(notification.y, FlxG.height - notification.componentHeight - 30 - ((notification.componentHeight+10) * index), 0.1);
            notification.alpha = MathUtil.lerp(notification.alpha, notification.targetAlpha, 0.1);
            if (Math.round(notification.alpha*100)/100 == 0) {
                remove(notification);
            }
        }
    }
}