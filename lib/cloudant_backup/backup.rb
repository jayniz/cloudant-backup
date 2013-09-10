require 'date'
require 'json'
require 'rest_client'

class CloudantBackup
  module Backup
    attr_accessor :user, :password, :source, :target, :host, :date_pattern, :cloudant_host

    def initialize
    end

    def backup
      create_target_db
      replicate
    end

    def create_target_db
      make_request(:put, target_db)
    rescue RestClient::PreconditionFailed
      # When the db existed already, we're fine with that
    end

    def replicate
      data = {
        source: source_db_url,
        target: target_db_url
      }.to_json
      make_request(:post, "_replicate", data)
    end

    private

    def date_string
      Date.today.strftime(@date_pattern || '%Y_%m_%d')
    end

    def host
      return @host if @host
      subdomain = @cloudant_host || @user # Cloudant's default is username==hostname (for the main user)
      "#{subdomain}.cloudant.com"
    end

    def validate_options!
      raise "Need to set source" unless @source
    end

    def target_db
      @target || "#{@source}-backup_#{date_string}"
    end

    def target_db_url
      db_url(target_db)
    end

    def source_db_url
      db_url(@source)
    end

    def db_url(name)
      "https://#{user}:#{password}@#{host}/#{name}"
    end

    def make_request(method, url, data = nil)
      options = {
        content_type: :json,
        accept:       :json
      }
      RestClient.send(*[method, db_url(url), data, options].compact)
    end
  end
end
