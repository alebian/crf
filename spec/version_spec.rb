require 'spec_helper'

describe Crf::VERSION do
  let(:version) { Crf::VERSION }

  it 'is the correct version' do
    expect(version).to eq('0.1.0')
  end
end
