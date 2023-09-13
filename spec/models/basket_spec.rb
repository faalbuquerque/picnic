# frozen_string_literal: true

require  'rails_helper'

RSpec.describe Basket, type: :model  do
  context 'validations' do
    it { is_expected.to validate_presence_of :name }
  end

  context 'associations' do
    it { should have_many(:foods).class_name('Food') }
  end
end
