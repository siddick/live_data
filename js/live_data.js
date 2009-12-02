var LiveData = {
	handle: function( request , success_delay, failure_delay ){
		var options    = request.request.options;
		var req_status = request.getStatus();
		if( req_status >=200  && req_status < 300 ){
			if( success_delay > 0 ){
				this.request_at( success_delay, request.request );
			} else {
				this.request( request.request );
			}
		} else {
			if( failure_delay >= 0 ){
				this.request_at( failure_delay, request.request );
			}
		}
	},
	request_at: function( duration, request ){
		if( duration > 0 ){
			window.setTimeout( this.request.bind( this, request ), duration )
		} else {
			this.request( request );
		}
	},
	request: function( request ){
		new Ajax.Request( request.url, request.options );
	}
};
