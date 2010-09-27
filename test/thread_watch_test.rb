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

	def test_own_object 
		threads  = {}
		th = Thread.new{ 
			sleep(6)
			LiveData::ThreadWatch.wakeup('guest', threads )
		}
		assert LiveData::ThreadWatch.wait('guest', 10 , threads ) < 10
		th.join
	end

	def test_read_write_process
		content = "Testing"
		LiveData::ThreadWatch.write( 'guest', content )
		assert_equal LiveData::ThreadWatch.read( 'guest' ), content
		assert_equal LiveData::ThreadWatch.read( 'guest', 10 ), nil
	end

	def test_read_write_process2
		content  = { :hai => "testing" }
		content2 = "Testing2"
		Thread.new {
			sleep(4)
			LiveData::ThreadWatch.write( 'guest', content )
			LiveData::ThreadWatch.write( 'guest', content2 )
		}
		assert_equal LiveData::ThreadWatch.read( 'guest', 10 ), content
		assert_equal LiveData::ThreadWatch.read( 'guest', 10 ), content2
		assert_equal LiveData::ThreadWatch.read( 'guest', 2 ), nil
	end

	def test_clear
		content  = { :hai => "testing" }
		LiveData::ThreadWatch.write( 'guest', content )
		LiveData::ThreadWatch.clear( 'guest' )
		assert_equal LiveData::ThreadWatch.read( 'guest', 2 ), nil 
	end
end
