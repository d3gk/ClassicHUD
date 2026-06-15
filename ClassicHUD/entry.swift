/* * * * * * * * * * * * * * * * *
 *                               *
 *    https://github.com/d3gk    *
 *    Distributed under GPLv3    *
 *                               *
 * * * * * * * * * * * * * * * * */

import SwiftUI;
import AppKit;
import Foundation;


@main
struct ClassicHUD: App {
    init() {
        HUDWindow.Volume.orderFront(nil);
        HUDWindow.Brightness.orderFront(nil);
    }
    var body: some Scene {
        Settings {
            SettingsView();
        }
        
    }
}
