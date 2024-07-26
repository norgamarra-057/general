require 'minitest/autorun'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib/')
require 'checks_runner'

class TestChecksRunner < Minitest::Test

  def test_get_exec_second_when_run_every_60
    runner = ChecksRunner.new('check_test', nil, nil, nil)

    run_every = 60
    hash = 61
    expected = 1

    current_minute = 34 # even
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_equal(expected, second)

    current_minute = 35 # or odd
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_equal(expected, second)
  end

  def test_get_exec_second_when_run_every_gt_60_and_small_hash
    runner = ChecksRunner.new('check_test', nil, nil, nil)

    run_every = 180
    hash = 181

    current_minute = 0
    expected = 1
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_equal(expected, second)

    current_minute = 1
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_nil(second)

    current_minute = 2
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_nil(second)

    current_minute = 3
    expected = 1
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_equal(expected, second)
  end

  def test_get_exec_second_when_run_every_gt_60_and_big_hash
    runner = ChecksRunner.new('check_test', nil, nil, nil)

    run_every = 540
    hash = 1619 # 540*3 - 1

    current_minute = 0
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_nil(second)

    current_minute = 1
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_nil(second)

    # ...

    current_minute = 8
    expected = 59
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_equal(expected, second)

    current_minute = 9
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_nil(second)

    # ...

    current_minute = 17
    expected = 59
    second = runner.get_exec_second(hash, run_every, current_minute)
    assert_equal(expected, second)

  end

end
