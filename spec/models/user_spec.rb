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

  describe "full name" do
    let!(:user) { create(:user, first_name: "Foo", last_name: "Bar") }
    let!(:user_with_no_first_name) { create(:user, last_name: "Moo", first_name: nil) }

    context "user has first and last name" do
      it "should return full name" do
        expect(user.name).to eq("Foo Bar")
      end
    end

    context "user has no first name" do
      it "should return last name only" do
        expect(user_with_no_first_name.name).to eq("Moo")
      end
    end
  end
end
