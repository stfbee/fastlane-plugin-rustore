require 'fastlane/action'
require "fastlane_core/ui/ui"

module Fastlane
  module Actions
    class RustoreAction < Action
      def self.authors
        ["Vladislav Onishchenko"]
      end

      def self.description
        "Rustore fastlane integration plugin"
      end

      def self.run(params)
        package_name = params[:package_name]
        key_id = params[:key_id]
        private_key = params[:private_key]
        publish_type = params[:publish_type]
        changelog_path = params[:changelog_path]
        aab = params[:aab]
        gms_apk = params[:gms_apk]

        # Получение токена
        token = Helper::RustoreHelper.get_token(key_id: key_id, private_key: private_key)
        # Создание черновика
        draft_id = Helper::RustoreHelper.create_draft(token, package_name, publish_type, changelog_path)
        # Загрузка aab
        if aab
          Helper::RustoreHelper.upload_app(token, draft_id, false, aab, package_name, true)
          # Если нет aab, то загружаем апк
        else gms_apk
          Helper::RustoreHelper.upload_app(token, draft_id, false, gms_apk, package_name, false)
        end
        # Отправка на модерацию
        Helper::RustoreHelper.commit_version(token, draft_id, package_name)
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :package_name,
                                       env_name: "RUSTORE_PACKAGE_NAME",
                                       description: "пакет приложения, например `com.example.example`",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :key_id,
                                       env_name: "RUSTORE_KEY_ID",
                                       description: "идентификатор приватного ключа в русторе",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :private_key,
                                       env_name: "RUSTORE_PRIVATE_KEY",
                                       description: "приватный ключ в русторе",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :publish_type,
                                       env_name: "RUSTORE_PUBLISH_TYPE",
                                       description: "Тип публикации (MANUAL, DELAYED, INSTANTLY). По умолчанию - INSTANTLY",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :aab,
                                      env_name: "RUSTORE_AAB",
                                      description: "путь до aab",
                                      optional: true),
          FastlaneCore::ConfigItem.new(key: :gms_apk,
                                       env_name: "RUSTORE_GMS_APK",
                                       description: "путь до апк с гуглсервисами",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :changelog_path,
                                       env_name: "RUSTORE_CHANGELOG_PATH",
                                       description: "путь до файла .txt с описанием Что нового?",
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end