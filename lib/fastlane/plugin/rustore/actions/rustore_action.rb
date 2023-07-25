require 'fastlane/action'
require_relative '../helper/rustore_helper'

module Fastlane
  module Actions
    class RustoreAction < Action
      def self.run(params)
        UI.message("The rustore plugin is working!")
      end

      def self.description
        "Rustore fastlane integration plugin"
      end

      def self.authors
        ["Vladislav Onishchenko"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "RUSTORE_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
