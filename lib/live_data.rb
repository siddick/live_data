# LiveData

require 'live_data_place'
require 'live_data_user'
require 'live_data_group'
module LiveData
	Places 		= {}

	def self.register( name )
		Places[name] = LiveDataPlace.new( name )
	end

	def self.un_register( name )
		place = self.get()
		place.destroy()
	end

	def self.get( name )
		place = Places[name]
		unless( place )
			place = LiveData.register( name )
		end
		return place
	end
	
end
