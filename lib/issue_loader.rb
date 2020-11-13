class IssueLoader
  def self.load_issue_details
    all_issue_ids = AllIssuesFetcher.new.fetch
    puts "Found #{all_issue_ids.count} total issues in project #{Config::PROJECT_ID}"
    puts "However, not all those will be included in metrics"

    issue_id_to_title = {}

    issues = all_issue_ids.each_with_index.map do |issue_id, index|
      update_progress_bar index + 1, all_issue_ids.count
      issue = IssueDetailsFetcher.new.fetch issue_id
      issue_id_to_title[issue[:id]] = issue[:subject]
      issue
    end
    return issues, issue_id_to_title
  end

  def self.update_progress_bar(progress, total)
    if progress == total
      printf("\rFetching details: [%-20s]\n", "#{'=' * 15}Done!")
    else
      printf("\rFetching details: [%-20s]", '=' * ((progress.to_f / total) * 20))
    end
  end
end
