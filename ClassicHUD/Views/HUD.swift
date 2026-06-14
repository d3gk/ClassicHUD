/* * * * * * * * * * * * * * * * *
 *                               *
 *    https://github.com/d3gk    *
 *    Distributed under GPLv3    *
 *                               *
 * * * * * * * * * * * * * * * * */

import SwiftUI;
import AppKit;
import Foundation;

struct HUD : View {
    
    enum Role {
        case Brightness;
        case Volume;
    }
    
    @State private var value: Int = 0;
    @State private var opacity: CGFloat = 0;
    @State private var cached_value: CGFloat = 0;
    @State private var lastupdated: Int = 0;
    var role: Role;
    var body: some View {
        ZStack {
            EffectView(material: .hudWindow, state: .active)
                .clipShape(RoundedRectangle(cornerRadius: 18));
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.clear);
                    Image(systemName: ({
                        switch(self.role) {
                        case .Volume: 
                            "speaker.wave.3.fill";
                        case .Brightness: 
                            "sun.max";
                        }
                    } as () -> String)(), variableValue: Double(self.value) / Double(16))
                    .font(.system(size: 80))
                    .contentTransition(.symbolEffect(.replace))
                    .symbolVariant(
                        (self.value == 0) ? 
                            .slash : .none
                    );
                }
                ZStack {
                    HStack(spacing: 1) {
                        ForEach(1...16, id: \.self) { i in 
                            Rectangle()
                                .fill(
                                    .white.opacity(
                                        (self.value >= i) ? 
                                        1 : 0
                                    )
                                )
                        }
                    }.padding(1)
                }.frame(height: 8)
                    .background {
                        Rectangle()
                            .fill(.ultraThickMaterial)
                            .colorScheme(.dark);
                    };
            }.padding(20)
        }.frame(width: 200, height: 200)
            .opacity(self.opacity)
            .onAppear {
                self.cached_value = switch(self.role) {
                    case .Brightness: CGFloat(GetBrightness() ?? Float(-1));
                    case .Volume: CGFloat(GetVolume() ?? Float(-1));
                }
                self.value = Int((cached_value * 16).rounded());
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    let new_value = switch(self.role) {
                        case .Brightness: CGFloat(GetBrightness() ?? Float(-1));
                        case .Volume: CGFloat(GetVolume() ?? Float(-1));
                    }
                    if (abs(new_value - cached_value) > 0.001) {
                        self.lastupdated = 0;
                        withAnimation {
                            self.opacity = 1;
                        }
                        self.value = Int((new_value * 16).rounded());
                        self.cached_value = new_value;
                    } else {
                        self.lastupdated += 1;
                        if (lastupdated > 15) {
                            withAnimation {
                                self.opacity = 0;
                            }
                        }
                    }
                }
            };
    }
}

#Preview {
    HUD(role: .Volume)
        .preferredColorScheme(.dark);
}
