require 'spec_helper'

describe 'newrelic::repo::legacy', type: :class do
  context 'OS Family => Redhat' do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'CentOS',
          'release' => {
            'major' => '7',
          },
        },
      }
    end

    it { is_expected.to compile }
    it { is_expected.to contain_package('newrelic-repo-5-3.noarch') }
  end

  context 'OS Family => Debian' do
    let(:facts) do
      {
        'os' => {
          'family' => 'Debian',
          'name'    => 'Debian',
          'release' => {
            'full'  => '7.0',
            'major' => '7',
            'minor' => '0',
          },
        },
        'osfamily'        => 'Debian',
        'lsbdistcodename' => 'wheezy',
      }
    end

    it { is_expected.to compile }
    it { is_expected.to contain_apt__source('newrelic') }
  end
end
