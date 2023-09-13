require 'rails_helper'

RSpec.describe Food, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of :name }
  end

  context 'associations' do
    it { should belong_to(:basket).class_name('Basket') }
  end
end