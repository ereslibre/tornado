module Tornado

  class Chunk

    attr_accessor :content

    def initialize(content)
      @content = content
    end

    def size
      @content.unpack('C*').size
    end

    def id
      Digest::SHA1.hexdigest @content
    end

    def to_s
      id
    end

    def self.read(id)
      raise unless exists?(id)
      File.open("#{Tornado.root_path}/#{id}", 'rb').read
    end

    def self.save(id, content)
      raise unless id == Digest::SHA1.hexdigest(content)
      File.open("#{Tornado.root_path}/#{id}", 'w') { |f| f.write(Base64.encode64 content) }
    end

    def self.exists?(id)
      File.exists? "#{Tornado.root_path}/#{id}"
    end

  end

end