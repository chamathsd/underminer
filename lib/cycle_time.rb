require 'byebug'
require 'ap'
require 'date'
require 'active_support'
require 'active_support/core_ext'
require 'csv'

class CycleTime
  def self.parse(issue_detail)
    issue_detail.deep_symbolize_keys!
    {
      id: issue_detail[:id],
      link: issue_detail[:link],
      subject: issue_detail[:subject],
      analysis: analysis(issue_detail[:journals]),
      ready_to_work: ready_to_work(issue_detail[:journals]),
      in_progress: in_progress(issue_detail[:journals]),
      test: test(issue_detail[:journals]),
      feedback: feedback(issue_detail[:journals]),
      done: done(issue_detail[:journals]),
      assignee: issue_detail[:assignee],
      status: issue_detail[:status]
    }
  end

  def self.analysis(journals)
    get_cycletime_for journals, Config::ANALYSIS_STATUS_ID
  end

  def self.in_progress(journals)
    get_cycletime_for journals, Config::IN_PROGRESS_STATUS_ID
  end

  def self.ready_to_work(journals)
    get_cycletime_for journals, Config::READY_TO_WORK_STATUS_ID
  end

  def self.test(journals)
    get_cycletime_for journals, Config::TEST_STATUS_ID
  end

  def self.feedback(journals)
    get_cycletime_for journals, Config::FEEDBACK_STATUS_ID
  end

  def self.done(journals)
    get_cycletime_for journals, Config::DONE_STATUS_ID
  end

  def self.get_cycletime_for(journals, datum)
    status_change = journals.select do |journal|
      journal[:details].any? do |detail|
        detail[:name] == 'status_id' && detail[:new_value] == datum
      end
    end
    status_change.last[:created_on] if status_change.any?
  end
end
