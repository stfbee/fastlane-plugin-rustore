# Fastlane Rustore plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-rustore) [![stability-wip](https://img.shields.io/badge/stability-wip-lightgrey.svg)](https://github.com/mkenney/software-guides/blob/master/STABILITY-BADGES.md#work-in-progress)

## Дисклеймер

Пока что реализован базовый функционал с заливкой апк и aab. Скриншоты, описание и прочие материалы наследуются от предыдущего релиза. При неудачной выгрузке файла ошибка выгрузки прокидывается наружу, удобно для проверки результата. Если у вас уже есть черновик релиза, берется айдишник этого черновика и сборка выгружается в него. Если случилась ошибка где-то на этапе заливки, то останется черновик, удалить его лучше с помощью [питонскрипта](https://github.com/stfbee/python-rustore-api), а экшен удаления тут будет чуть позже.

Также есть признаки того, что заливать апк из вне РФ больше нельзя (смотри [#2](https://github.com/stfbee/fastlane-plugin-rustore/issues/2)), так что выбирайте раннер, где будет запускаться скрипт.

## Поехали

Для начала добавь плагин в ваш fastlane проект:

```bash
fastlane add_plugin rustore
```

После чего в каком-нибудь лейне дергай экшен плагина:

```
    rustore(
        aab: "../../app-release.aab",
        gms_apk: "../../app-release.apk",
        package_name: "com.example.example",
        publish_type: "MANUAL",
        key_id: "123123",
        private_key: "MIIE.....",
        changelog_path: "./metadata/android/ru-RU/changelogs/default.txt"
    )
```

- `aab` - путь до .aab (если указан, то вместо gms_apk будет загружен только aab)
- `gms_apk` - путь до .apk, который лучше скачать с гугл плея, у фастлейна даже есть для этого [инструмент](https://docs.fastlane.tools/actions/download_from_play_store/)
- `package_name` - название пакета
- `publish_type` - тип публикации (MANUAL - ручная, DELAYED - отложенная, INSTANTLY - автоматическая после модерации). По умолчанию - INSTANTLY
- `key_id` и `private_key` надо взять в админке рустора, доступ к ним имеет только оунер
- `changelog_path` - путь до текстового файла с текстом Что нового? (должен быть не более 500 символов)

## Ссылочки

- [_fastlane_](https://github.com/fastlane/fastlane)
- [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/)
- [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/)
- [Rustore API](https://help.rustore.ru/rustore/for_developers/work_with_RuStore_API)
