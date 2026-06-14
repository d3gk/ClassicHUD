import SwiftUI;



struct icon : View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white);
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(.clear);
                    Image(
                        systemName: 
                            "speaker.wave.3.fill"
                    ).font(.system(size: 180))
                        .foregroundStyle(.black)
                }
                HStack(spacing: 3) {
                    ForEach(0..<16, id: \.self) { _ in 
                        Rectangle()
                            .fill(.black);
                    } 
                }.padding(1)
                    .frame(height: 20);
            }.padding(50);
        }.frame(width: 512, height: 512);
    }
}

#Preview {
    icon()
        .scaleEffect(0.5);
}
