require 'rails_helper'

RSpec.describe RedisService do
  include ActiveSupport::Testing::TimeHelpers

  let!(:key) { SecureRandom.base64 }
  let!(:expire_key_in_one_day) { 1.day.seconds.to_i }
  let!(:connection) { Redis.new(host: 'localhost') }

  context '#hmset_with_expiry' do
    it 'should store a hash in redis with an expiry' do
      described_class.new(connection).hmset_with_expiry(key, { user: 'margaret' }, expire_key_in_one_day)

      expect(connection.hmget(key, 'user')).to eq(['margaret'])
      expect(connection.ttl(key)).to be > 0
    end

    it 'should expire the key after ttl' do
      described_class.new(connection).hmset_with_expiry(key, { user: 'margaret' }, expire_key_in_one_day)

      expect(connection.hmget(key, 'user')).to eq(['margaret'])

      travel(2.days) do
        expect(connection.ttl(key)).to eq(-2) # TTL command returns -2 if the key does not exist
      end
    end

    it 'should throw an exception if there is a connection error' do
      expected_exception = Redis::CannotConnectError.new
      expect(connection).to receive(:hmset).and_raise(expected_exception)

      expect {
        described_class.new(connection).hmset_with_expiry(key, { user: 'margaret' }, expire_key_in_one_day)
      }.to raise_error(expected_exception)
    end
  end

  context '#hgetall' do
    it 'should get the stored hash with keys as symbols' do
      connection.hmset(key, 'user', 'margaret')

      result = described_class.new(connection).hgetall(key)

      expect(result).to eq({ user: 'margaret' })
    end

    it 'should throw an exception if there is a connection error' do
      expected_exception = Redis::CannotConnectError.new
      expect(connection).to receive(:hgetall).and_raise(expected_exception)

      expect {
        described_class.new(connection).hgetall(key)
      }.to raise_error(expected_exception)
    end
  end
end
