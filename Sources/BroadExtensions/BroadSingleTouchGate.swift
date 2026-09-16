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
/// instead, which holds the gate for the whole press.
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
    /// The window starts immediately, so this is for a control that acts the
    /// moment it is claimed. A control that acts when the finger lifts holds
    /// the gate instead, through ``beginPress()`` and ``endPress(cancelled:)``.
    ///
    /// - Returns: `true` when this caller took the gate, `false` when another
    ///   control already holds it.
    @discardableResult
    public func claim() -> Bool {
        guard !isClosed else {
            return false
        }
        isClosed = true
        startWindow()
        return true
    }

    /// Takes the gate for a finger that is still down, and holds it until
    /// ``endPress(cancelled:)``.
    ///
    /// A press can last longer than the window. If the window ran from the
    /// moment the finger landed, the gate would re-open underneath it and a
    /// second finger, already resting on another row, would be answered after
    /// all — which is the one thing the gate exists to prevent. So a held claim
    /// has no timer: the window only starts once the finger lifts.
    ///
    /// - Returns: `true` when this caller took the gate, `false` when another
    ///   control already holds it.
    @discardableResult
    public func beginPress() -> Bool {
        guard !isClosed else {
            return false
        }
        isClosed = true
        releaseTask?.cancel()
        releaseTask = nil
        return true
    }

    /// Ends a held claim: starts the window, or opens the gate at once when the
    /// press turned out not to be a press at all.
    ///
    /// - Parameter cancelled: `true` when the finger left without acting — it
    ///   scrolled the screen, or slid off the control. Nothing was opened, so
    ///   nothing should be blocked, and the next touch is answered immediately.
    public func endPress(cancelled: Bool) {
        guard isClosed else {
            return
        }

        if cancelled {
            reset()
        } else {
            startWindow()
        }
    }

    /// Opens the gate immediately, for a screen that has finished a transition
    /// early and wants the next touch answered without waiting out the window.
    public func reset() {
        releaseTask?.cancel()
        releaseTask = nil
        isClosed = false
    }

    private func startWindow() {
        releaseTask?.cancel()
        releaseTask = Task { @MainActor [weak self, window] in
            try? await Task.sleep(for: window)
            guard !Task.isCancelled else {
                return
            }
            self?.releaseTask = nil
            self?.isClosed = false
        }
    }
}

public extension View {
    /// Claims `gate` the moment a finger lands and holds it for the whole press.
    ///
    /// For controls whose action is not ours to wrap: they still open, but
    /// nothing else on the screen does. The gate is held while the finger is
    /// down and released a moment after it lifts, so a press longer than the
    /// window cannot let a second finger through.
    ///
    /// A finger that lands and then travels is scrolling, not pressing: the
    /// control will not act, so the gate opens again at once instead of eating
    /// the next tap.
    @MainActor
    func broadClaimsTouch(_ gate: BroadSingleTouchGate) -> some View {
        modifier(BroadSingleTouchClaimModifier(gate: gate))
    }
}

private struct BroadSingleTouchClaimModifier: ViewModifier {
    /// How far a finger may travel and still count as a press rather than a
    /// scroll. Matches the slop SwiftUI itself allows a tap.
    private static let pressSlop: CGFloat = 10

    let gate: BroadSingleTouchGate
    @State private var isPressing = false
    @State private var didTravel = false

    func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if !isPressing {
                        isPressing = true
                        didTravel = false
                        gate.beginPress()
                    }
                    let travel = max(
                        abs(value.translation.width),
                        abs(value.translation.height)
                    )
                    if travel > Self.pressSlop {
                        didTravel = true
                    }
                }
                .onEnded { _ in
                    guard isPressing else {
                        return
                    }
                    isPressing = false
                    gate.endPress(cancelled: didTravel)
                }
        )
    }
}
