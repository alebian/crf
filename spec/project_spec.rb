require 'spec_helper'

describe 'Crf Project' do
  context 'when checking the gem version' do
    let(:version) { Crf::VERSION }

    it 'is the correct version' do
      expect(version).to eq('0.0.7')
    end
  end
end
