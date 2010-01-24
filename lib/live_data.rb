# LiveData

require 'live_data/channel'
require 'live_data/user'
require 'live_data/group'
module LiveData
	Channels 		= {}

	def self.register( name )
		Channels[name] = LiveData::Channel.new( name )
	end

	def self.un_register( name )
		channel = self.get()
		channel.destroy()
	end

	def self.get( name )
		channel = Channels[name]
		unless( channel )
			channel = LiveData.register( name )
		end
		return channel
	end
	
end
