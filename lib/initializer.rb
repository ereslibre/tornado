module Tornado

  def self.root_path
    File.join Dir.home, '.tornado'
  end

  Dir.mkdir root_path unless File.exists? root_path

end