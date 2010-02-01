# LiveData

require 'thread'
require 'yaml'

require 'live_data/version'
require 'live_data/channel'
require 'live_data/user'
require 'live_data/group'
require 'live_data/thread_watch'

module LiveData
   Channels    = {}

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

