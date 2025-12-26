describe Fastlane::Actions::RustoreAction do
  describe '#run' do
    let(:action) { Fastlane::Actions::RustoreAction }
    RUSTORE_PACKAGE_NAME = ENV["RUSTORE_PACKAGE_NAME"]
    RUSTORE_KEY_ID = ENV["RUSTORE_KEY_ID"]
    RUSTORE_PRIVATE_KEY = ENV["RUSTORE_PRIVATE_KEY"]
    RUSTORE_PUBLISH_TYPE = ENV["RUSTORE_PUBLISH_TYPE"]
    RUSTORE_AAB = ENV["RUSTORE_AAB"]
    RUSTORE_CHANGELOG_PATH = ENV["RUSTORE_CHANGELOG_PATH"]
    it 'get 200 response' do
      Fastlane::UI.message("The rustore plugin is working!")
      expect(Fastlane::UI).to receive(:message).with("The rustore plugin is working!")
      action.run(
        aab: RUSTORE_AAB,
        package_name: RUSTORE_PACKAGE_NAME,
        key_id: RUSTORE_KEY_ID,
        private_key: RUSTORE_PRIVATE_KEY,
        changelog_path: RUSTORE_CHANGELOG_PATH
      )
    end
  end
end
