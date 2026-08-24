# BroadExtensions agent rules

- Меняйте только этот repository.
- Модуль содержит независимые UI/Foundation helpers без бизнес-логики и других
  BroadApps dependencies.
- Не добавляйте `Tests/`, test targets, XCTest, Swift Testing или UI test target.
- Для behavior используйте executable probes и Gallery.
- Не добавляйте secrets, real IDs, credentials или персональные данные.
- Public API меняется с документацией, Gallery, changelog и SemVer intent.
- Swift-файлы форматируются перед проверкой.
- Перед сдачей обязательно выполните `bash Scripts/module_gate.sh`.
- Не заявляйте PASS, если последняя полная команда gate не завершилась успешно.
