require 'byebug'
require 'ap'
require 'date'
require 'active_support'
require 'active_support/core_ext'
require 'csv'

class ProjectMetrics
  attr_reader :issue_details

  def initialize(issue_details)
    @issue_details = issue_details
  end

  def cycletime
    filename = 'cycletimes.csv'
    puts "Generating cycletime and writing to #{filename}"

    CSV.open(filename, 'w+') do |csv|
      csv << ['Issue ID', 'Link', 'Title', 'Analysis', 'Ready to Work', 'In Progress', 'Code Review', 'QA', 'PO', 'Done', 'Assignee', 'Status', 'Days in Work']
      issue_details.each do |issue|
        cycle_time = CycleTime.parse issue
        next if (Config::ISSUE_OUTLIERS.include? cycle_time[:id]) ||
                (Config::TRACKERS_TO_SKIP.include? cycle_time[:tracker])
        csv << [cycle_time[:id], cycle_time[:link], cycle_time[:subject],
                cycle_time[:analysis], cycle_time[:ready_to_work],
                cycle_time[:in_progress], cycle_time[:test],
                cycle_time[:resolved], cycle_time[:feedback],
                cycle_time[:done], cycle_time[:assignee],
                cycle_time[:status], calculate_days_in_work(cycle_time)
              ]
      end
    end
  end

  def calculate_days_in_work(row)
    done_date = row[:done]
    start_date = row[:in_progress] || row[:test] || row[:resolved] || row[:feedback] || done_date
    done_date ? (Date.parse(done_date) - Date.parse(start_date)).to_i : nil
  end

  def kickbacks
    filename = 'kickbacks.csv'
    puts "Generating kickbacks and writing to #{filename}"

    all_kickbacks = issue_details.map { |issue| KickbackParser.parse issue }.flatten

    start_time = DateTime.parse(2019, 10,26)
    timeline = (start_time..Time.now).to_a.select { |k| k.wday == 1 }
    timeline_map = timeline.map { |d| { d => 0 } }

    all_kickbacks.each do |kickback|

    end

    total_kickbacks.each do |kickback|
      kicked_on = DateTime.parse(kickback[:kicked_on]).strftime('%m/%d/%Y')
      kickbacks_by_day[kicked_on] = 0 unless kickbacks_by_day.key? kickback[:kicked_on]
      kickbacks_by_day[kicked_on] += 1
    end

    CSV.open(filename, 'w+') do |csv|
      csv << ['Kickback On', 'Kickback Count']

      timeline_map.keys.each do |date|
        csv << [date, timeline_map[date]]
      end
    end
  end
end
