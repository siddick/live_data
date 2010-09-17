class LiveDataController < ApplicationController
	DefaultUserId    = "guest"
	DefaultChannelId = "chat"
	DefaultWaitTime  = 15

	def get
		user_id    = params[:user_id]    || DefaultUserId
		channel_id = params[:channel_id] || DefaultChannelId
		channel = LiveData.get_channel(channel_id) || LiveData.create_channel(channel_id)
		user    = channel.get_user( user_id ) || channel.create_user( user_id )
		user.set_read_time( ( params[:read_time] || DefaultWaitTime ).to_i )
		respond_to do |format|
			format.html {
				render :text => user.read.to_query
			}
			format.xml {
				render :text => user.read.to_xml
			}
			format.yaml {
				render :text => user.read.to_yaml
			}
			format.json {
				render :text => user.read.to_json
			}
			
		end

	end

	def put
		user_id = params[:user_id] || GestUserId
		channel_id = params[:channel_id] || DefaultChannelId
		channel = LiveData.get_channel(channel_id) || LiveData.create_channel(channel_id)
		user    = channel.get_user( user_id ) || channel.create_user( user_id )
		user.write( params.to_hash )
		render :text => "OK", :layout => false
	end

end
