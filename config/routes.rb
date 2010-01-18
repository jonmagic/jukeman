ActionController::Routing::Routes.draw do |map|
  map.resources :songs
  map.resources :playlists
  map.root_url '/', :controller => 'songs', :action => 'index'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
