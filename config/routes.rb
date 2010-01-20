ActionController::Routing::Routes.draw do |map|
  map.import    '/songs/import', :controller => 'songs', :action => 'import'
  map.resources :songs
  map.add_song_to_playlist  '/playlists/:playlist_id/add/:song_id', :controller => 'playlists', :action => 'add'
  map.resources             :playlists
  map.root :controller => 'songs', :action => 'index'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
