require 'test_helper'

class ThreadWatchTest < Test::Unit::TestCase
	def test_thread_watch
		th = Thread.new{ 
			sleep(6)
			LiveData::ThreadWatch.wakeup('guest')
		}
		assert LiveData::ThreadWatch.wait('guest', 10 ) < 10
		th.join

		assert LiveData::ThreadWatch.wait('guest', 2 ) >= 2 

		th = Thread.new{
			sleep(2)
			assert LiveData::ThreadWatch.wait('guest', 2) == nil
		}
		assert LiveData::ThreadWatch.wait('guest', 5 ) >= 5
		th.join
	end
end
