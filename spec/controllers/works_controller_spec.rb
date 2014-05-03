require 'spec_helper'

describe WorksController do
  login_admin
  it "should have a current_user" do
    # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
    subject.current_user.should_not be_nil
  end

  describe "GET index" do

  end
end
