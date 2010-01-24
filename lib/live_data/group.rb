module LiveData
	class Group
		def initialize( channel, name )
			@channel = channel
			@name  = name
			@users = {}
		end

		def get_name
			@name
		end
		
		def write_json( json_cont )
			@users.each{|username, user|
				user.write_json( json_cont )
			}
		end

		def write( cont )
			write_json( cont.to_json )
		end

		def register_user( user )
			if( user.class = String )
				user = @channel.get_user( user )
			end
			user.add_group_name( @name, self )
		end

		def unregister_user( user )
			if( user.class = String )
				user = @channel.get_user( user )
			end
			user.remove_group_name( @name )
		end

		def add_user_name( user_name, user )
			@users[user_name] = user
		end

		def remove_user_name( user_name )
			@users.delete( user_name )
		end

		def destroy
			@users.each{|user_name, user|
				user.remove_group_name( @name )
			}
			@channel.remove_group_name( @name )
		end
	end
end

