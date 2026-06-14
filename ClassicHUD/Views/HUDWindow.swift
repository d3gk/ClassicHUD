/* * * * * * * * * * * * * * * * *
 *                               *
 *    https://github.com/d3gk    *
 *    Distributed under GPLv3    *
 *                               *
 * * * * * * * * * * * * * * * * */

import SwiftUI;
import AppKit;
import Foundation;

class HUDWindow : NSWindow {
    static let Volume = HUDWindow(.Volume);
    static let Brightness = HUDWindow(.Brightness);
    init(_ role: HUD.Role) {
        super.init(
            contentRect: .init(
                x: (NSScreen.main!.frame.width / 2) - 100, 
                y: 140,
                width: 200, 
                height: 200
            ),
            styleMask: [
                .borderless
            ], 
            backing: .buffered, 
            defer: false
        );
        self.contentView = NSHostingView(rootView: HUD(role: role));
        self.level = .statusBar;
        self.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary
        ]
        self.backgroundColor = .clear;
        self.ignoresMouseEvents = true;
        self.isReleasedWhenClosed = false;
    }
}
