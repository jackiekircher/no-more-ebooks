class BlockList

  def initialize(file)

    @blocked = []
    File.open(file, 'r') do |file|
      file.each do |line|
        account = line.split(":")
        @blocked << {          id: account[0].strip,
                      screen_name: account[1].strip  }
      end
    end
  end

  def full_list
    @blocked
  end

  def names
    @blocked.map{|account| account[:screen_name]}
  end

  def sorted_names
    names.sort
  end

  def ids
    @blocked.map{|account| account[:id]}
  end

  def sorted_ids
    ids.sort
  end

  def -(new_list)
    @blocked - new_list.full_list
  end
end
