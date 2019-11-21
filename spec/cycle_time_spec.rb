describe CycleTime do
  it 'should do something' do
    data = {
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
      }]
    }
    cycletime = CycleTime.parse(data)

    expect(cycletime[:id]).to eq(123)
    expect(cycletime[:subject]).to eq('my subject')
    expect(cycletime[:analysis]).to eq('2019-11-12T22:36:46Z')
    expect(cycletime[:ready_to_work]).to eq('2019-11-15T14:45:35Z')
    expect(cycletime[:in_progress]).to eq('2019-11-15T17:17:48Z')
    expect(cycletime[:test]).to eq('2019-11-19T15:42:05Z')
  end
end
