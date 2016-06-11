using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time as Time;
using Toybox.ActivityMonitor as Act;

class punchOutView extends Ui.WatchFace {
    var background_bmp;
    var little_mac_still_bmp;
    var little_mac_win_bmp;
    var mike_tyson_still_bmp;
    var mike_tyson_down_bmp;
    var mario_ko_bmp;
    var timefont;
    var datefont;
    var device_settings;
    
    function initialize() {
        WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
     background_bmp = Ui.loadResource(Rez.Drawables.WatchBG);
     little_mac_still_bmp = Ui.loadResource(Rez.Drawables.littleMac_still);
     little_mac_win_bmp = Ui.loadResource(Rez.Drawables.littleMac_win);
     mike_tyson_still_bmp = Ui.loadResource(Rez.Drawables.mikeTyson_still);
     mike_tyson_down_bmp = Ui.loadResource(Rez.Drawables.mikeTyson_down);
     mario_ko_bmp = Ui.loadResource(Rez.Drawables.mario_ko);
     
     // Load time font
     timefont = Ui.loadResource(Rez.Fonts.font_timefont);
     datefont = Ui.loadResource(Rez.Fonts.font_datefont);
     // Grab watch settings
     device_settings = Sys.getDeviceSettings();
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // initialize
        var hr_info = Act.getHeartRateHistory(300, true);
        var act_info = Act.getInfo();
        var time = makeClockTime();
        var dateInfo = Time.Gregorian.info( Time.now(), Time.FORMAT_SHORT );
        var date = dateInfo.month.format("%02d") + "." + dateInfo.day.format("%02d");
        var device_stats = Sys.getSystemStats();
        //var act_info = Act.getInfo();
       
         // Draw the background
        // This is offset incorrectly in FR920.
        // That's a known issue (K2554).
        
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawBitmap(0, 0, background_bmp);
        // Draw appropriate bitmaps based on step goal
        if ( act_info.steps >= act_info.stepGoal) {
            dc.drawBitmap(74, 84, mike_tyson_down_bmp);
            dc.drawBitmap(40, 128, little_mac_win_bmp);
            dc.drawBitmap(80, 140, mario_ko_bmp);
        } else {
            dc.drawBitmap(47, 52, mike_tyson_still_bmp);
            dc.drawBitmap(65, 128, little_mac_still_bmp);
        }
        // Update the view
        // Write the current clock time
        dc.drawText( 88, 7, timefont, time.toString(), Gfx.TEXT_JUSTIFY_LEFT );
        dc.drawText( 115, 21, datefont, date, Gfx.TEXT_JUSTIFY_CENTER );
        dc.drawText( 140, 38, datefont, act_info.steps, Gfx.TEXT_JUSTIFY_RIGHT );
        // Write Heart Rate
        dc.setColor(0xa8f0bc, Gfx.COLOR_TRANSPARENT);
        dc.drawText( 54, 11, datefont, hr_info.getMax(), Gfx.TEXT_JUSTIFY_LEFT );
        // Draw Move Bar above Steps
        var width = 71;
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        if( act_info.moveBarLevel == Act.MOVE_BAR_LEVEL_MIN ) {
            dc.fillRoundedRectangle(9, 30, 1, 7, 1);
            if( act_info.moveBarLevel == Act.MOVE_BAR_LEVEL_MIN + 1 ) {
                dc.fillRoundedRectangle(9, 30, width/2, 7, 1);
            } else {
                dc.fillRoundedRectangle(9, 30, ( 14 * (Act.MOVE_BAR_LEVEL_MAX - act_info.moveBarLevel) ) / Act.MOVE_BAR_LEVEL_MAX, 7, 1);
            }
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    //! Get the time from the clock and format it for
    //! the watch face (from the C64Face example)
    hidden function makeClockTime()
    {
        var clockTime = Sys.getClockTime();
        var hour, min, result;

        if( device_settings.is24Hour )
            {
            hour = clockTime.hour;
            }
        else
            {
              hour = clockTime.hour % 12;
              hour = (hour == 0) ? 12 : hour;
            }

        min = clockTime.min;

        // You so money and you don't even know it
        return Lang.format("$1$:$2$",[hour.format("%02d"), min.format("%02d")]);
    }
}
