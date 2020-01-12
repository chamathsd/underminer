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
    puts "Found #{all_ids.count} issues in project #{Config.project_id}"

    all_ids.each_with_index.map do |issue_id, index|
      update_progress_bar index + 1, all_ids.count
      issue_details = Fetcher.issue_details issue_id
      CycleTime.parse issue_details
    end
  end

  def update_progress_bar(progress, total)
    if progress == total
      printf("\rFetching details: [%-20s]", "#{'=' * 15}Done!")
    else
      printf("\rFetching details: [%-20s]", '=' * ((progress.to_f / total) * 20))
    end
  end
end
