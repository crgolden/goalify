describe Goal do

  before { @goal = create :goal }

  subject { @goal }

  it { is_expected.to respond_to :title }
  it { is_expected.to respond_to :text }
  it { is_expected.to respond_to :user }
  it { is_expected.to respond_to :comments }
  it { is_expected.to respond_to :scores }
  it { is_expected.to respond_to :subscribers }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :comments }
  it { is_expected.to have_and_belong_to_many :subscribers }

end
