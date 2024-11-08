require 'fastlane_core/ui/ui'
require 'digest'
require 'json'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class RustoreHelper
      def self.connection
        require 'faraday'
        require 'faraday_middleware'

        options = {
          url: "https://public-api.rustore.ru"
        }

        logger = Logger.new($stderr)
        logger.level = Logger::DEBUG

        Faraday.new(options) do |builder|
          builder.request(:multipart)
          builder.request(:json)
          builder.request(:url_encoded)
          builder.response(:json, content_type: /\bjson$/)
          builder.response(:logger, logger)
          builder.use(FaradayMiddleware::FollowRedirects)
          builder.adapter(:net_http)
        end
      end

      def self.rsa_sign(timestamp, key_id, private_key)
        key = OpenSSL::PKey::RSA.new("-----BEGIN RSA PRIVATE KEY-----\n#{private_key}\n-----END RSA PRIVATE KEY-----")
        signature = key.sign(OpenSSL::Digest.new('SHA512'), key_id + timestamp)
        Base64.encode64(signature)
      end

      def self.get_token(key_id:, private_key:)
        timestamp = DateTime.now.iso8601(3)
        signature = rsa_sign(timestamp, key_id, private_key)
        url = "/public/auth/"
        response = connection.post(url) do |req|
          req.body = { keyId: key_id, timestamp: timestamp, signature: signature }
        end

        UI.message("Debug: response #{response.body}") if ENV['DEBUG']

        response.body["body"]["jwe"]
      end

      def self.create_draft(token, package_name, publish_type, changelog_path)
        changelog = ''
        unless changelog_path.nil?
          changelog_data = File.read(changelog_path)
          if changelog_data.length > 500
            UI.user_error!("Файл 'Что нового?' содержит более 500 символов")
            return
          else
            changelog = changelog_data
          end
        end

        url = "/public/v1/application/#{package_name}/version"
        response = connection.post(url) do |req|
          req.headers['Public-Token'] = token
          req.body = {}
          req.body['publishType'] = publish_type unless publish_type.nil?
          req.body['whatsNew'] = changelog unless changelog_path.nil?
        end

        UI.message("Debug: response #{response.body}") if ENV['DEBUG']
        if response.body["body"]
          # Если черновика не было, и мы создали новый, здесь будет draftId
          return response.body["body"]
        elsif response.body["message"] # when received response.body["code"]: "ERROR"
          # Если черновик уже существовал, в message будет ошибка вида
          # "You already have draft version with ID = XXXXXXXXXX", откуда достаем ID существующего черновика.
          return response.body["message"].scan(/\d+/).first
        else
          raise "Couldn't get draftId from RuStore"
        end
      end

      def self.upload_app(token, draft_id, is_hms, file_path, package_name, is_aab)
        urlEnd = "aab"
        mime = "application/x-authorware-bin"
        unless is_aab
          urlEnd = "apk"
          mime = "application/vnd.android.package-archive"
          apk_type = "Unknown"
          is_main = true
        end
        url = "/public/v1/application/#{package_name}/version/#{draft_id}/#{urlEnd}"
        payload = {}
        payload[:file] = Faraday::Multipart::FilePart.new(file_path, mime)

        response = connection.post(url) do |req|
          req.headers['Public-Token'] = token
          req.params['servicesType'] = apk_type unless apk_type.nil?
          req.params['isMainApk'] = is_main unless is_main.nil?
          req.body = payload
        end

        if response.body["message"] == "File was not uploaded successfully: The code of this version must be larger than that of the previous one"
          raise "Build with this version code was already uploaded earlier"
        end

        UI.message("Debug: response #{response.body}") if ENV['DEBUG']
      end

      def self.commit_version(token, draft_id, package_name)
        url = "/public/v1/application/#{package_name}/version/#{draft_id}/commit"
        response = connection.post(url) do |req|
          req.headers['Public-Token'] = token
        end

        UI.message("Debug: response #{response.body}") if ENV['DEBUG']
      end
    end
  end
end
