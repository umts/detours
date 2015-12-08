require 'rails_helper'

describe PostsController do
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
end
