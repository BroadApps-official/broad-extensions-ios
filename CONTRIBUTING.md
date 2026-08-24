# Как предложить изменение

Repository и документация публичны. Любой разработчик может сделать fork,
создать branch и открыть pull request.

Перед PR:

1. держите изменение в границах небольших независимых helpers;
2. не добавляйте app-owned identifiers, keys, secrets или персональные данные;
3. обновите README/DocC/Gallery и `CHANGELOG.md`, если меняется behavior/API;
4. запустите `bash Scripts/module_gate.sh`;
5. опишите в PR, что изменилось, почему и какие проверки прошли.

Изменения public API проходят review владельца модуля. Unit/UI test targets,
`Tests/`, XCTest и Swift Testing не добавляются; используйте executable contract
probes и sandbox.
