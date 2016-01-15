require 'rails_helper'

describe UsersController do
  describe 'POST #create' do
    before :each do
      @attributes = attributes_for :user
      when_current_user_is :whoever
    end
    let :submit do
      post :create, user: @attributes
    end
    context 'without errors' do
      it 'creates a user' do
        expect { submit }.to change { User.count }.by 1
      end
      it 'redirects to the index' do
        submit
        expect(response).to redirect_to users_url
      end
    end
    context 'with errors' do
      before :each do
        # invalid first name
        @attributes[:first_name] = nil
      end
      it 'does not create a user, gives errors, and redirects back' do
        expect { submit }.to redirect_back
        expect { submit }.not_to change { User.count }
        expect(flash[:errors]).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @user = create :user
      when_current_user_is :whoever
    end
    let :submit do
      delete :destroy, id: @user.id
    end
    it 'finds the correct user' do
      submit
      expect(assigns.fetch :user).to eql @user
    end
    it 'destroys the user' do
      expect_any_instance_of(User)
        .to receive :destroy
      submit
    end
    it 'redirects to the index' do
      submit
      expect(response).to redirect_to users_url
    end
  end

  describe 'GET #edit' do
    before :each do
      @user = create :user
      when_current_user_is :whoever
    end
    let :submit do
      get :edit, id: @user.id
    end
    it 'finds the correct user' do
      submit
      expect(assigns.fetch :user).to eql @user
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
    before :each do
      when_current_user_is :whoever
    end
    it 'populates the users variable with ordered users' do
      expect(User).to receive(:order).with(:last_name, :first_name)
        .and_return 'whatever'
      submit
      expect(assigns.fetch :users).to eql 'whatever'
    end
    it 'renders the index template' do
      submit
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before :each do
      when_current_user_is :whoever
    end
    let :submit do
      get :new
    end
    it 'renders the new template' do
      submit
      expect(response).to render_template :new
    end
  end

  describe 'POST #update' do
    before :each do
      @user = create :user
      @changes = { first_name: 'Newname' }
      when_current_user_is :whoever
    end
    let :submit do
      post :update, id: @user.id, user: @changes
    end
    context 'without errors' do
      it 'updates the user' do
        submit
        expect(@user.reload.first_name).to eql @changes[:first_name]
      end
      it 'redirects to the index' do
        submit
        expect(response).to redirect_to users_url
      end
    end
    context 'with errors' do
      before :each do
        # incorrect first name
        @changes[:first_name] = nil
      end
      it 'does not update the user, gives flash errors, and redirects back' do
        expect { submit }.to redirect_back
        expect { submit }
          .not_to change { @user.reload.first_name }
        expect(flash[:errors]).not_to be_empty
      end
    end
  end
end
