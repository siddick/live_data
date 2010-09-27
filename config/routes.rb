Rails::Application.routes.draw do
	get 'live_data/:channel_id/:user_id(.:format)' => LiveDataController.action(:get)
	get 'live_data/:channel_id/:user_id/put' => LiveDataController.action(:put)
	put 'live_data/:channel_id/:user_id' => LiveDataController.action(:put)
	post 'live_data/:channel_id/:user_id' => LiveDataController.action(:put)
end
