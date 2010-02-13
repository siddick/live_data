module LiveData

   # Group is used to maintain collection of users
   # ==== Example 
   #
   #    chat     = LiveData::Channel.new
   #    guest1   = chat.create_user('guest1')
   #    guest2   = chat.create_user('guest2')
   #   user_grp = chat.create_group('user')
   #
   #   user_grp.add_user( guest1 )
   #   user_grp.add_user( guest2 )
   #
   #   user_grp.write( { :title => "Greeting", 
   #      :message => "Wecome to LiveData" } )
   #
   #   group1.read      #  { :title => "Greeti..... }
   #   group2.read      #  { :title => "Greeti..... }
   class Group

      attr :users, :name

      # Create a group
      def initialize( name = nil, channel = nil )
         @name    = name || self
	 @channel = channel
         @users = []
      end

      # Write data, which contain yaml format
      def write_yaml( yaml_data )
         @users.each{|user|
            user.write_yaml( yaml_data )
         }
      end

      # Write data, which contain json format
      def write_json( json_data )
         @users.each{|user|
            user.write_json( json_data )
         }
      end

      # Write any object
      def write( data )
         @users.each{|user|
            user.write( data )
         }
      end

      # Add user to the group
      def add_user( user )
         @users.push( user )
         user.groups.push( self )
      end

      # Delete user from the group
      def remove_user( user )
         @users.delete( user )
         user.groups.delete( self )
      end

      def destroy
         @users.each{|user|
            user.groups.delete( self )
         }
	 if( @channel )
		 @channel.groups.delete( @name ) 
		 @channel.group_have_users.delete( @name )
	 end
      end
   end
end

