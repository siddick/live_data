module LiveData
   module ThreadWatch
      Lock        = Mutex.new
      WaitTime    = 25
      UserThreads = {}

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
   end
end
