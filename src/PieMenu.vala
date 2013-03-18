/* 
Copyright (c) 2011-2012 by Simon Schneegans

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>. 
*/

namespace OpenPie {

public class PieMenu : GLib.Object {

    public signal void on_select(PieMenu menu, string item);
    public signal void on_close(PieMenu menu);
    
    public PieMenu(string menu_description) {
        var loader = new MenuLoader.from_string(menu_description);
        
        window_     = new TransparentWindow();
        menu_       = new TraceMenu(TraceMenuHelpers.adjust_angles(loader.model));
        controller_ = new TraceMenuController(menu_, window_);
        view_       = new TraceMenuView(menu_, window_);
    }

    public void display() {
        window_.open();
        window_.start_rendering();
        
        controller_.on_select.connect(on_controller_select_);
        view_.on_close.connect(on_view_close_);
    }
    
    ////////////////////////////////////////////////////////////////////////////
    
    private TransparentWindow   window_     = null;
    private MenuController      controller_ = null;
    private MenuView            view_       = null;
    private TraceMenu           menu_       = null;
    
    private void on_controller_select_(string item) {
        controller_.on_select.disconnect(on_controller_select_);
        on_select(this, item);
    }
    
    private void on_view_close_() {
        view_.on_close.disconnect(on_view_close_);
        window_.destroy();
        on_close(this);
    }
}   
    
}
