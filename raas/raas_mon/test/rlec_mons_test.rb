require 'minitest/autorun'
require 'yaml'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib/')
require 'rlec_mons'

class TestRLECMons < Minitest::Test

  def test_regression # creates correct info according to original code got from nagios_info project
    clusters_info = YAML.load_file('test/fixtures/clusters_info.yml')
    clusters_thresholds = nil # simulate no params in host file
    actual = RLECMons.new.create_rlec_mons(clusters_info, clusters_thresholds)
    # IO.write('test/fixtures/expected_rlec_mons.yml', actual.to_yaml)
    expected = YAML.load_file('test/fixtures/expected_rlec_mons.yml')
    # Compare each part, to get a better feedback in case of a mismatch
    assert_equal(expected.class, actual.class)
    assert_equal(expected.keys, actual.keys)
    # final infallible test
    assert_equal(expected, actual)
  end

  def test_thresholds_from_host_file
    clusters_info = YAML.load_file('test/fixtures/clusters_info.yml')
    clusters_thresholds = {
      'license_days_to_expiration' => '61:31',
      'shards_usage_pct' => '81:91',
      'db_mem_overcommit_pct' => '71:81',
      'db_cputime_sec' => '0.81:0.91',
      'db_connection_time_open' => '1.1:2.1',
      'db_connection_time_command' => '2.1:3.1',
      'db_ns_nodes' => '1.1:0.1',
      'db_resolv_time' => '0.11:0.21',
      'db_avg_read_latency_microseconds' => '40001:50001',
      'db_avg_write_latency_microseconds' => '40001:50001',
      'db_used_memory_warning_pct' => 85.1,
      'db_used_memory_critical_pct' => 90.1,
      'db_evicted_objects' => '1.1:1001',
      'db_egress_bytes' => '33554431:67108861',
      'db_ingress_bytes' => '33554431:67108861',
    }
    actual = RLECMons.new.create_rlec_mons(clusters_info, clusters_thresholds)
    # IO.write('test/fixtures/expected_rlec_mons_with_specific_thresholds.yml', actual.to_yaml)
    expected = YAML.load_file('test/fixtures/expected_rlec_mons_with_specific_thresholds.yml')
    # Compare each part, to get a better feedback in case of a mismatch
    assert_equal(expected.class, actual.class)
    assert_equal(expected.keys, actual.keys)
    # final infallible test
    assert_equal(expected, actual)
  end

end
