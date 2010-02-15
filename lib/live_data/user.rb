
module LiveData
   class User

      IntegerPackCode = "I"
      ReadTime        = 30

      attr :groups, :name

      # Create a user object
      def initialize( name = nil, channel = nil )
         @name      = name || self
    @channel   = channel
    @read_time = ReadTime
         @lock      = Mutex.new
         @read_pipe, @write_pipe = IO.pipe
         @groups       = []
      end

      def set_read_time( time )
         @read_time = time
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
       @lock.synchronize {
          while( @read_pipe.read_nonblock( 10000 ) )
          end
       }
         rescue => err
         end
      end

      # Read yaml contain
      def read_yaml
         if( ioarrays = IO.select( [@read_pipe], [], [], @read_time ) )
            if( ioarrays[0].include? @read_pipe )
               @lock.synchronize {
                  tcont = @read_pipe.read_nonblock(4)
                  if( tcont and tcont.size == 4 )
                     len, etc = tcont.unpack( IntegerPackCode )
                     return @read_pipe.read_nonblock( len )
                  else
                     return nil
                  end
               }
            else
               return nil
            end
         else
            return nil
         end
      end

      # read a Object
      def read
         cont = read_yaml
         if( cont )
            return YAML.load( cont )
         else
            return nil
         end
      end

      # Write a string, which contain yam format
      # ==== Parameters
      # * +yaml_data+ - yaml string
      def write_yaml( yaml_data )
         return unless yaml_data and yaml_data.class == String
    len = [ yaml_data.length ].pack( IntegerPackCode )
    @lock.synchronize {
       @write_pipe.write( len )
       @write_pipe.write( yaml_data )
    }
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
