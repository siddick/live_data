
module LiveData
	class Channel
		def initialize( name )
			@name 	= name 
			@users  = {}
			@groups = {}
		end

		def write_json( cont )
			@users.each{|user_name, user|
				user.write_json( cont )
			}
		end

		def write( cont )
			@users.each{|user_name, user|
				user.write( cont )
			}
		end

		def register_user( name )
			unless( @users[name] ) 
				@users[name] = LiveData::User.new( self, name )
			end
			return @users[name]
		end

		def unregister_user( name )
			@users[name].destroy()
		end

		def register_group( name )
			unless( @groups[name] ) 
				@groups[name] = LiveData::Group.new( self, name )
			end
			return @groups[name]
		end

		def unregister_group( name )
			@users[name].destroy()
		end

		def get_user( name, create_user = true )
			user = @users[name]
			unless( create_user and user )
				user = register_user( name )
			end
			return user
		end

		def get_group( name, create_group = true )
			group = @groups[name]
			unless( create_group and group )
				group = register_group( name )
			end
			return group
		end

		def destroy
			LiveData::Channels.delete( @name )
			@users.each{|name,obj|
				obj.destroy()
			}
			@groups.each{|name,obj|
				obj.destroy()
			}
		end

		def remove_user_name( name )
			@users.delete( name )
		end

		def remove_group_name( name )
			@groups.delete( name )
		end
	end
end
