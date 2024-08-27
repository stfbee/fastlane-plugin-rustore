describe Fastlane::Actions::RustoreDistributeAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The rustore plugin is working!")

      Fastlane::Actions::RustoreDistributeAction.run(nil)
    end
  end
end
