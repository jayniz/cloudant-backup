require 'spec_helper'

describe CloudantBackup do
  context "correctly configured" do
    let(:options) do
      { content_type: :json, accept: :json }
    end

    let(:date){ Date.today.strftime('%Y_%m_%d') }

    let(:cb) do
      cb = CloudantBackup.new
      cb.user     = 'backup-user'
      cb.password = 'password'
      cb.source   = 'production-db'
      cb.host     = 'main-user'
      cb
    end

    it "creates the backup db" do
      url = "https://backup-user:password@main-user.cloudant.com/production-db-backup_#{date}"
      RestClient.should_receive(:put).with(url, options)
      cb.create_target_db
    end

    it "triggers the replication" do
      url = "https://backup-user:password@main-user.cloudant.com/_replicate"
      source_db = "https://backup-user:password@main-user.cloudant.com/production-db"
      data = {
        source: source_db,
        target: "#{source_db}-backup_#{date}"
      }.to_json
      RestClient.should_receive(:post).with(url, data, options)
      cb.replicate
    end
  end
end
