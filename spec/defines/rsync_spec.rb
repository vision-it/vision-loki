require 'spec_helper'
require 'hiera'

describe 'vision_loki::logsync::rsync' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:title) { 'foobar' }

      let(:params) do
          {
            target_dir: '/tmp/foo',
            source_dir: '/tmp/bar'
          }
       end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end
      context 'contains' do
        it { is_expected.to contain_file('/etc/systemd/system/foobar.service') }
        it { is_expected.to contain_file('/etc/systemd/system/foobar.timer') }
        it { is_expected.to contain_file('/usr/local/bin/foobar.sh') }
        it { is_expected.to contain_service('foobar') }
      end
    end
  end
end
