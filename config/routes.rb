ActionController::Routing::Routes.draw do |map|
  map.resources :locations

  map.resources :journals

  map.resources :songs
  map.resources :playlists do |playlist|
    map.resources :items
  end
  
  map.resources :items, :collection => { :sort => :put }

  map.root :controller => 'songs', :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
