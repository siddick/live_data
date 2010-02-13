
module LiveData
   class User

      IntegerPackCode = "I"

      attr :groups, :name

      # Create a user object
      def initialize( name = nil, channel = nil )
         @name    = name || self
	 @channel = channel
         @lock                     = Mutex.new
         @read_pipe, @write_pipe = IO.pipe
         @groups       = []
      end

      # Reset the write pipe and read pipe
      def reset
         begin
            @write_pipe.close
            @read_pipe.close
         rescue => err
         end
         @read_pipe, @write_pipe = IO.pipe
      end

      # Clean the Contain in the pipe
      def clean
         begin
            while( @read_pipe.read_nonblock( 10000 ) )
            end
         rescue => err
         end
      end

      # Read json contain
      def read_json
         @read_pipe.gets()
      end

      # Read yaml contain
      def read_yaml
         len, etc = @read_pipe.read(4).unpack( IntegerPackCode )
         @read_pipe.read( len )
      end

      # read a Object
      def read
          YAML.load( read_yaml )
      end

      # Write a string, which contain json format
      # ==== Parameters
      # * +json_data+ - json string
      def write_json( json_data )
         @write_pipe.write( json_data + "\n" )         
      end

      # Write a string, which contain yam format
      # ==== Parameters
      # * +yaml_data+ - yaml string
      def write_yaml( yaml_data )
         return unless yaml_data and yaml_data.class == String
         len = [ yaml_data.length ].pack( IntegerPackCode )
         @write_pipe.write( len )
         @write_pipe.write( yaml_data )
      end

      # Write a Object
      # ==== Parameters
      # * +data+ - any Object
      def write( data )
         write_yaml( data.to_yaml )
      end

      # Destroy the user
      def destroy
         @groups.dup.each{|grp|
            grp.remove_user( self )
         }
	 if( @channel )
		 @channel.users.delete( @name )
		 @channel.user_in_groups.delete( @name )
	 end
         begin
            @read_pipe.close
            @write_pipe.close
         rescue => err
         end
      end

   end
end
