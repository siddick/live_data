# LiveData

require 'thread'
require 'yaml'


module LiveData
   Channels    = {}

   autoload :Version, 'live_data/version'
   autoload :Channel, 'live_data/channel'
   autoload :User, 'live_data/user'
   autoload :Group, 'live_data/group'
   autoload :ThreadWatch, 'live_data/thread_watch'

   if( defined?(Rails::Engine) )
	   class Engine < Rails::Engine
	   end
   end

   def self.create_channel( name )
      unless( Channels[name] )
         Channels[name] = LiveData::Channel.new( name )
      end
      return Channels[name]
   end

   def self.destroy_channel( name )
      channel = self.get_channel( name )
      channel.destroy()
   end

   def self.get_channel( name, create = true )
      channel = Channels[name]
      if( !channel and create )
         channel = LiveData.create_channel( name )
      end
      return channel
   end

   def self.check_channel( name )
      Channels[name]
   end
   
end

