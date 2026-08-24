# Contributor guide

## Repository boundary

`BroadExtensions` содержит только маленькие переиспользуемые iOS helpers.
Business rules, network, persistence, payments и app navigation принадлежат
другим модулям или host app.

Новая утилита принимается, если:

1. повторяется в нескольких приложениях;
2. имеет узкое имя и понятного владельца;
3. не создаёт global side effects;
4. не требует другого BroadApps-модуля;
5. демонстрируется в Gallery и описана в DocC/README.

## Layout

```text
Sources/BroadExtensions/                  production source + DocC
Examples/BroadExtensionsGallery/         standalone iPhone sandbox
Scripts/ContractProbes/                  executable non-test probes
Documentation/                           guide + public API baseline
Scripts/module_gate.sh                   обязательная проверка
ModuleContract.json                      machine-readable boundary
```

## Public API changes

- additive backwards-compatible API получает minor release;
- fix без изменения контракта получает patch;
- удаление/переименование public API требует major release;
- сначала добавьте замену и переведите consumers, затем удаляйте старое API в
  следующем major;
- обновите `CHANGELOG.md`, DocC, README/Gallery и public API baseline.

## Contract probes

Probe должен компилировать настоящий production type, завершаться ненулевым
exit code при нарушении и не использовать XCTest/Swift Testing. Не дублируйте
production algorithm внутри probe.

```bash
bash Scripts/run_contract_probes.sh
```

## Documentation

Module-specific Markdown и DocC живут рядом с кодом и являются canonical source.
Public docs site добавляет поиск и `Edit this page`, но не заменяет repository.
После правки проверьте относительные ссылки через полный module gate.

## Release

Release notes всегда отвечают на два вопроса: **Что изменилось и почему?**

1. Убедитесь, что changelog объясняет что изменилось и почему.
2. Запустите `bash Scripts/module_gate.sh` на clean checkout.
3. Создайте SemVer tag `x.y.z`.
4. Дождитесь release workflow.
5. Обновите exact version в `broad-platform-integration` и пройдите его gate.
6. Только после integration PASS обновите public compatibility catalog/docs.

Test targets, `Tests/`, XCTest и Swift Testing по решению владельца не
добавляются. Gate использует builds, executable probes и iPhone Gallery.
