require 'test_helper'

class LiveDataTest < Test::Unit::TestCase

	def test_channel
		chat = LiveData.create_channel( 'chat' )

		assert chat.class == LiveData::Channel
		assert chat.name == 'chat'
		assert chat == LiveData.get_channel( 'chat' )
	end

	def test_user
		chat 	= LiveData.create_channel( 'chat' )
		guest1 	= chat.create_user( 'guest1' )

		assert guest1.class == LiveData::User
		assert guest1.name == 'guest1' 
		assert guest1 == chat.get_user( 'guest1' )
		assert guest1 == chat.create_user( 'guest1' )
		
		chat.destroy_user( 'guest1' )

		assert chat.get_user( 'guest1') == nil 
		assert chat.users['guest1'] == nil 
		assert chat.user_in_groups['guest1'] == nil 


	end

	def test_group
		chat 	  = LiveData.create_channel( 'chat' )
		users_grp = chat.create_group( 'users' )

		assert users_grp.class == LiveData::Group
		assert users_grp.name  == 'users'
		assert users_grp == chat.get_group( 'users' )
		assert users_grp == chat.create_group( 'users' )

		guest1 	= chat.create_user( 'guest1' )
		users_grp.add_user( guest1 )
		assert users_grp.users.include? guest1
		assert guest1.groups.include? users_grp 

		users_grp.remove_user( guest1 )
		assert !users_grp.users.include?(guest1)
		assert !guest1.groups.include?(users_grp)

		chat.destroy_group( 'users' )

		assert chat.get_group('users' ) == nil
		assert chat.group_have_users['users'] == nil
	end

	def test_process_data
		chat 	= LiveData.create_channel( 'chat' )
		guest1 	= chat.create_user( 'guest1' )
		guest2  = chat.create_user( 'guest2' )
		grp	= chat.create_group( 'users')
		data    = { :title => "Greating", :message => "Welcome you all" }
		data1   = { :title => "Greating1", :message => "Welcome you all" }
		data2   = { :title => "Greating2", :message => "Welcome you all" }
		grp.add_user( guest1 )
		grp.add_user( guest2 )

		guest1.write( data )
		assert data == guest1.read

		guest2.write( data1 )
		tmp_data = guest2.read
		assert data1 == tmp_data 
		assert data  != tmp_data 


		grp.write( data2 )
		assert data2 == guest1.read
		assert data2 == guest2.read

	end
end
