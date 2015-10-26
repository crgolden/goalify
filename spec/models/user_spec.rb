describe User do

  before { @user = create :user }

  subject { @user }

  it { is_expected.to respond_to(:authentication_token) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to be_valid }
  it { is_expected.to validate_uniqueness_of(:authentication_token) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value(Faker::Internet.email).for(:email) }
  it { is_expected.to have_many(:goals) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:tokens) }

end
