# BroadExtensions

BroadExtensions — независимый product с малыми SwiftUI/UIKit helpers. Он не
является скрытой зависимостью остальных модулей: host app добавляет его напрямую,
если использует public API.

## Hex parsing

`BroadRGBAColor` принимает формы RGB, RGBA, RRGGBB и RRGGBBAA, игнорирует `#` и
краевые пробелы. Другие длины или не-hex символы возвращают `nil`.

`Color(broadHex:)` и `UIColor(broadHex:)` используют тот же parser, поэтому
SwiftUI/UIKit не расходятся в трактовке alpha.

## Fonts

`BroadFontRegistrar` регистрирует список font resources в явно переданном
`Bundle`. Отсутствующий resource и ошибка CoreText возвращаются через
`BroadFontRegistrationError`.

`Font.broadCustom` и `UIFont.broadCustom` поддерживают Dynamic Type scaling.

## Keyboard

`broadDismissKeyboardOnTap()` использует simultaneous gesture. Он не должен
забирать tap у Button, Link или другого дочернего control.

## Navigation

`broadInteractiveSwipeBack()` устанавливает bridge только для hosting navigation
controller. Он сохраняет предыдущий delegate, разрешает gesture лишь когда в
stack больше одного controller и восстанавливает delegate при dismantle.

Глобальный swizzling запрещён.

## Проверка

```bash
bash Scripts/module_gate.sh
```

Реальное приложение дополнительно проверяет helper в своём UI и конфигурации.
