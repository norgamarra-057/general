require 'minitest/autorun'
require 'yaml'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib/')
require 'nagios_info'

class TestNagiosInfo < Minitest::Test

  def test_regression # creates correct info according to original code got from nagios_info project
    host = YAML.load_file('test/fixtures/host_with_rlec_mons.yml')
    nagios_info = NagiosInfo.new(host)
    actual = nagios_info.info
    expected = YAML.load_file('test/fixtures/expected_raas_nagios.info')
    # IO.write('/tmp/actual.yml', actual.to_yaml)
    # Compare each part, to get a better feedback in case of a mismatch
    assert_equal(expected.class, actual.class)
    assert_equal(expected.keys, actual.keys)
    expected['services'].each_with_index do |s, i|
      assert_equal(s, actual['services'][i])
    end
    expected['hosts'].each do |k, v|
      assert_equal(v, actual['hosts'][k])
    end
    (actual.keys - ['services', 'hosts']).each do |k|
      assert_equal(expected[k], actual[k])
    end
    # final infallible test
    assert_equal(expected, actual)
  end
end
