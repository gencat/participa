# frozen_string_literal: true

require "spec_helper"
require "support/tasks"

describe "rake decidim:socrata:publish_processes", type: :task do

  context "when executing the task" do
    it "returns a row for each participatory process" do
      # TODO: how to check the connection to Socrata?
      # by using a dummy/stub Socrata service?
      expect { task.execute }.not_to raise_error
    end

    it "has to create a job" do
      # TODO: define if this is required
      ActiveJob::Base.queue_adapter = :test
      expect { task.execute }.to have_enqueued_job.exactly(1)
    end

  end
end
