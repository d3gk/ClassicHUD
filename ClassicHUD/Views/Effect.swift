/* * * * * * * * * * * * * * * * *
 *                               *
 *    https://github.com/d3gk    *
 *    Distributed under GPLv3    *
 *                               *
 * * * * * * * * * * * * * * * * */

import SwiftUI;
import AppKit;
import Foundation;

struct EffectView : NSViewRepresentable {
    var material: NSVisualEffectView.Material = .fullScreenUI;
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow;
    var appearance: NSAppearance.Name?;
    var state: NSVisualEffectView.State = .followsWindowActiveState;
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let nsView = NSVisualEffectView();
    
        nsView.material = self.material;
        nsView.blendingMode = self.blendingMode;
        if let _appearance = self.appearance {
            nsView.appearance = .init(named: _appearance);
        }
        nsView.state = self.state;
        
        return nsView;
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = self.material;
        nsView.blendingMode = self.blendingMode;
        if let _appearance = self.appearance {
            nsView.appearance = .init(named: _appearance);
        }
        nsView.state = self.state;   
    }
}
