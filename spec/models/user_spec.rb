require 'rails_helper'

describe User do

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should allow_value("user@foo.COM", "A_US-ER@f.b.org", "frst.lst@foo.jp", "a+b@baz.cn").for(:email) }
  it { should_not allow_value("user@foo,com", "user_at_foo.org", "example.user@foo.", "foo@bar_baz.com", "foo@bar+baz.com").for(:email) }
end
