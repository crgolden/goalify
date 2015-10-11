describe Goal do
  before { @goal = create :goal }

  subject { @goal }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:text) }
  it { is_expected.to respond_to(:comments) }
  it { is_expected.to respond_to(:user) }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many(:comments) }
end