require 'net/http'
require 'uri'
require 'json'

class Fetcher
  def self.all_issue_ids
    response = all_issues_request

    return response.value unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    data['issues'].map { |x| x['id'] }
  end

  def self.issue_details(issue_id)
    response = make_issue_details_request issue_id

    return response.value unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    category = ''
    if data['issue'].key?('category')
      unless data['issue']['category'].nil?
        if data['issue']['category'].key?('name')
          unless data['issue']['category']['name'].nil?
            category = data['issue']['category']['name']
          end
        end
      end
    end

    {
      id: data['issue']['id'],
      title: data['issue']['subject'],
      category: category,
      status: data['issue']['status']['name'],
      journals: data['issue']['journals']
    }
  end

  def self.make_issue_details_request(issue_id)
    header = {
      'Content-Type': 'application/json',
      'X-Redmine-API-Key': Config.api_key
    }
    uri = issue_details_uri issue_id
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri, header)

    http.request(request) 
  end

  def self.all_issues_request
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

  def self.issue_details_uri(issue_id)
    url = "#{Config.base_url}/issues/#{issue_id}.json"
    uri = URI(url)
    params = {
      include: 'journals'
    }
    uri.query = URI.encode_www_form(params)
    uri
  end
end
