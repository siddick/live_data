
module LiveData

   # Channel is used to maintain users, groups and user-group relation
   class Channel

      attr :users, true
      attr :groups, true
      attr :user_in_groups, true
      attr :group_have_users, true
      attr :name, true

      # Create a new channel
      def initialize( name = nil )
         @name   = name || self
         @users  = {}
         @groups = {}
         @user_in_groups = {}
         @group_have_users = {}
      end

      # Write yaml data
      # ==== Parameters
      # * +yaml_data+  - String which contain data in yaml format
      def write_yaml( yaml_data )
         @users.each{|user_name, user|
            user.write_yaml( yaml_data )
         }
      end

      # Write json data
      # ==== Parameters
      # * +json_data+  - String which contain data in json format
      def write_json( json_data )
         @users.each{|user_name, user|
            user.write_json( json_data )
         }
      end

      # Write data in any format
      # ==== Parameters
      # * +data+    - it may be any Object. 
      def write( data )
         @users.each{|user_name, user|
            user.write( data )
         }
      end

      # Create a user, if he is not present in the user list
      # ==== Parameters
      # * +name+   - User name 
      def create_user( name )
         unless( @users[name] ) 
            @users[name] = LiveData::User.new( name, self )
            @user_in_groups[name] = @users[name].groups
         end
         return @users[name]
      end

      # Create a group, if the group is not present in the group list
      # ==== Parameters
      # * +name+    - Group name
      def create_group( name )
         unless( @groups[name] ) 
            @groups[name] = LiveData::Group.new( name, self )
            @group_have_users[name] = @groups[name].users
         end
         return @groups[name]
      end

      # Get user object
      def get_user( name )
         @users[name]
      end

      # Get group object
      def get_group( name )
         @groups[name]
      end

      # Destroy a user
      # ==== Parameters
      # * +name+   - User name 
      def destroy_user( name )
         @users[name].destroy()
      end


      # Destroy a group
      # ==== Parameters
      # * +name+   - Group name 
      def destroy_group( name )
         @groups[name].destroy()
      end

      # Destroy current channel
      def destroy
         @users.each{|name,obj|
            obj.destroy()
         }
         @groups.each{|name,obj|
            obj.destroy()
         }
      end
   end
end

