describe KickbackParser do
  let(:data) do
    {
      id: 123,
      subject: 'my subject',
      journals: [{
        id: '197418',
        user: {
          id: 3848,
          name: 'Ali.Yasir.1262049333'
        },
        notes: '',
        created_on: '2019-11-12T22:36:46Z',
        details: [{
          property: 'attr',
          name: 'status_id',
          old_value: '1',
          new_value: '4'
        }, {
          property: 'attr',
          name: 'assigned_to_id',
          new_value: '3848'
        }]
      }, {
        id: '197991',
        user: {
          id: 3834,
          name: 'Kaesberg.Jennifer.1572613875'
        },
        notes: '',
        created_on: '2019-11-14T18:20:19Z',
        details: [{
          property: 'attr',
          name: 'category_id',
          new_value: '510'
        }]
      }, {
        id: '198164',
        user: {
          id: 3834,
          name: 'Kaesberg.Jennifer.1572613875'
        },
        notes: '',
        created_on: '2019-11-15T13:46:22Z',
        details: [{
          property: 'attr',
          name: 'category_id',
          old_value: '510',
          new_value: '511'
        }]
      }, {
        id: '198177',
        user: {
          id: 2731,
          name: 'Mayo.Jeffrey.1094534468'
        },
        notes: '',
        created_on: '2019-11-15T14:45:35Z',
        details: [
          {
            property: 'attr',
            name: 'status_id',
            old_value: '4',
            new_value: '10'
          }
        ]
      }, {
        id: '198276',
        user: {
          id: 3835,
          name: 'Huffman.Nichole.1572628627'
        },
        notes: '',
        created_on: '2019-11-15T17:17:48Z',
        details: [{
          property: 'attr',
          name: 'status_id',
          old_value: '10',
          new_value: '3'
        }]
      }, {
        id: '199668',
        user: {
          id: 3547,
          name: 'Moncayo.Miguel.1235296914'
        },
        notes: '',
        created_on: '2019-11-19T15:42:05Z',
        details: [{
          property: 'attr',
          name: 'status_id',
          old_value: '3',
          new_value: '11'
        }]
      }, {
        id: '199669',
        user: {
          id: 3547,
          name: 'Moncayo.Miguel.1235296914'
        },
        notes: '',
        created_on: '2020-01-01T10:00:01Z',
        details: [{
          property: 'attr',
          name: 'status_id',
          old_value: '11',
          new_value: '10'
        }]
      }, {
        id: '199670',
        user: {
          id: 3835,
          name: 'Huffman.Nichole.1572628627'
        },
        notes: '',
        created_on: '2019-11-21T17:42:05Z',
        details: [{
          property: 'attr',
          name: 'status_id',
          old_value: '10',
          new_value: '3'
        }]
      }, {
        id: '199668',
        user: {
          id: 3547,
          name: 'Moncayo.Miguel.1235296914'
        },
        notes: '',
        created_on: '2019-11-22T06:22:45Z',
        details: [{
          property: 'attr',
          name: 'status_id',
          old_value: '3',
          new_value: '11'
        }]
      }]
    }
  end

  it 'should translate to graphable csv data' do
    kickback = KickbackParser.parse(data).first

    expect(kickback[:id]).to eq(123)
    expect(kickback[:kicked_on]).to eq('2020-01-01T10:00:01Z')
    expect(kickback[:kicked_from]).to eq(Config::TEST_STATUS_ID)
  end

  describe '#status_change?' do
    it 'should return false for non-status ids changes' do
      entry = {
        id: 'with_status',
        details: [{ name: 'foo' }]
      }
      expect(KickbackParser.status_change?(entry)).to be false
    end

    it 'should return true for status ids changes' do
      entry = {
        id: 'with_status',
        details: [{ name: 'status_id' }]
      }
      expect(KickbackParser.status_change?(entry)).to be true
    end
  end

  describe '#format_status_change' do
    it 'should contain a from' do
      entry = {
        id: 'id 123',
        details: [{
          old_value: 'old 1',
          new_value: 'new 1',
          name: 'status_id'
        }, {
          old_value: 'old 2',
          new_value: 'new 2',
          name: 'non_status_id'
        }],
        created_on: 'created on'
      }
      actual = KickbackParser.format_status_change entry
      expect(actual).to eq(created_on: 'created on', from: 'old 1', to: 'new 1')
    end

    it 'should return true for status ids changes' do
      entry = {
        id: 'with_status',
        details: [{ name: 'status_id' }]
      }
      expect(KickbackParser.status_change?(entry)).to be true
    end
  end

  describe '#add_kickback' do
    describe 'go from analysis to ready' do
      it 'should not be a kickback so it should be nil' do
        entry = {
          created_on: 'created on',
          from: Config::ANALYSIS_STATUS_ID,
          to: Config::READY_TO_WORK_STATUS_ID
        }
        actual = KickbackParser.add_kickback entry

        expect(actual).to be nil
      end
    end

    describe 'go from ready to analysis' do
      it 'should be a kickback and have an id and kicked on date' do
        entry = {
          id: 'id 123',
          created_on: 'created on',
          from: Config::READY_TO_WORK_STATUS_ID,
          to: Config::ANALYSIS_STATUS_ID
        }
        actual = KickbackParser.add_kickback entry

        expect(actual[:kicked_on]).to eq('created on')
      end

      it 'should be a kickback' do
        entry = {
          from: Config::READY_TO_WORK_STATUS_ID,
          to: Config::ANALYSIS_STATUS_ID
        }
        actual = KickbackParser.add_kickback entry
        expect(actual[:kicked_from]).to eq(Config::READY_TO_WORK_STATUS_ID)
      end
    end

    describe 'go from ready to in progress' do
      it 'should be nil' do
        entry = {
          from: Config::READY_TO_WORK_STATUS_ID,
          to: Config::IN_PROGRESS_STATUS_ID
        }
        actual = KickbackParser.add_kickback entry
        expect(actual).to be nil
      end
    end

    describe 'go from ready to analysis' do
      it 'should be a kickback' do
        entry = {
          from: Config::READY_TO_WORK_STATUS_ID,
          to: Config::ANALYSIS_STATUS_ID
        }
        actual = KickbackParser.add_kickback entry
        expect(actual[:kicked_from]).to eq(Config::READY_TO_WORK_STATUS_ID)
      end
    end

    describe 'go from in process to test' do
      it 'should be nil' do
        entry = {
          from: Config::IN_PROGRESS_STATUS_ID,
          to: Config::TEST_STATUS_ID
        }
        actual = KickbackParser.add_kickback entry
        expect(actual).to be nil
      end
    end

    describe 'go from test to in process' do
      it 'should be nil' do
        entry = {
          from: Config::TEST_STATUS_ID,
          to: Config::IN_PROGRESS_STATUS_ID
        }
        actual = KickbackParser.add_kickback entry
        expect(actual[:kicked_from]).to eq(Config::TEST_STATUS_ID)
      end
    end
  end
end
