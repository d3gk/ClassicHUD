//
//  Settings.swift
//  ClassicHUD
//
//  Created by Daniel on 15.06.2026.
//

import SwiftUI;

struct SettingsView : View {
    @State var bg = UserDefaults.standard.string(forKey: "bg") ?? "blur";
    @State var color_scheme = UserDefaults.standard.string(forKey: "scheme") ?? "system";
    var body: some View {
        ScrollView {
            Form {
                Section {
                    HStack {
                        Image(nsImage: .init(resource: .init(name: "Icon", bundle: .main)));
                        VStack(alignment: .leading, spacing: 5) {
                            Text("ClassicHUD")
                                .font(.system(size: 30, weight: .bold));
                            Text("For those, who are sick of Tahoe")
                        }.padding(.bottom, 10)
                    }
                    HStack {
                        Text("Version");
                        Spacer();
                        Text(
                            (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String) + 
                            " (" + 
                            (Bundle.main.infoDictionary?["CFBundleVersion"] as! String) +
                            ")"
                        ).foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Download updates");
                        Spacer();
                        Link("here", destination: URL(string: "https://github.com/d3gk/ClassicHUD/releases/")!);
                    }
                    HStack {
                        Text("Download source code");
                        Spacer();
                        Link("here", destination: URL(string: "https://github.com/d3gk/ClassicHUD/")!);
                    }
                    HStack {
                        Text("Donate (please)");
                        Spacer();
                        Link("here", destination: URL(string: "https://ko-fi.com/d3gkserv")!);
                    }
                }
                Section {
                    Picker("HUD Background", selection: self.$bg) {
                        Text("Default")
                            .tag("blur");
                        Text("Glass")
                            .tag("glass");
                        Text("Classic")
                            .tag("dim");
                    }.onChange(of: self.bg) {
                        UserDefaults.standard.set(self.bg, forKey: "bg");
                        if (self.bg == "dim") {
                            self.color_scheme = "dark";
                            UserDefaults.standard.set(self.color_scheme, forKey: "scheme");
                        }
                    }
                    Picker("Color Scheme", selection: self.$color_scheme) {
                        Text("System")
                            .tag("system");
                        Text("Always Dark")
                            .tag("dark");
                        Text("Always Light")
                            .tag("light");
                    }.disabled(self.bg == "dim")
                        .onChange(of: self.color_scheme) {
                            UserDefaults.standard.set(self.color_scheme, forKey: "scheme");
                        }
                }
            }.formStyle(.grouped);
        }.frame(width: 400, height: 400);
    }
}
#Preview {
    SettingsView();
}

