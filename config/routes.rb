ActionController::Routing::Routes.draw do |map|
  map.resource :reminder_configuration, :controller => 'reminder_configuration',
               :only => [:edit, :update]
end
