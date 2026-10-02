import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ControlsView()
                .tabItem { Label("Controls", systemImage: "switch.2") }
            DeviceView()
                .tabItem { Label("Device", systemImage: "iphone") }
        }
    }
}

private struct ControlsView: View {
    private enum Appearance: String, CaseIterable, Identifiable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"

        var id: Self { self }
    }

    @State private var notificationsEnabled = true
    @State private var reminder = Date.now
    @State private var quantity = 3
    @State private var volume = 0.6
    @State private var appearance = Appearance.system
    @State private var isSheetPresented = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Notifications", systemImage: "bell.badge", isOn: $notificationsEnabled)
                    DatePicker("Reminder", selection: $reminder)
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                    Picker("Appearance", selection: $appearance) {
                        ForEach(Appearance.allCases) { Text($0.rawValue) }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Volume") {
                    Slider(value: $volume) {
                        Text("Volume")
                    } minimumValueLabel: {
                        Image(systemName: "speaker.fill")
                    } maximumValueLabel: {
                        Image(systemName: "speaker.wave.3.fill")
                    }
                }

                Section {
                    Button("Open Sheet", systemImage: "checkmark.seal") {
                        isSheetPresented = true
                    }
                    ShareLink(item: "Built natively with SwiftUI")
                } footer: {
                    Text("100% native SwiftUI, compiled by Xcode on a cloud Mac.")
                }
            }
            .navigationTitle("Native Proof")
            .sensoryFeedback(.selection, trigger: appearance)
            .sheet(isPresented: $isSheetPresented) {
                ContentUnavailableView(
                    "Native Sheet",
                    systemImage: "checkmark.seal.fill",
                    description: Text("Drag to resize or swipe down to dismiss.")
                )
                .presentationDetents([.medium, .large])
            }
        }
    }
}

private struct DeviceView: View {
    private let device = UIDevice.current

    var body: some View {
        NavigationStack {
            List {
                LabeledContent("System", value: "\(device.systemName) \(device.systemVersion)")
                LabeledContent("Model", value: device.model)
                LabeledContent("UI Framework", value: "SwiftUI")
            }
            .navigationTitle("Device")
        }
    }
}
