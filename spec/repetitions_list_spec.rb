require 'spec_helper'

describe 'Crf RepetitionsList' do
  let!(:list) { Crf::RepetitionsList.new }
  let!(:path_1) { FILE_PATHS[0] }
  let!(:path_2) { path_1 }

  context 'when adding items' do
    before :each do
      list.add('test', path_1)
    end
    it 'adds elements' do
      expect(list.uniques['test']).to eq(path_1)
    end
    it 'finds repetitions' do
      list.add('test', path_2)
      expect(list.repetitions.empty?).to be_falsey
    end
    it 'deletes the uniques when find repetitions' do
      list.add('test', path_2)
      expect(list.uniques.empty?).to be_truthy
    end
  end
end
