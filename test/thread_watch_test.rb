require 'test_helper'

class ThreadWatchTest < Test::Unit::TestCase
	def test_thread_watch
		Thread.new{ 
			sleep(6)
			LiveData::ThreadWatch.wakeup('guest')
		}
		assert LiveData::ThreadWatch.wait('guest', 10 ) < 10

		assert LiveData::ThreadWatch.wait('guest', 2 ) >= 2 

	end
end
