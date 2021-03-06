require 'spec_helper'

module Daemons
  describe Application do
    subject(:application) { described_class.new group }

    let(:group)    { ApplicationGroup.new 'my_app' }
    let(:options)  { Hash.new }
    let(:log_dir)  { nil }
    let(:dir_mode) { nil }
    let(:options)  {
      {
        log_dir: log_dir,
        dir_mode: dir_mode
      }
    }

    before { application.instance_variable_set :@options, options }

    describe '#logdir' do
      subject { application.logdir }

      context 'with :log_dir' do
        let(:log_dir) { '/path/to/logs/' }

        it { is_expected.to eq log_dir }
      end

      context 'without :log_dir' do
        let(:log_dir) { nil }

        context 'and :dir_mode is :system' do
          let(:dir_mode) { :system }

          it { is_expected.to eq '/var/log' }
        end

        context 'and :dir_mode is other' do
          let(:pidfile_dir) { '/path/to/pid' }

          before do
            allow(application)
              .to receive(:pidfile_dir)
              .and_return pidfile_dir
          end

          it { is_expected.to eq pidfile_dir }
        end
      end
    end
  end
end
