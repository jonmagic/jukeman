ActionController::Routing::Routes.draw do |map|
  # songs
  map.list      '/songs/list', :controller => 'songs', :action => 'list'
  map.import    '/songs/import', :controller => 'songs', :action => 'import'
  map.resources :songs
  # playlists
  map.add_song_to_playlist  '/playlists/:playlist_id/add/:song_id', :controller => 'playlists', :action => 'add'
  map.resources             :playlists
  # locations
  map.resources :locations do |location|
    location.resources :player
  end
  map.resources :player
  # defaults
  map.root :controller => 'songs', :action => 'index'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
