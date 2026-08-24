# Changelog

Все заметные изменения BroadExtensions фиксируются здесь. Каждый release
объясняет, что изменилось и почему.

## Unreleased

Пока нет изменений.

## 1.0.0

### Added

- Hex parser и SwiftUI/UIKit color initializers;
- typed custom-font registration и Dynamic Type helpers;
- simultaneous keyboard-dismiss modifier;
- scoped interactive swipe-back без global swizzling;
- standalone Gallery, executable contract probe, DocC и module gate.

### Почему

Независимые helpers вынесены из общего package первыми, чтобы host app мог
подключать только нужный небольшой product, а review и release не затрагивали
Core, Monetization или UIFlows.
