
module LiveData
	class LiveDataPlace
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
				@users[name] = LiveData::LiveDataUser.new( self, name )
			end
			return @users[name]
		end

		def unregister_user( name )
			@users[name].destroy()
		end

		def register_group( name )
			unless( @groups[name] ) 
				@groups[name] = LiveData::LiveDataGroup.new( self, name )
			end
			return @groups[name]
		end

		def unregister_group( name )
			@users[name].destroy()
		end

		def get_user( name )
			user = @users[name]
		#	unless( user )
		#		user = register_user( name )
		#	end
			return user
		end

		def get_group( name )
			group = @groups[name]
			unless( group )
				group = register_group( name )
			end
			return group
		end

		def destroy
			LiveData::Places.delete( @name )
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
