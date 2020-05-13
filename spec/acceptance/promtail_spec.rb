require 'spec_helper_acceptance'

describe 'vision_loki::promtail' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        package { 'unzip':
          ensure => present,
        }
        class { 'vision_loki::promtail': }
      FILE

      # TODO: systemd not functional
      apply_manifest(pp, catch_failures: false)
    end
  end

  context 'config deployed' do
    describe file('/etc/systemd/system/promtail.service') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match '/bin/promtail' }
    end
    describe file('/etc/promtail/config.yaml') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'scrape_config' }
      its(:content) { is_expected.to match 'var_log_secure' }
    end
    describe file('/var/lib/promtail') do
      it { is_expected.to exist }
    end
  end
  context 'installed' do
    describe file('/usr/local/bin/promtail-linux-amd64') do
      it { is_expected.to exist }
    end
  end
end
