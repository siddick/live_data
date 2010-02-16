module LiveData
   module ThreadWatch
      Lock        = Mutex.new
      WaitTime    = 25
      UserThreads = {}

      def self.wait( user_id, time = WaitTime )
         already_use = false
         Lock.synchronize {
            if( UserThreads[user_id] )
               already_use = true
            else
               UserThreads[user_id] = Thread.current
            end
         }
         if( already_use )
            return nil
         end
         used_time = sleep(time )
         Lock.synchronize {
            UserThreads.delete( user_id )
         }
         return used_time
      end

      def self.wakeup( user_id )
         Lock.synchronize {
            uthread = UserThreads[user_id]
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
