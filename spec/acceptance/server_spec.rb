require 'spec_helper_acceptance'

describe 'vision_loki::server' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        file { ['/vision', '/vision/data/']:
          ensure => directory,
        }

        # Mock
        class vision_loki::server::docker () {}

        class { 'vision_loki::server': }
      FILE

      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'config deployed' do
    describe file('/vision/data/loki/config.yaml') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
    end
    describe file('/etc/nginx/sites-enabled/default') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
    end
  end
end
