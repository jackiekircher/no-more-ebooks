##
# sets up everything that's needed in order to make some
# Twitter API requests and log it all

require 'yaml'
require 'logger'
require 'twitter'
require_relative 'api_keys'
require_relative '../client'
require_relative '../ebook_account'

module NoMoreEbooks

  PATH      = File.expand_path("..", File.dirname(__FILE__))
  KEYS      = PATH + "/config/keys.yml"
  ACC_LOG   = PATH + "/logs/accounts.log"
  BLOCKLIST = PATH + "/db/accounts.stuff"

  def client
    @client ||= Client.new
  end

  def logger
    @logger ||= Logger.new(ACC_LOG, 10, 1024000).tap do |l|
                  l.formatter =
                    proc do |level, datetime, prgname, msg|
                      "\n[#{datetime}] #{level}\n  #{msg}\n"
                    end
                end
  end

  def self.api_keys
    APIKeys.new(KEYS)
  end

end
