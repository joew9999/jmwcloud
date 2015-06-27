require 'spec_helper'

describe PeopleController, type: :controller do
  let(:user) { Fabricate(:user) }

  before(:each) do
    sign_in(:user, user)
  end

  describe "GET index" do
    it "should return all people" do
      3.times { Fabricate(:person) }

      get :index
      assigns(:people).count.should == 3
    end
  end

  describe "POST create" do
    context "normal create" do
      it "should redirect" do
        post :create, person: {first_name: 'test'}
        response.should redirect_to people_path
      end
    end

    context "csv import no file" do
      it "should redirect" do
        post :create, person: {first_name: 'test'}, import: 'import'
        response.should redirect_to people_path
      end

      it "should flash notice" do
        post :create, person: {first_name: 'test'}, import: 'import'
        flash[:notice].should == PeopleController::NO_FILE
      end
    end

    context "csv import with file" do
      it "should redirect" do
        post :create, person: {first_name: 'test'}, import: 'import', file: fixture_file_upload('files/people_good.csv', 'text/csv')
        response.should redirect_to people_path
      end

      it "should create people" do
        post :create, person: {first_name: 'test'}, import: 'import', file: fixture_file_upload('files/people_good.csv', 'text/csv')
        Person.all.count.should == 4281
      end
    end
  end
end