require 'net/http'
require 'uri'
require 'json'
require 'byebug'

class IssueDetailsFetcher
  def fetch(issue_id)
    response = make_issue_details_request issue_id

    raise 'Request was a failure' unless response.is_a?(Net::HTTPSuccess)

    format_response response
  end

  private 
  def format_response(response)
    data = JSON.parse(response.body)

    {
      id: data['issue']['id'],
      subject: data['issue']['subject'],
      link: "#{Config.base_url}/issues/#{data['issue']['id']}",
      status: data['issue']['status']['name'],
      journals: data['issue']['journals'],
      assignee: assigned_to(data),
      tracker: data['issue']['tracker']['name'],
      description: data['issue']['description'],
      parent_id: parent_id(data),
      target_version_name: target_version_name(data),
      target_version_id: target_version_id(data)
    }
  end

  def assigned_to(data)
    assigned_to = ''
    if data['issue'].key?('assigned_to')
      unless data['issue']['assigned_to'].nil?
        if data['issue']['assigned_to'].key?('name')
          unless data['issue']['assigned_to']['name'].nil?
            assigned_to = data['issue']['assigned_to']['name']
          end
        end
      end
    end
  end

  def parent_id(data)
    parent_id = ''
    if data['issue'].key?('parent')
      unless data['issue'].key?('parent').nil?
        if data['issue']['parent'].key?('id')
          unless data['issue']['parent']['id'].nil?
            parent_id = data['issue']['parent']['id']
          end
        end
      end
    end
  end

  def target_version_name(data)
    fixed_version_name = ''
    if data['issue'].key?('fixed_version')
      unless data['issue'].key?('fixed_version').nil?
        if data['issue']['fixed_version'].key?('name')
          unless data['issue']['fixed_version']['name'].nil?
            fixed_version_name = data['issue']['fixed_version']['name']
          end
        end
      end
    end
  end

  def target_version_id(data)
    fixed_version_id = ''
    if data['issue'].key?('fixed_version')
      unless data['issue'].key?('fixed_version').nil?
        if data['issue']['fixed_version'].key?('id')
          unless data['issue']['fixed_version']['id'].nil?
            fixed_version_id = data['issue']['fixed_version']['id']
          end
        end
      end
    end
  end

  def make_issue_details_request(issue_id)
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

  def issue_details_uri(issue_id)
    url = "#{Config.base_url}/issues/#{issue_id}.json"
    uri = URI(url)
    params = {
      include: 'journals'
    }
    uri.query = URI.encode_www_form(params)
    uri
  end
end
