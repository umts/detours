require 'rails_helper'

describe RoutesController do
  describe 'POST #create' do
    before :each do
      @attributes = attributes_for :route
      when_current_user_is :whoever
    end
    let :submit do
      post :create, route: @attributes
    end
    context 'without errors' do
      it 'creates a route' do
        expect { submit }.to change { Route.count }.by 1
      end
      it 'redirects to the index' do
        submit
        expect(response).to redirect_to routes_url
      end
    end
    context 'with errors' do
      before :each do
        # invalid number
        @attributes[:number] = nil
        # Need an HTTP_REFERER for it to redirect back
        @back = 'http://test.host/redirect'
        request.env['HTTP_REFERER'] = @back
      end
      it 'does not create a routes' do
        expect { submit }.not_to change { Route.count }
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
      @route = create :route
      when_current_user_is :whoever
    end
    let :submit do
      delete :destroy, id: @route.id
    end
    it 'finds the correct route' do
      submit
      expect(assigns.fetch :route).to eql @route
    end
    it 'destroys the route' do
      expect_any_instance_of(Route)
        .to receive :destroy
      submit
    end
    it 'redirects to the index' do
      submit
      expect(response).to redirect_to routes_url
    end
  end

  describe 'GET #edit' do
    before :each do
      @route = create :route
      when_current_user_is :whoever
    end
    let :submit do
      get :edit, id: @route.id
    end
    it 'finds the correct route' do
      submit
      expect(assigns.fetch :route).to eql @route
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
    it 'populates the routes variable with ordered routes' do
      expect(Route).to receive(:order).with(:property, :number)
        .and_return 'whatever'
      submit
      expect(assigns.fetch :routes).to eql 'whatever'
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
      @route = create :route
      @changes = { name: 'Different name' }
      when_current_user_is :whoever
    end
    let :submit do
      post :update, id: @route.id, route: @changes
    end
    context 'without errors' do
      it 'updates the route' do
        submit
        expect(@route.reload.name).to eql @changes[:name]
      end
      it 'redirects to the index' do
        submit
        expect(response).to redirect_to routes_url
      end
    end
    context 'with errors' do
      before :each do
        # incorrect name
        @changes[:name] = nil
        # Need an HTTP_REFERER for it to redirect back
        @back = 'http://test.host/redirect'
        request.env['HTTP_REFERER'] = @back
      end
      it 'does not update the route' do
        expect { submit }
          .not_to change { @route.reload.name }
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
