require 'rails_helper'

RSpec.describe Language, type: :model do
  describe Language do
    subject { Language }
    it { should respond_to(:search) }
  end
end
