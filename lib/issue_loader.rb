class IssueLoader
  def self.load_issue_details
    all_issue_ids = AllIssuesFetcher.new.fetch
    puts "Found #{all_issue_ids.count} issues in project #{Config::PROJECT_ID}"

    all_issue_ids.each_with_index.map do |issue_id, index|
      update_progress_bar index + 1, all_issue_ids.count
      IssueDetailsFetcher.new.fetch issue_id
    end
  end

  def self.update_progress_bar(progress, total)
    if progress == total
      printf("\rFetching details: [%-20s]\n", "#{'=' * 15}Done!")
    else
      printf("\rFetching details: [%-20s]", '=' * ((progress.to_f / total) * 20))
    end
  end
end
