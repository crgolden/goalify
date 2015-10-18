describe Goal do
  before { @user = create :user }
  before :each do
    attr = {title1: 'A Plasma TV', title2: 'Fastest Laptop', title3: 'MP3 Player', title4: 'LCD TV'}
    @goal1 = create :goal, title: attr[:title1], user: @user
    @goal2 = create :goal, title: attr[:title2], user: @user
    @goal3 = create :goal, title: attr[:title3], user: @user
    @goal4 = create :goal, title: attr[:title4], user: @user
  end

  subject { @goal1 }

  it { is_expected.to respond_to :title }
  it { is_expected.to respond_to :text }
  it { is_expected.to respond_to :user }
  it { is_expected.to respond_to :comments }
  it { is_expected.to respond_to :scores }
  it { is_expected.to respond_to :subscriptions }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :comments }
  it { is_expected.to have_many :scores }
  it { is_expected.to have_many :subscriptions }

  describe '.recent' do

    before :each do
      @goal2.touch
      @goal3.touch
    end

    it 'returns the most updated records' do
      expect(Goal.recent).to match_array [@goal3, @goal2, @goal4, @goal1]
    end
  end

end
