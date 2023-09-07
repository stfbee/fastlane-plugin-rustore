require 'fastlane/action'
require "fastlane_core/ui/ui"

module Fastlane
  module Actions
    class RustorePublishAction < Action
      def self.authors
        ["Vladislav Onishchenko"]
      end

      def self.description
        "Rustore fastlane integration plugin"
      end

      def self.run(params)
        package_name = params[:package_name]
        company_id = params[:company_id]
        private_key = params[:private_key]
        gms_apk = params[:gms_apk]
        hms_apk = params[:hms_apk]

        # Получение токена
        token = Helper::RustoreHelper.get_token(company_id: company_id, private_key: private_key)
        # Создание черновика
        draft_id = Helper::RustoreHelper.create_draft(token, package_name)
        # Загрузка апк
        Helper::RustoreHelper.upload_apk(token, draft_id, false, gms_apk, package_name)
        # Если путь до хмс передали, то и его заливаем
        unless hms_apk.nil?
          Helper::RustoreHelper.upload_apk(token, draft_id, true, hms_apk, package_name)
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
          FastlaneCore::ConfigItem.new(key: :company_id,
                                       env_name: "RUSTORE_COMPANY_ID",
                                       description: "айдишник компании в русторе",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :private_key,
                                       env_name: "RUSTORE_PRIVATE_KEY",
                                       description: "приватный ключ в русторе",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :gms_apk,
                                       env_name: "RUSTORE_GMS_APK",
                                       description: "путь до апк с гуглсервисами",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :hms_apk,
                                       env_name: "RUSTORE_HMS_APK",
                                       description: "путь до апк с хуавейсервисами (опционально)",
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
