module LiveData
   module ThreadWatch
      Lock        = Mutex.new
      WaitTime    = 15
      UserThreads = {}
      UserData    = {}

      def self.wait( user_id, time = WaitTime, user_threads = UserThreads )
         already_use = false
         Lock.synchronize {
            if( user_threads[user_id] )
               already_use = true
            else
               user_threads[user_id] = Thread.current
            end
         }
         if( already_use )
            return nil
         end
         used_time = sleep( time )
         Lock.synchronize {
            user_threads.delete( user_id )
         }
         return used_time
      end

      def self.wakeup( user_id , user_threads = UserThreads )
         Lock.synchronize {
            uthread = user_threads[user_id]
            if( uthread )
               uthread.wakeup
               return true
            else
               return false
            end
         }
      end

      def self.read( user_id, wait_time = WaitTime  )
	      data = get_user_data( user_id )
	      obj  = nil
	      Lock.synchronize{
		      obj = data.shift
	      }
	      return obj if obj
	      wait( user_id, wait_time )
	      Lock.synchronize{
		      obj = data.shift
	      }
	      return obj
      end

      def self.write( user_id, obj )
	      data = get_user_data( user_id )
	      Lock.synchronize {
		      data.push( obj )
	      }
	      wakeup( user_id )
      end

      def self.clear( user_id )
	      data = get_user_data( user_id )
	      Lock.synchronize{
		      data.clear
	      }
      end

      def self.get_user_data( user_id )
	      Lock.synchronize {
	      	UserData[user_id] ||= [] 
	      }
      end

   end
end
