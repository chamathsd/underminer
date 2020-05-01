class Config
  def self.api_key
    ENV['UNDERMINER_API_KEY']
  end

  def self.base_url
    ENV['UNDERMINER_BASE_URL']
  end

  PROJECT_ID = '745'.freeze
  FIXED_VERSION_IDS = %w[1207 1228 1271].freeze

  ANALYSIS_STATUS_ID = '4'.freeze
  READY_TO_WORK_STATUS_ID = '10'.freeze
  IN_PROGRESS_STATUS_ID = '3'.freeze
  TEST_STATUS_ID = '11'.freeze
  FEEDBACK_STATUS_ID = '5'.freeze
  DONE_STATUS_ID = '9'.freeze

  COLUMN_ORDER = {
    Config::ANALYSIS_STATUS_ID => 1,
    Config::READY_TO_WORK_STATUS_ID => 2,
    Config::IN_PROGRESS_STATUS_ID => 3,
    Config::TEST_STATUS_ID => 4,
    Config::FEEDBACK_STATUS_ID => 5,
    Config::DONE_STATUS_ID => 6
  }.freeze
end
