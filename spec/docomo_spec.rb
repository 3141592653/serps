# coding: utf-8
require 'spec_helper'

describe Serps::Search::Docomo do
  context 'when keyword is "うどん"' do
    before :all do
      @agent = Serps::Search::Docomo.new keyword: 'うどん', count: 20
      @agent.search
    end

    describe '.totalcount' do
      subject { @agent.totalcount }
      it { is_expected.to be_truthy }
    end

    describe '.items size' do
      subject { @agent.items.size }
      it { is_expected.to be 20 }
    end

    describe '.items rank is not nil' do
      subject { @agent.items.all?(&:rank) }
      it { is_expected.to be_truthy }
    end

    describe '.items title is not nil' do
      subject { @agent.items.all?(&:title) }
      it { is_expected.to be_truthy }
    end

    describe '.items uri is not nil' do
      subject { @agent.items.all?(&:uri) }
      it { is_expected.to be_truthy }
    end

    describe '.items summary is not nil' do
      subject { @agent.items.all?(&:summary) }
      it { is_expected.to be_truthy }
    end

    describe '.items host is not nil' do
      subject { @agent.items.all?(&:host) }
      it { is_expected.to be_truthy }
    end
  end
end
