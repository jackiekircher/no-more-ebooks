class TwitterAPIKeys

  def initialize(keys_file)
    @keys = YAML.load_file(keys_file)
  end

  def consumer_key
    @keys.fetch('consumer_key')
  end

  def consumer_secret
    @keys.fetch('consumer_secret')
  end

  def access_token
    @keys.fetch('access_token')
  end

  def access_token_secret
    @keys.fetch('access_token_secret')
  end
end
