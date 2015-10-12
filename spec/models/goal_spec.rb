describe Goal do
  before { @user = create :user }
  before :each do
    attr = {title1: 'A Plasma TV', title2: 'Fastest Laptop', title3: 'MP3 Player', title4: 'LCD TV',
            text1: 'Great resolution', text2: 'Lots of games', text3: 'Tons of music', text4: 'Fast processor'}
    @goal1 = create :goal, title: attr[:title1], text: attr[:text1], user: @user
    @goal2 = create :goal, title: attr[:title2], text: attr[:text2], user: @user
    @goal3 = create :goal, title: attr[:title3], text: attr[:text3], user: @user
    @goal4 = create :goal, title: attr[:title4], text: attr[:text4], user: @user
  end

  subject { @goal1 }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:text) }
  it { is_expected.to respond_to(:comments) }
  it { is_expected.to respond_to(:user) }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many(:comments) }

  describe '.filter_by_title' do

    context 'when a \'TV\' title pattern is sent' do

      it 'returns the 2 products matching' do
        expect(Goal.filter_by_title('TV').count).to be 2
      end

      it 'returns the products matching' do
        expect(Goal.filter_by_title('TV').sort).to match_array [@goal1, @goal4]
      end
    end
  end

  describe '.recent' do

    before :each do
      @goal2.touch
      @goal3.touch
    end

    it 'returns the most updated records' do
      expect(Goal.recent).to match_array [@goal3, @goal2, @goal4, @goal1]
    end
  end

  describe '.search' do

    context 'when an empty hash is sent' do
      it 'returns all the goals' do
        expect(Goal.search({})).to match_array [@goal1, @goal2, @goal3, @goal4]
      end
    end

    context 'when goal ids are present' do
      it 'returns the goal from the ids' do
        search_hash = {id: [@goal1.id, @goal2.id]}
        expect(Goal.search search_hash).to match_array [@goal1, @goal2]
      end
    end
  end
end
