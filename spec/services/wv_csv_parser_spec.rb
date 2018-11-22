require 'rails_helper'

describe WvCsvParser do

  it 'should be able to process only success rows' do
    present_count = WvToMailchimpOperation.count
    CSV.expects(:foreach).multiple_yields(
        [['02', '20170627', '12', 'sravani.p@cybrilla.com', 'Sravani', 'Perala',
          'Y', '01|02', 'EN', 'Business', 'INHS10-MIC', '20170622']],
        [['03', '20170627', '12', 'sravani.p@cybrilla.com', 'Sravani', 'Perala',
          'Y', '01|02', 'EN', 'Business', 'INHS10-MIC', '20170622']],
        [['03', '20170627', '12', 'sravani.p+01@cybrilla.com', 'Sravani', 'Perala',
          'Y', '', 'EN', 'Business', 'INHS10-MIC', '20170622']]
      )
    WvCsvParser.new({listname: 'Alterna_Savings', filepath: 'test_file'}).perform
    expect(WvToMailchimpOperation.count).to eq(present_count+2)
  end

  it 'should be able to perform new user create action based on op code' do
    CSV.expects(:foreach).multiple_yields(
        [['01', '20170627', '12', 'sravani.p@cybrilla.com', 'Sravani', 'Perala',
          'Y', '01|02', 'EN', 'Business', 'INHS10-MIC', '20170622', 'IT']]
      )
    expect{WvCsvParser.new({listname: 'Alterna_Savings', filepath: 'test_file'}).perform}.to change{WvToMailchimpOperation.count}.by(1)
  end

  it 'should be able to perform change in consent action based on op code' do
    CSV.expects(:foreach).multiple_yields(
        [['02', '20170627', '12', 'sravani.p@cybrilla.com', 'Sravani', 'Perala',
          'Y', '01|02', 'EN', 'Business', 'INHS10-MIC', '20170622']]
      )
    expect{WvCsvParser.new({listname: 'Alterna_Savings', filepath: 'test_file'}).perform}.to change{WvToMailchimpOperation.count}.by(1)
  end

  it 'should be able to perform change in opt-ins action based on op code' do
    CSV.expects(:foreach).multiple_yields(
        [['03', '20170627', '12', 'sravani.p@cybrilla.com', 'Sravani', 'Perala',
          'Y', '01|02', 'EN', 'Business', 'INHS10-MIC', '20170622']]
      )
    expect{WvCsvParser.new({listname: 'Alterna_Savings', filepath: 'test_file'}).perform}.to change{WvToMailchimpOperation.count}.by(1)
  end

  it 'should be able to perform change in email action based on op code' do
    CSV.expects(:foreach).multiple_yields(
        [['04', '20170627', '12', 'sravani.p@cybrilla.com', 'Sravani', 'Perala',
          'Y', '01|02', 'EN', 'Business', 'INHS10-MIC', '20170622', 'IT', 'sravani.p+1@cybrilla.com']]
      )
    expect{WvCsvParser.new({listname: 'Alterna_Savings', filepath: 'test_file'}).perform}.to change{WvToMailchimpOperation.count}.by(1)
  end

  it 'should be able to perform account close action based on op code' do
    CSV.expects(:foreach).multiple_yields(
        [['05', '20170627', '12', 'sravani.p@cybrilla.com', 'Sravani', 'Perala',
          'Y', '01|02', 'EN', 'Business', 'INHS10-MIC', '20170622']]
      )
    expect{WvCsvParser.new({listname: 'Alterna_Savings', filepath: 'test_file'}).perform}.to change{WvToMailchimpOperation.count}.by(1)
  end

end
