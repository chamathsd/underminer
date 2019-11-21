require 'net/http'
require 'uri'
require 'json'

class Fetcher
  def self.all_issue_ids
    response = make_request

    data = JSON.parse(response.body)
    data['issues'].map { |x| x['id'] }
  end

  def self.make_request
    header = {
      'Content-Type': 'application/json',
      'X-Redmine-API-Key': Config.api_key
    }
    uri = all_issues_uri
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri, header)

    http.request(request)
  end

  def self.all_issues_uri
    url = "#{Config.base_url}/issues.json"
    uri = URI(url)
    params = {
      project_id: Config.project_id,
      fixed_version_id: Config.fixed_version_id
    }
    uri.query = URI.encode_www_form(params)
    uri
  end
end
