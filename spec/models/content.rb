require 'spec_helper'

describe Content do
  let(:user) { create(:user) }

  it 'does remove bad words' do
    bad_word = create :word
    status   = Content.create(content: "#{bad_word.name} content" * 100,
                              type: 'status',
                              user: user)

    status.should include('***')
  end
end
