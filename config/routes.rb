ActionController::Routing::Routes.draw do |map|
  map.resources :locations

  map.clone_db '/journals/clone', :controller => 'journals', :action => 'clone'
  map.resources :journals

  map.import_from_folder '/songs/import_from_folder', :controller => 'songs', :action => 'import_from_folder'
  map.resources :songs
  map.activate_playlist '/playlists/:id/activate', :controller => 'playlists', :action => 'activate'
  map.resources :playlists do |playlist|
    map.resources :items
  end
  
  map.resources :items, :collection => { :sort => :put }

  map.root :controller => 'songs', :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
