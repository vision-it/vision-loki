require 'spec_helper_acceptance'

describe 'vision_loki::server' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        # Generate dummy certs and ca
        # exec { '/bin/bash /etc/puppetlabs/code/modules/vision_loki/files/testing/gencrt.sh':}
        package { 'unzip':
          ensure => present,
        }

        class { 'vision_loki::server': }
      FILE

      # Systemd not functional
      apply_manifest(pp, catch_failures: false)
    end
  end

  context 'config deployed' do
    describe file('/vision/data/loki/config.yaml') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
    end
  end
end
