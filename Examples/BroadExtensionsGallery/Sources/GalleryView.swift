import BroadExtensions
import SwiftUI

struct GalleryView: View {
    @State private var email = ""

    private let colors = [
        ("RGB", "#38F"),
        ("RGBA", "#38FC"),
        ("RRGGBB", "#3366FF"),
        ("RRGGBBAA", "#3366FFCC")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    colorSection
                    keyboardSection
                    navigationSection
                    fontSection
                }
                .padding(20)
            }
            .navigationTitle("BroadExtensions")
            .broadDismissKeyboardOnTap()
        }
    }

    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hex colors")
                .font(.title2.bold())

            ForEach(colors, id: \.0) { item in
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(broadHex: item.1) ?? .clear)
                        .frame(width: 52, height: 52)
                    VStack(alignment: .leading) {
                        Text(item.0).font(.headline)
                        Text(item.1).font(.caption.monospaced())
                    }
                }
            }
        }
    }

    private var keyboardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Keyboard dismiss")
                .font(.title2.bold())
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
            Text("Tap outside: the simultaneous gesture dismisses the keyboard.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var navigationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Scoped swipe-back")
                .font(.title2.bold())
            NavigationLink("Open detail") {
                SwipeBackDetailView()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var fontSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Custom fonts")
                .font(.title2.bold())
            Text("Register real app-owned font resources before calling broadCustom.")
                .font(.body)
            Text("Missing resources return a typed error; they are never ignored silently.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

private struct SwipeBackDetailView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "hand.draw")
                .font(.system(size: 44))
            Text("Swipe from the left edge")
                .font(.headline)
            Text("The previous gesture delegate is restored when this screen closes.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .broadInteractiveSwipeBack()
    }
}
