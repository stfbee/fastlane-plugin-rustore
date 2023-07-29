# Fastlane Rustore plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-rustore)

## Getting Started

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
        version_name: "1.0.0 (102)",
        company_id: "123123",
        private_key: "MIIE....."
    )
```

* `gms_apk` - путь до .apk, который лучше скачать с гугл плея, у фастлейна даже есть для этого [инструмент](https://docs.fastlane.tools/actions/download_from_play_store/)
* `hms_apk` - путь до .apk с Huawei-сервисами (опционально). У Рустора пока все плохо с документацией об этом, но залить его можно, что получится - пока хз. 
* `package_name` и `version_name` - знаешь где брать
* `company_id` и `private_key` надо взять в админке рустора, доступ к ним имеет только оунер.

## Ссылочки
* [_fastlane_](https://github.com/fastlane/fastlane)
* [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/)
* [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/)
* [Rustore API](https://help.rustore.ru/rustore/for_developers/work_with_RuStore_API)
