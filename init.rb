# Include hook code here

require 'live_data'
require 'live_data_controller_helper'
require 'live_data_view_helper'

class ActionController::Base
	helper LiveData::LiveDataViewHelper
end

ActionView::Helpers::AssetTagHelper.register_javascript_include_default( 'live_data' );
