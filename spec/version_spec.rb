require 'spec_helper'

describe Crf::VERSION do
  let(:version) { Crf::VERSION }

  it 'is the correct version' do
    expect(version).to eq('0.0.8')
  end
end
