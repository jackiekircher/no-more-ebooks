class EbookAccount < ActiveRecord::Base
  ##
  # twitter_id:integer
  # => the ID that twitter has assigned to the user

  ##
  # screen_name:string
  # => the twitter accounts screen name, this is currently
  #    the exclusive heuristic for finding _ebooks accounts

end
