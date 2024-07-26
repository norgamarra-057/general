abort('invalid ruby version! compare the output of "ruby -v" with the contents of .ruby-version') unless File.read(File.join("#{File.dirname(__FILE__)}",'.ruby-version')).strip.include?(RUBY_VERSION)

require 'aws-sdk'

abort("usage: ruby #{__FILE__} <bucket> <access_key_id> <secret_access_key> <region> <days_expiration> <prefix>\n
  Ex: ruby #{__FILE__} badges-us-redis-backup BKIAIO1L62MFP37FAV5Q vX4hAwd0FqHP29V2Q/OY9VfhxnSG4fV5NIk1/tdg us-west-1 4 RedisBackup/") unless ARGV.size==6

bucket = ARGV[0]
access_key_id = ARGV[1]
secret_access_key = ARGV[2]
region = ARGV[3]
days_expiration = ARGV[4].to_i
prefix = ARGV[5]

s3 = Aws::S3::Client.new(
  access_key_id: access_key_id,
  secret_access_key: secret_access_key,
  region: region,
)

begin
  conf = s3.get_bucket_lifecycle_configuration(bucket: bucket)
  abort("There is already another configuration: #{conf.inspect}")
rescue Aws::S3::Errors::NoSuchLifecycleConfiguration
end

s3.put_bucket_lifecycle_configuration({
  bucket: bucket, # required
  lifecycle_configuration: {
    rules: [ # required
      {
        expiration: {
          days: days_expiration,
        },
        id: "RedisBackupRetention",
        prefix: prefix, # required
        status: "Enabled", # required, accepts Enabled, Disabled
      },
    ],
  },
  use_accelerate_endpoint: false,
})

puts "done"

# s3.delete_bucket_lifecycle({
#   bucket: bucket, # required
#   use_accelerate_endpoint: false,
# })

# obj = s3.get_object(bucket: bucket, key: 'RedisBackup/k20160923-005339-2-pablotest2-1_of_1-4-1-4096.rdb.gz')
