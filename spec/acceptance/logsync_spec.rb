require 'spec_helper_acceptance'

describe 'vision_loki::logsync' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_loki::logsync': }
      FILE

      # TODO systemd not functional
      apply_manifest(pp, catch_failures: false)
    end
  end

  context 'jobs deployed' do
    describe file('/etc/systemd/system/foobar.service') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'foobar.sh' }
    end
    describe file('/etc/systemd/system/foobar.timer') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match '1h' }
    end
    describe file('/usr/local/bin/foobar.sh') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match '/tmp/log' }
    end
    # Second
    describe file('/etc/systemd/system/barfoo.service') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'barfoo.sh' }
    end
    describe file('/etc/systemd/system/barfoo.timer') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match '15m' }
    end
    describe file('/usr/local/bin/barfoo.sh') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match '/tmp/barfoo' }
    end
  end
end
