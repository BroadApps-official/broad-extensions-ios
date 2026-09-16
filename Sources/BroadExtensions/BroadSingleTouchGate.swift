import SwiftUI

/// Lets a screen answer one touch at a time.
///
/// SwiftUI delivers touches to every control under a finger, so two rows pressed
/// with two fingers both run their action and the screen opens two things at
/// once. The gate is claimed by the first control that answers and stays closed
/// for a moment afterwards — the whole life of a second finger's press.
///
/// One gate belongs to one screen. Hold it in a `@StateObject` and route every
/// action of that screen through ``run(_:)``; a control that owns its own
/// presentation and has no action to wrap takes `View.broadClaimsTouch(_:)`
/// instead.
@MainActor
public final class BroadSingleTouchGate: ObservableObject {
    /// How long the gate stays closed after it is claimed.
    ///
    /// The default is long enough to cover two fingers lifted one after the
    /// other, and short enough not to swallow a second, deliberate tap.
    public nonisolated static let defaultWindow: Duration = .milliseconds(400)

    private let window: Duration
    private var isClosed = false
    private var releaseTask: Task<Void, Never>?

    /// - Parameter window: how long the gate stays closed after a claim.
    public init(window: Duration = BroadSingleTouchGate.defaultWindow) {
        precondition(window > .zero, "Single touch gate window must be positive")
        self.window = window
    }

    /// Runs `action` unless another control is already being answered.
    public func run(_ action: @MainActor () -> Void) {
        guard claim() else {
            return
        }
        action()
    }

    /// Closes the gate without running anything, for a control that owns its
    /// own presentation and has no action to wrap — `ShareLink`, for one.
    ///
    /// - Returns: `true` when this caller took the gate, `false` when another
    ///   control already holds it.
    @discardableResult
    public func claim() -> Bool {
        guard !isClosed else {
            return false
        }
        isClosed = true

        releaseTask?.cancel()
        releaseTask = Task { @MainActor [weak self, window] in
            try? await Task.sleep(for: window)
            guard !Task.isCancelled else {
                return
            }
            self?.isClosed = false
        }
        return true
    }

    /// Opens the gate immediately, for a screen that has finished a transition
    /// early and wants the next touch answered without waiting out the window.
    public func reset() {
        releaseTask?.cancel()
        releaseTask = nil
        isClosed = false
    }
}

public extension View {
    /// Claims `gate` the moment a finger lands. For controls whose action is
    /// not ours to wrap: they still open, but nothing else on the screen does.
    @MainActor
    func broadClaimsTouch(_ gate: BroadSingleTouchGate) -> some View {
        simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in gate.claim() }
        )
    }
}
