require 'rails_helper'

describe PostsController do
  describe 'POST #create' do
    before :each do
      @attributes = attributes_for :post
      # Controller expects stringified route IDs
      @attributes[:routes] = Array((create :route).id.to_s)
      when_current_user_is :whoever
    end
    let :submit do
      post :create, post: @attributes
    end
    context 'without errors' do
      it 'creates a post' do
        expect { submit }.to change { Post.count }.by 1
      end
      it 'redirects to the index' do
        submit
        expect(response).to redirect_to posts_url
      end
    end
    context 'with errors' do
      before :each do
        # invalid text
        @attributes[:text] = nil
        # Need an HTTP_REFERER for it to redirect back
        @back = 'http://test.host/redirect'
        request.env['HTTP_REFERER'] = @back
      end
      it 'does not create a post' do
        expect { submit }.not_to change { User.count }
      end
      it 'gives some errors in the flash' do
        submit
        expect(flash[:errors]).not_to be_empty
      end
      it 'redirects back' do
        submit
        expect(response).to redirect_to @back
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @post = create :post
      when_current_user_is :whoever
    end
    let :submit do
      delete :destroy, id: @post.id
    end
    it 'finds the correct post' do
      submit
      expect(assigns.fetch :post).to eql @post
    end
    it 'destroys the post' do
      expect_any_instance_of(Post)
        .to receive :destroy
      submit
    end
    it 'redirects to the index' do
      submit
      expect(response).to redirect_to posts_url
    end
  end

  describe 'GET #edit' do
    before :each do
      @post = create :post
      when_current_user_is :whoever
    end
    let :submit do
      get :edit, id: @post.id
    end
    it 'finds the correct post' do
      submit
      expect(assigns.fetch :post).to eql @post
    end
    it 'populates the routes variable with ordered routes' do
      expect(Route).to receive(:order)
        .with(:property, :number).and_return 'whatever'
      submit
      expect(assigns.fetch :routes).to eql 'whatever'
    end
    it 'renders the edit template' do
      submit
      expect(response).to render_template :edit
    end
  end

  describe 'GET #index' do
    let :submit do
      get :index
    end
    context 'normal requests' do
      before :each do
        when_current_user_is :whoever
      end
      it 'populates the post variable with current posts' do
        expect(Post).to receive(:current).and_return 'whatever'
        submit
        expect(assigns.fetch :posts).to eql 'whatever'
      end
      it 'renders the index template' do
        submit
        expect(response).to render_template :index
      end
    end
    context 'fcIdNumber in request' do
      before :each do
        @user = create :user
        request.env['fcIdNumber'] = @user.spire
      end
      it 'assigns the correct current user' do
        submit
        expect(assigns.fetch :current_user).to eql @user
      end
      it 'renders the correct template' do
        submit
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #new' do
    before :each do
      when_current_user_is :whoever
    end
    let :submit do
      get :new
    end
    it 'populates the routes variable with ordered routes' do
      expect(Route).to receive(:order)
        .with(:property, :number).and_return 'whatever'
      submit
      expect(assigns.fetch :routes).to eql 'whatever'
    end
    it 'renders the new template' do
      submit
      expect(response).to render_template :new
    end
  end

  describe 'POST #update' do
    before :each do
      @post = create :post
      @changes = { text: 'Different text' }
      # Controller expects stringified route IDs
      @changes[:routes] = Array('')
      when_current_user_is :whoever
    end
    let :submit do
      post :update, id: @post.id, post: @changes
    end
    context 'without errors' do
      it 'updates the post' do
        submit
        expect(@post.reload.text).to eql @changes[:text]
      end
      it 'redirects to the index' do
        submit
        expect(response).to redirect_to posts_url
      end
    end
    context 'with errors' do
      before :each do
        # incorrect text
        @changes[:text] = nil
        # Need an HTTP_REFERER for it to redirect back
        @back = 'http://test.host/redirect'
        request.env['HTTP_REFERER'] = @back
      end
      it 'does not update the post' do
        expect { submit }
          .not_to change { @post.reload.text }
      end
      it 'includes errors in the flash' do
        submit
        expect(flash[:errors]).not_to be_empty
      end
      it 'redirects back' do
        submit
        expect(response).to redirect_to @back
      end
    end
  end
end
