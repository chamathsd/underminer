class Config
  def self.project_id
    '745'
  end

  def self.fixed_version_id
    '1207'
  end

  def self.api_key
    ENV['UNDERMINER_API_KEY']
  end

  def self.base_url
    ENV['UNDERMINER_BASE_URL']
  end
end
