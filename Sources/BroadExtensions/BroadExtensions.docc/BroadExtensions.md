# ``BroadExtensions``

Small, independent SwiftUI and UIKit helpers for BroadApps iPhone applications.

## Overview

Use BroadExtensions only in targets that need its helpers. The module has no
dependency on BroadCore, BroadMonetization, or BroadUIFlows.

## Topics

### Colors

- ``BroadRGBAColor``

### Fonts

- ``BroadFontRegistrar``
- ``BroadFontRegistrationError``

### Touch arbitration

- ``BroadSingleTouchGate``

## SwiftUI and UIKit extensions

The module also exposes `Color.init(broadHex:)`, `UIColor.init(broadHex:)`,
Dynamic Type font helpers, `View.broadDismissKeyboardOnTap()`,
`View.broadInteractiveSwipeBack()`, and `View.broadClaimsTouch(_:)`.
