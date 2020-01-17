class KickbackParser
  def self.parse(issue_detail)
    extract_status_changes issue_detail[:id], issue_detail[:journals]
  end

  def self.extract_status_changes(id, journals)
    journals
      .select(&method(:status_change?))
      .map(&method(:from_status_change))
      .map(&method(:add_kickback))
      .compact
      .map { |entry| entry.merge(id: id) }
  end

  def self.status_change?(journal)
    journal[:details].any? { |detail| detail[:name] == 'status_id' }
  end

  def self.from_status_change(journal_entry)
    transition = journal_entry[:details].select { |entry| entry[:name] == 'status_id' }.first

    {
      id: journal_entry[:id],
      created_on: journal_entry[:created_on],
      from: transition[:old_value],
      to: transition[:new_value]
    }
  end

  def self.add_kickback(journal_entry)
    return unless kickback?(journal_entry)

    {
      id: journal_entry[:id],
      kicked_on: journal_entry[:created_on],
      kicked_from: journal_entry[:from]
    }
  end

  def self.kickback?(journal_entry)
    return if Config::COLUMN_ORDER[journal_entry[:from]].nil?
    return if Config::COLUMN_ORDER[journal_entry[:to]].nil?

    Config::COLUMN_ORDER[journal_entry[:from]] > Config::COLUMN_ORDER[journal_entry[:to]]
  end
end
