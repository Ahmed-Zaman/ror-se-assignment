require 'rails_helper'

RSpec.describe BlogsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) do
    {
      title: "Test Blog",
      body: "Test Content"
    }
  end

  let(:invalid_attributes) do
    {
      title: "",
      body: ""
    }
  end

  context 'when user is not signed in' do
    it 'redirects to login page for index' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to login page for show' do
      blog = FactoryBot.create(:blog, user: user)
      get :show, params: { id: blog.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to login page for new' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to login page for create' do
      post :create, params: { blog: valid_attributes }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is signed in' do
    before { sign_in user }

    describe "GET #index" do
      it "returns a successful response" do
        get :index
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a successful response" do
        blog = FactoryBot.create(:blog, user: user)
        get :show, params: { id: blog.id }
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a successful response" do
        get :new
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "returns a successful response" do
        blog = FactoryBot.create(:blog, user: user)
        get :edit, params: { id: blog.id }
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Blog" do
          expect {
            post :create, params: { blog: valid_attributes }
          }.to change(Blog, :count).by(1)
        end

        it "redirects to the created blog" do
          post :create, params: { blog: valid_attributes }
          expect(response).to redirect_to(Blog.last)
        end
      end
    end

    describe "PUT #update" do
      let(:blog) { FactoryBot.create(:blog, user: user) }
      let(:new_attributes) { { title: "Updated Title" } }

      context "with valid params" do
        it "updates the requested blog" do
          put :update, params: { id: blog.id, blog: new_attributes }
          blog.reload
          expect(blog.title).to eq("Updated Title")
        end

        it "redirects to the blog" do
          put :update, params: { id: blog.id, blog: new_attributes }
          expect(response).to redirect_to(blog)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested blog" do
        blog = FactoryBot.create(:blog, user: user)
        expect {
          delete :destroy, params: { id: blog.id }
        }.to change(Blog, :count).by(-1)
      end

      it "redirects to the blogs list" do
        blog = FactoryBot.create(:blog, user: user)
        delete :destroy, params: { id: blog.id }
        expect(response).to redirect_to(blogs_path)
      end
    end
  end
end 