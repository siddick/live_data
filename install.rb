# Install hook code here

require 'fileutils'
dir = File.dirname(__FILE__)
from_place = File.dirname(__FILE__) + '/js/live_data.js'
to_place   = File.dirname(__FILE__) + '/../../../public/javascripts/live_data.js'
FileUtils.copy_file( from_place, to_place );
