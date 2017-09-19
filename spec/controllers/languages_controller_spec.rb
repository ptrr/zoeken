require 'rails_helper'

RSpec.describe LanguagesController, type: :controller do

  before :all do
    
  end

  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
    context "with query parameters" do
      render_views
      it "has a 200 status code" do
        get :index, params: { query: "interpreted BASIC" }
        expect(response.status).to eq(200)
        expect(response.body).to match /BASIC/
        expect(response.body).not_to match /Visual/
      end
      context "with combined terms" do
        it "has a 200 status code with correct results" do
          get :index, params: { query: 'Interpreted "Thomas Eugene"' }
          expect(response.status).to eq(200)
          expect(response.body).to match /BASIC/
          expect(response.body).not_to match /Haskell/
        end
      end
      context "with negative params" do
        it "has a 200 status code with correct results" do
          get :index, params: { query: "john -array" }
          expect(response.status).to eq(200)
          expect(response.body).to match /BASIC/
          expect(response.body).to match /Haskell/
          expect(response.body).to match /Lisp/
          expect(response.body).to match /S-Lang/
          expect(response.body).not_to match /Chapel/
          expect(response.body).not_to match /Fortran/
        end
      end
    end
  end

  describe "GET search" do
    it "has a 200 status code" do
      get :search
      expect(response.status).to eq(200)
    end

    context "with search" do
      render_views
      describe "GET index" do
        it "has a widgets related heading" do
          get :search, params: { query: "basic" }
          expect(response.body).to match /BASIC/
        end
      end
    end
  end

end
