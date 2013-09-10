require 'spec_helper'

describe CloudantBackup do
  let(:options) do
    { content_type: :json, accept: :json }
  end

  let(:date){ Date.today.strftime('%Y_%m_%d') }

  let(:cb) do
    cb = CloudantBackup.new
    cb.user          = 'backup-user'
    cb.password      = 'password'
    cb.source        = 'production-db'
    cb.cloudant_host = 'main-user'
    cb
  end

  context "automatic target db name" do
    it "creates the backup db" do
      url = "https://backup-user:password@main-user.cloudant.com/production-db-backup_#{date}"
      RestClient.should_receive(:put).with(url, options)
      cb.create_target_db
    end

    it "does not complain when the target existed already" do
      url = "https://backup-user:password@main-user.cloudant.com/production-db-backup_#{date}"
      RestClient.should_receive(:put).with(url, options).and_raise(RestClient::PreconditionFailed)
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

  context "target db override" do
    it "creates the backup db" do
      cb.target = 'custom-name'
      url = "https://backup-user:password@main-user.cloudant.com/custom-name"
      RestClient.should_receive(:put).with(url, options)
      cb.create_target_db
    end

    it "triggers the replication" do
      cb.target = 'custom-name'
      url = "https://backup-user:password@main-user.cloudant.com/_replicate"
      source_db = "https://backup-user:password@main-user.cloudant.com/production-db"
      target_db = "https://backup-user:password@main-user.cloudant.com/custom-name"
      data = {
        source: source_db,
        target: target_db
      }.to_json
      RestClient.should_receive(:post).with(url, data, options)
      cb.replicate
    end
  end

  context "not using cloudant at all" do
    it "creates the backup db" do
      cb.host   = 'my-couchdb.com'
      cb.target = 'custom-name'
      url = "https://backup-user:password@my-couchdb.com/custom-name"
      RestClient.should_receive(:put).with(url, options)
      cb.create_target_db
    end

    it "triggers the replication" do
      cb.target = 'custom-name'
      cb.host   = 'my-couchdb.com'
      url = "https://backup-user:password@my-couchdb.com/_replicate"
      source_db = "https://backup-user:password@my-couchdb.com/production-db"
      target_db = "https://backup-user:password@my-couchdb.com/custom-name"
      data = {
        source: source_db,
        target: target_db
      }.to_json
      RestClient.should_receive(:post).with(url, data, options)
      cb.replicate
    end
  end
end
