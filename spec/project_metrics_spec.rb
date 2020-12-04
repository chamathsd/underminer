describe ProjectMetrics do
  let(:data) do
    fixture_dir = File.expand_path('../spec/fixtures', __dir__)
    issues = JSON.parse(File.read("#{fixture_dir}/all-issues.json"))
    issues.map { |s| s.deep_symbolize_keys }
  end

  xit 'should work with real data' do
    kickbacks = ProjectMetrics.new(data, {}).kickbacks

    expect(kickbacks[:id]).to eq(123)
    expect(kickback[:kicked_on]).to eq('2020-01-01T10:00:01Z')
    expect(kickback[:kicked_from]).to eq(Config::TEST_STATUS_ID)
  end
end
