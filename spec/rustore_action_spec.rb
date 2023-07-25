describe Fastlane::Actions::RustoreAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The rustore plugin is working!")

      Fastlane::Actions::RustoreAction.run(nil)
    end
  end
end
