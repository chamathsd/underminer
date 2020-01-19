require 'byebug'
require 'ap'
require 'date'
require 'active_support'
require 'active_support/core_ext'
require 'csv'

class ProjectMetrics
  attr_reader :issue_details

  def initalize(issue_details)
    @issue_details = issue_details
  end

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

    total_kickbacks = issue_details.map { |issue| KickbackParser.parse issue }.flatten

    kickbacks_by_day = {}
    total_kickbacks.each do |kickback|
      kicked_on = DateTime.parse(kickback[:kicked_on]).strftime('%m/%d/%Y')
      kickbacks_by_day[kicked_on] = 0 unless kickbacks_by_day.key? kickback[:kicked_on]
      kickbacks_by_day[kicked_on] += 1
    end

    CSV.open(filename, 'w+') do |csv|
      csv << ['Kickback On', 'Kickback Count']

      kickbacks_by_day.keys.each do |date|
        csv << [date, kickbacks_by_day[date]]
      end
    end
  end
end
