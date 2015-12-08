require 'spec_helper'

describe 'Crf RepetitionsList' do
  describe 'adding items' do
    let!(:list) { Crf::RepetitionsList.new }
    let!(:path_1) { '/test/path/file' }
    let!(:path_2) { path_1 }

    it 'adds elements' do
      list.add('test', path_1)
      expect(list.uniques['test']).to eq(path_1)
    end

    it 'finds repetitions' do
      list.add('test', path_1)
      list.add('test', path_2)
      expect(list.repetitions.empty?).to be_falsey
    end

    it 'deletes the uniques when find repetitions' do
      list.add('test', path_1)
      list.add('test', path_2)
      expect(list.uniques.empty?).to be_truthy
    end
  end
end
