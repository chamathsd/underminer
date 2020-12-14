class IssueLoader
  def self.load_issue_details(issue_ids = nil)
    if issue_ids.nil?
      begin
        issue_ids = AllIssuesFetcher.new.fetch
      rescue => e
        abort("Failed to retrieve all issue IDs. Please try again.")
      end
    end

    puts "Retrieving #{issue_ids.count} issues from project #{Config::PROJECT_ID}"
    puts "However, not all those will be included in metrics"

    issue_id_to_title = {}
    unresolved_issues = []

    issues = issue_ids.each_with_index.map do |issue_id, index|
      begin
        update_progress_bar index + 1, issue_ids.count
        issue = IssueDetailsFetcher.new.fetch issue_id
        issue_id_to_title[issue[:id]] = issue[:subject]
        issue
      rescue => e
        unresolved_issues.push(issue_id)
        nil
      end
    end

    process_unresolved_issues(unresolved_issues)

    return issues, issue_id_to_title
  end

  def self.update_progress_bar(progress, total)
    if progress == total
      printf("\rFetching details: [%-20s]\n", "#{'=' * 15}Done!")
    else
      printf("\rFetching details: [%-20s]", '=' * ((progress.to_f / total) * 20))
    end
  end

  def self.process_unresolved_issues(issues)
    if issues.length > 0
      output_filename = "failed_issues.#{Time.now.strftime("%Y%m%d_%H:%M:%S")}.txt"
      puts "#{issues.length} issue(s) failed to load. Writing to output file #{output_filename}..."
      File.open(output_filename, "w+") do |f|
        f.puts(issues)
      end
    end
  end
end
