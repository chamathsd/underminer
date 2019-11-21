require 'byebug'
require 'ap'
require 'date'
require 'active_support'
require 'active_support/core_ext'
require 'csv'

class App
  attr_reader :board

  def initialize
    @issues = load_data
  end

  def cycletime
    CSV.open('output.csv', 'w+') do |csv|
      csv << ['Issue ID', 'Link', 'Title', 'Analysis', 'In Progress', 'Test', 'Feedback', 'Done']
    end
  end

  private

  def load_data
    all_ids = Fetcher.all_issue_ids
    issue_details = all_ids.map { |id| Fetcher.issue_details id }

    byebug
    print issue_details
  end
end
