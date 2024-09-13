# Fastlane Rustore plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-rustore) [![stability-wip](https://img.shields.io/badge/stability-wip-lightgrey.svg)](https://github.com/mkenney/software-guides/blob/master/STABILITY-BADGES.md#work-in-progress)


## Дисклеймер

Пока что реализован базовый функционал с заливкой апк. Скриншоты, описание и прочие материалы наследуются от предыдущего релиза. Обработки ошибок нет. Если у вас уже есть черновик релиза, то скорей всего ничего не заработает. Черновик, созданный через апи, в админке отображаться не будет. Если случилась ошибка где-то на этапе заливки, то останется черновик, который будет мешать следующему запуску скрипта, удалить его лучше с помощью [питонскрипта](https://github.com/stfbee/python-rustore-api), а экшен удаления тут будет чуть позже.

Также есть признаки того, что заливать апк из вне РФ больше нельзя (смотри [#2](https://github.com/stfbee/fastlane-plugin-rustore/issues/2)), так что выбирайте раннер, где будет запускаться скрипт.

## Поехали

Для начала добавь плагин в ваш fastlane проект:
```bash
fastlane add_plugin rustore
```
После чего в каком-нибудь лейне дергай экшен плагина:
```
    rustore_publish(
        gms_apk: "../../app-release.apk",
        hms_apk: "../../app-release-hms.apk",
        package_name: "com.example.example",
        publish_type: "MANUAL"
        key_id: "123123",
        private_key: "MIIE....."
    )
```

* `gms_apk` - путь до .apk, который лучше скачать с гугл плея, у фастлейна даже есть для этого [инструмент](https://docs.fastlane.tools/actions/download_from_play_store/)
* `hms_apk` - путь до .apk с Huawei-сервисами (опционально). У Рустора пока все плохо с документацией об этом, но залить его можно, что получится - пока хз. 
* `package_name` - название пакета
* `publish_type` - тип публикации (MANUAL - ручная, DELAYED - отложенная, INSTANTLY - автоматическая после модерации). По умолчанию - INSTANTLY. 
* `key_id` и `private_key` надо взять в админке рустора, доступ к ним имеет только оунер.

## Ссылочки
* [_fastlane_](https://github.com/fastlane/fastlane)
* [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/)
* [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/)
* [Rustore API](https://help.rustore.ru/rustore/for_developers/work_with_RuStore_API)
