require 'spec_helper'
require 'axe/api/a11y_check'

module Axe::API
  describe A11yCheck do

    describe "@context" do
      let(:context) { spy('context') }
      before :each do
        subject.instance_variable_set :@context, context
      end

      it "should be delegated #include" do
        subject.include "foo"
        expect(context).to have_received(:include).with("foo")
      end

      it "should be delegated #exclude" do
        subject.exclude "foo"
        expect(context).to have_received(:exclude).with("foo")
      end
    end

    describe "@options" do
      let(:options) { spy('options') }
      before :each do
        subject.instance_variable_set :@options, options
      end

      it "should be delegated #rules_by_tags" do
        subject.rules_by_tags "foo"
        expect(options).to have_received(:rules_by_tags).with("foo")
      end

      it "should be delegated #run_rules" do
        subject.run_rules "foo"
        expect(options).to have_received(:run_rules).with("foo")
      end

      it "should be delegated #skip_rules" do
        subject.skip_rules "foo"
        expect(options).to have_received(:skip_rules).with("foo")
      end

      it "should be delegated #run_only_rules" do
        subject.run_only_rules "foo"
        expect(options).to have_received(:run_only_rules).with("foo")
      end

      it "should be delegated #with_custom_options" do
        subject.custom_options "foo"
        expect(options).to have_received(:custom_options).with("foo")
      end
    end

    describe "#call" do
      let(:page) { spy('page', execute_async_script: {'violations' => []}) }
      let(:results) { spy('results') }
      let(:audit) { spy('audit') }

      it "should inject the axe-core lib" do
        subject.call(page)
        expect(page).to have_received(:execute_script).with(a_string_starting_with ("/*! aXe"))
      end

      it "should execute the the A11yCheck script" do
        pending "validate args correctly"
        subject.call(page)
        expect(page).to have_received(:execute_async_script).with("axe.a11yCheck.apply(axe, arguments)", "document", "{}")
      end

      it "should return an audit" do
        expect(subject.call(page)).to be_kind_of Audit
      end

      it "should parse the results" do
        expect(Results).to receive(:new).with('violations' => []).and_return results
        expect(Audit).to receive(:new).with(instance_of(String), results)
        subject.call(page)
      end

      it "should include the original invocation string" do
        expect(Audit).to receive(:new).with("axe.a11yCheck(document, {}, callback);", instance_of(Results))
        subject.call(page)
      end
    end
  end
end