require 'rails_helper'

describe RoutesController do
  describe 'GET #all' do
    before :each do
      # These tests are only substantive if we have routes
      5.times { create :route }
    end
    let :submit do
      get :all, format: @format
    end
    context 'json format' do
      before :each do
        @format = :json
      end
      it 'does not require current user' do
        submit
        expect(response).not_to have_http_status :unauthorized
      end
      it 'renders all routes as JSON' do
        submit
        expect(response.body).to eql Route.all.to_json
      end
    end
    context 'xml format' do
      before :each do
        @format = :xml
      end
      it 'does not require current user' do
        submit
        expect(response).not_to have_http_status :unauthorized
      end
      it 'renders all routes as XML' do
        submit
        expect(response.body).to eql Route.all.to_xml
      end
    end
  end

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
      end
      it 'does not create a route, gives flash errors, and redirects back' do
        expect { submit }.to redirect_back
        expect { submit }.not_to change { Route.count }
        expect(flash[:errors]).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @route = create :route
      when_current_user_is :whoever
    end
    let :submit do
      delete :destroy, id: @route.number
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
      get :edit, id: @route.number
    end
    it 'finds the correct route' do
      submit
      expect(assigns.fetch :route).to eql @route
    end
    it 'renders the edit template' do
      submit
      expect(response).to render_template :edit
    end
    context 'invalid route number given' do
      it 'raises ActiveRecord::RecordNotFound in the usual Rails style' do
        bad_number = Route.pluck(:number).map(&:to_i).sort.last + 1
        expect { get :edit, id: bad_number }
          .to raise_error ActiveRecord::RecordNotFound,
                          "Couldn't find route with number #{bad_number}"
      end
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

  describe 'GET #posts' do
    before :each do
      @route = create :route
      stub_social_media_requests do
        3.times { create :post, routes: [@route] }
      end
    end
    let :submit do
      get :posts, id: @route.number, format: @format
    end
    context 'json format' do
      before :each do
        @format = :json
      end
      it 'does not require a current user' do
        submit
        expect(response).not_to have_http_status :unauthorized
      end
      it 'renders the posts of the route as JSON (text only)' do
        submit
        expect(response.body).to eql @route.posts.to_json(only: :text)
      end
    end
    context 'xml format' do
      before :each do
        @format = :xml
      end
      it 'does not require a current user' do
        submit
        expect(response).not_to have_http_status :unauthorized
      end
      it 'renders the posts of the route as JSON (text only)' do
        submit
        expect(response.body).to eql @route.posts.to_xml(only: :text)
      end
    end
  end

  describe 'POST #update' do
    before :each do
      @route = create :route
      @changes = { name: 'Different name' }
      when_current_user_is :whoever
    end
    let :submit do
      post :update, id: @route.number, route: @changes
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
      end
      it 'does not update the route, includes errors, and redirects back' do
        expect { submit }.to redirect_back
        expect { submit }
          .not_to change { @route.reload.name }
        expect(flash[:errors]).not_to be_empty
      end
    end
  end
end
