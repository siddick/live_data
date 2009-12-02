
module LiveData
	class LiveDataUser
		def initialize( place, name )
			@place = place
			@name  = name
			@read_pipe, @write_pipe = IO.pipe
			@groups = {}
		end

		def get_name
			@name
		end

		def clean
			begin
				while( @read_pipe.read_nonblock( 100000 ) )
				end
			rescue => err
			end
		end

		def read_json
			@read_pipe.gets()
		end

		def read
			 ActiveSupport::JSON.decode( read_json() )
		end

		def write_json( json_cont )
			@write_pipe.write( json_cont + "\n" )			
		end

		def write( cont )
			write_json( cont.to_json )
		end

		def register_group( group )
			if( group.class = String )
				group = @place.get_group( group )
			end
			group.add_user_name( @name, self )
			@groups.delete( group.get_name() )
		end

		def unregister_group( group )
			if( group.class = String )
				group = @place.get_group( group )
			end
			group.remove_user_name( @name )
			@groups[ group.get_name() ] = group 
		end

		def remove_group_name( name )
			@groups.delete( name )
		end

		def add_group_name( name, group )
			@groups[name] = group 
		end

		def destroy
			@groups.each{|group_name,group|
				group.remove_user_name( @name )
			}
			@read_pipe.close()
			@write_pipe.close()
			@place.remove_user_name( user )
		end

	end
end
