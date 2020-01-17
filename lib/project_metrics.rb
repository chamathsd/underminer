require 'byebug'
require 'ap'
require 'date'
require 'active_support'
require 'active_support/core_ext'
require 'csv'

class ProjectMetrics
  def cycletime
    filename = 'cycletimes.csv'
    puts "Generating cycletime and writing to #{filename}"

    CSV.open(filename, 'w+') do |csv|
      csv << ['Issue ID', 'Link', 'Title', 'Analysis', 'Ready to Work', 'In Progress', 'Test', 'Feedback', 'Done']
      issue_details.each do |issue|
        cycle_time = CycleTime.parse issue
        csv << [cycle_time[:id], cycle_time[:link], cycle_time[:subject],
                cycle_time[:analysis], cycle_time[:ready_to_work],
                cycle_time[:in_progress], cycle_time[:test],
                cycle_time[:feedback], cycle_time[:done]]
      end
    end
  end

  def kickbacks
    filename = 'kickbacks.csv'
    puts "Generating kickbacks and writing to #{filename}"

    total_kickbacks = []
    issue_details.each do |issue|
      total_kickbacks += KickbackParser.parse issue
    end

    CSV.open(filename, 'w+') do |csv|
      csv << ['Issue ID', 'Kickback On', 'Kickback From']

      total_kickbacks.each do |kickback|
        csv << [kickback[:id], kickback[:kicked_on], kickback[:kicked_from]]
      end
    end
  end

  private

  def issue_details
    @issue_details ||= load_issue_details
  end

  def load_issue_details
    all_issue_ids = AllIssuesFetcher.new.fetch
    puts "Found #{all_issue_ids.count} issues in project #{Config::PROJECT_ID}"

    all_issue_ids.each_with_index.map do |issue_id, index|
      update_progress_bar index + 1, all_issue_ids.count
      IssueDetailsFetcher.new.fetch issue_id
    end
  end

  def update_progress_bar(progress, total)
    if progress == total
      printf("\rFetching details: [%-20s]\n", "#{'=' * 15}Done!")
    else
      printf("\rFetching details: [%-20s]", '=' * ((progress.to_f / total) * 20))
    end
  end
end
