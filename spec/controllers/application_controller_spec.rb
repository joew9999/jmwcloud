require 'spec_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      raise CanCan::AccessDenied
    end

    def new
      self.stubs(:devise_controller?).returns(true)
      render 'devise/sessions/new'
    end
  end

  describe "catch cancan error" do
    it "should create flash error" do
      get :index
      flash[:error].should_not be_nil
    end

    context "logged in" do
      let(:admin) { Fabricate(:user) }

      before(:each) do
        sign_in(:user, admin)
      end

      it "should redirect" do

        get :index
        response.should redirect_to root_path
      end
    end

    context "not logged in" do
      it "should redirect" do
        get :index
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "#layout_by_resource" do
    it "should use devise layout" do
      get :new
      response.should render_template('layouts/devise')
    end
  end
end
