RedmineApp::Application.routes.draw do
  resource :reminder_configuration,
           controller: 'reminder_configuration',
           only: [:edit, :update]
end
