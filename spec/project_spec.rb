require 'spec_helper'

describe 'Crf Project' do
  describe 'version' do
    let(:version) { Crf::VERSION }

    it 'is the correct version' do
      expect(version).to eq('0.0.2')
    end
  end
end
