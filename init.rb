# Include hook code here

require 'live_data'
#require 'live_data/controller_helper'
require 'live_data/view_helper'

class ActionController::Base
  helper LiveData::ViewHelper
end

ActionView::Helpers::AssetTagHelper.register_javascript_include_default( 'live_data' );
