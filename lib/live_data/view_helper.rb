
module LiveData
	module ViewHelper
		def call_live_data( config = {} )
			success_delay = config[:success_delay] || 0
			failure_delay = config[:failure_delay] || -1
			code = "LiveData.handle(request, #{success_delay}, #{failure_delay} );";
			if( config[:complete] )
				config[:complete] = config[:complete] + ";" + code ;
			else
				config[:complete] = code ;
			end
			remote_function(config)
		end
	end
end
