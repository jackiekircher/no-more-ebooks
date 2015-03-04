class EbookAccount < ActiveRecord::Base
  ##
  # twitter_id:integer
  # => the ID that twitter has assigned to the user

  ##
  # screen_name:string
  # => the twitter accounts screen name, this is currently
  #    the exclusive heuristic for finding _ebooks accounts

  ##
  # whitelisted:boolean
  # => whether or not the account is actually a bot.
  #    whitelisted accounts are actual people and won't
  #    ever be blocked by this app.
  #
  #    defaults to false.
  scope :whitelisted, -> { where(whitelisted: true)  }
  scope :bots,        -> { where(whitelisted: false) }

  def whitelisted?
    return whitelisted
  end
end
