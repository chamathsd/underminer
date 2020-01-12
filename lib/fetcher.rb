require 'net/http'
require 'uri'
require 'json'
require 'byebug'

class Fetcher
  def self.all_issue_ids
    all_issues = []
    offset = 0

    loop do
      response = all_issues_request offset
      puts "request was a #{response.is_a?(Net::HTTPSuccess) ? 'success' : 'failure'}"
      return response.value unless response.is_a?(Net::HTTPSuccess)

      data = JSON.parse(response.body)
      total_issues = data['total_count']
      all_issues += data['issues']

      puts "received #{data['issues'].count} issues - out of #{total_issues} total issues"
      break if all_issues.count == total_issues.to_i
    end

    all_issues.map { |x| x['id'] }
  end

  def self.issue_details(issue_id)
    response = make_issue_details_request issue_id

    return response.value unless response.is_a?(Net::HTTPSuccess)

    format_response response
  end

  def self.format_response(response)
    data = JSON.parse(response.body)

    {
      id: data['issue']['id'],
      subject: data['issue']['subject'],
      category: category(data),
      status: data['issue']['status']['name'],
      journals: data['issue']['journals']
    }
  end

  def self.category(data)
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

    puts 'Requesting issue details'
    puts "HTTP GET #{uri}"
    http.request(request)
  end

  def self.all_issues_request(offset)
    header = {
      'Content-Type': 'application/json',
      'X-Redmine-API-Key': Config.api_key
    }
    uri = all_issues_uri offset
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri, header)

    puts 'Requesting all issues'
    puts "HTTP GET #{uri}"

    http.request(request)
  end

  def self.all_issues_uri(offset)
    uri = URI("#{Config.base_url}/issues.json")
    params = {
      project_id: Config.project_id,
      fixed_version_ids: Config.fixed_version_id,
      limit: 100,
      status_id: '*',
      offset: offset
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
