require 'rails_helper'

describe Ftp do
  let(:ftp) { Ftp.new('Alterna_Savings') }

  before :each do
    @sftp_mock = mock('sftp')
    @files_mock = mock('files')
    glob = stub
    glob.stubs(:glob).returns(@files_mock)
    @sftp_mock.stubs(:dir).returns(glob)

    @file_mock = mock('file')
    @file_mock.stubs(:name).returns('filename1')
    @files_mock.stubs(:each).yields(@file_mock)

    Net::SFTP.stubs(:start).yields(@sftp_mock)
  end

  it 'should return a file stream' do
    @sftp_mock.stubs(:download!).returns('test')
    expect(ftp.fetch_data_files).to eq(['public/csv_imports/filename1'])
  end

  it 'should write file' do
    @sftp_mock.stubs(:upload!).returns('test')
    expect(ftp.write("source_path", "destination_path")).to be(nil)
  end

  it 'should archive file' do
    @sftp_mock.stubs(:rename).returns('test')
    expect(ftp.archive("filename")).to be(nil)
  end

end
