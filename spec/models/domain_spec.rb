require 'spec_helper'
require_relative '../../fs_overlay/opt/certs_manager/certs_manager'

RSpec.describe Domain do
  before do
    allow(NAConfig).to receive(:stage).and_return('local')
  end

  it 'returns correct name, upstream. redirect_target_url and stage' do
    keys = [:descriptor, :name, :upstream, :redirect_target_url, :stage, :basic_auth_username, :basic_auth_password]

    domain_configs = [
      ['example.com', 'example.com', nil, nil, 'local', nil, nil],
      [' example.com ', 'example.com', nil, nil, 'local', nil, nil],
      ['example.com #staging', 'example.com', nil, nil, 'staging', nil, nil],
      ['example.com -> http://target ', 'example.com', 'http://target', nil, 'local', nil, nil],
      ['example.com => http://target', 'example.com', nil, 'http://target', 'local', nil, nil],
      ['example.com=>http://target', 'example.com', nil, 'http://target', 'local', nil, nil],
      ['example.com -> http://target #staging', 'example.com', 'http://target', nil, 'staging', nil, nil],
      ['example.com => http://target #staging', 'example.com', nil, 'http://target', 'staging', nil, nil],
      ['example.com->http://target #staging', 'example.com', 'http://target', nil, 'staging', nil, nil],
      ['username:password@example.com', 'example.com', nil, nil, 'local', 'username', 'password'],
      ['username:password@example.com -> http://target #staging', 'example.com', 'http://target', nil, 'staging', 'username', 'password'],
    ]

    domain_configs.map { |config|
      Hash[keys.zip(config)]
    }.each do |config|
      domain = Domain.new(config[:descriptor])

      expect(domain.name).to eq(config[:name]), lambda { "Parsing failed on #{config[:descriptor].inspect} method :name, expected #{config[:name].inspect}, got #{domain.name.inspect}" }
      expect(domain.upstream).to eq(config[:upstream]), lambda { "Parsing failed on #{config[:descriptor].inspect} method :upstream, expected #{config[:upstream].inspect}, got #{domain.upstream.inspect}" }
      expect(domain.redirect_target_url).to eq(config[:redirect_target_url]), lambda { "Parsing failed on #{config[:descriptor].inspect} method :redirect_target_url, expected #{config[:redirect_target_url].inspect}, got #{domain.redirect_target_url.inspect}" }
      expect(domain.stage).to eq(config[:stage]), lambda { "Parsing failed on #{config[:descriptor].inspect} method :stage, expected #{config[:stage].inspect}, got #{domain.stage.inspect}" }
      expect(domain.basic_auth_username).to eq(config[:basic_auth_username]), lambda { "Parsing failed on #{config[:descriptor].inspect} method :basic_auth_username, expected #{config[:basic_auth_username].inspect}, got #{domain.basic_auth_username.inspect}" }
      expect(domain.basic_auth_password).to eq(config[:basic_auth_password]), lambda { "Parsing failed on #{config[:descriptor].inspect} method :basic_auth_password, expected #{config[:basic_auth_password].inspect}, got #{domain.basic_auth_password.inspect}" }
    end
  end
end
