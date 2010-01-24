# Uninstall hook code here

require 'fileutils'
dir = File.dirname(__FILE__)
to_place   = File.dirname(__FILE__) + '/../../../public/javascripts/live_data.js'
begin
	FileUtils.remove_file( to_place );
rescue => err
end
