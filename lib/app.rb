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
    data = Fetcher.all_issue_ids
    byebug
    print data
  end
end
