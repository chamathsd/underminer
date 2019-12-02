require 'byebug'
require 'ap'
require 'date'
require 'active_support'
require 'active_support/core_ext'
require 'csv'

class App
  attr_reader :issues

  def initialize
    @issues = load_data
  end

  def cycletime
    CSV.open('output.csv', 'w+') do |csv|
      csv << ['Issue ID', 'Link', 'Title', 'Analysis', 'Ready to Work', 'In Progress', 'Test', 'Feedback', 'Done']
      issues.each do |issue|
        csv << [issue[:id], issue[:link], issue[:subject],
                issue[:analysis], issue[:ready_to_work],
                issue[:in_progress], issue[:test],
                issue[:feedback], issue[:done]]
      end
    end
  end

  private

  def load_data
    all_ids = Fetcher.all_issue_ids

    all_ids.map do |id|
      issue_details = Fetcher.issue_details id
      CycleTime.parse issue_details
    end
  end
end
