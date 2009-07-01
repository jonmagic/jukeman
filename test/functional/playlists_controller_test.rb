require 'test_helper'

class PlaylistsController; def rescue_action(e) raise e end; end

class PlaylistsControllerTest < ActionController::TestCase
  context "on GET to :show" do
    setup do
      Factory.create(:rock_n_roll, :id => 1)
      get :show, :id => 1
    end

    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
    
  end
  
  context "on GET to :index" do
    setup do
      Factory.create(:rock_n_roll, :id => 1)
      Factory.create(:playlist, :id => 2)
      get :index
    end
    
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end
  
  context "on GET to :edit" do
    setup do
      Factory.create(:rock_n_roll, :id => 1)
      get :edit, :id => 1
    end

    should_respond_with :success
    should_render_template :edit
    should_not_set_the_flash
  end
  
  context "on POST to :create" do
    setup do
      post :create, :playlist => {:name => "Rock-n-Roll", :description => "we love the music"}
    end
    
    should_redirect_to "playlist_url(@playlist)"
    should_set_the_flash_to(/created/i)
  end
  
  context "on POST to :update" do
    # setup do
    #   playlist = Factory.create(:playlist, :id => )
    #   post :update, :playlist => {:id => playlist.id, :name => "Blues", :description => "are sad"}
    # end
    # 
    # should_redirect_to "playlist_url(@playlist)"
    # should_set_the_flash_to(/updated/i)
    # should "update the playlist" do
    #   assert_equal playlist.name, "Blues"
    #   assert_equal playlist.description, "are sad"
    # end
  end
  
  context "on POST to :destroy" do
    setup do
      @playlist = Factory.create(:playlist, :id => 1)
      post :destroy, :playlist => {:id => @playlist.id, :_method => "put"}
    end

    should "destroy the post" do
      # assert_nil Playlist.find(@playlist.id)
    end
  end
  
  
end
