# Changelog

Все заметные изменения BroadExtensions фиксируются здесь. Каждый release
объясняет, что изменилось и почему.

## Unreleased

### Added

- `BroadSingleTouchGate` и `View.broadClaimsTouch(_:)` — экран отвечает на одно
  касание за раз. Первый ответивший контрол забирает gate, и тот остаётся
  закрытым на время жизни нажатия вторым пальцем.

### Почему

SwiftUI доставляет касание каждому контролу под пальцем, поэтому два пальца на
двух строках Settings открывали два экрана. Каждое приложение писало один и тот
же gate заново — файл в 5135 и 5144 совпадал байт в байт.

## 1.0.1

### Changed

- верх README теперь ведёт в актуальную cross-module карту создания
  приложения, не добавляя в utility-модуль чужие product workflows;
- README получил platform-обложку, badges, быстрый маршрут и наглядную карту
  независимого подключения продукта;
- сохранены только актуальные helper-примеры, без переноса monetization/UI
  материалов из старого монолита.

### Почему

После федерации README оставался технически полным, но визуально не показывал,
почему Extensions подключается отдельно. Новая подача объясняет ownership и
dependency boundary с первого экрана.

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
