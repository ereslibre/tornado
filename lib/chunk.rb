module Tornado

  class Chunk

    attr_accessor :content

    def initialize(content)
      @content = content
    end

    def sha1
      Digest::SHA1.hexdigest @content
    end

    def to_s
      sha1
    end

  end

end