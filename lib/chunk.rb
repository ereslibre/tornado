# Copyright (c) 2012 Rafael Fernández López <ereslibre@ereslibre.es>
#
# Permission is hereby granted, free of charge, to any
# person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the
# Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the
# Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice
# shall be included in all copies or substantial portions of
# the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
# KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
# OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module Tornado

  class Chunk

    attr_accessor :offset, :filename

    def content
      @content
    end

    def raw_content
      @raw_content
    end

    def content=(content)
      @content = content
      @raw_content = Base64.decode64 @content
    end

    def raw_content=(raw_content)
      @raw_content = raw_content
      @content = Base64.encode64 @raw_content
    end

    def size
      @raw_content.unpack('C*').size
    end

    def real_size
      Chunk.size @filename
    end

    def id
      Digest::SHA512.hexdigest @raw_content
    end

    def to_s
      id
    end

    def save
      Chunk.save id, @content
    end

    def healthy?
      id == @filename
    end

    def self.all
      res = Array.new
      Dir.glob(File.join(Tornado.root_path, '*')) do |file|
        filename = File.basename file
        next unless filename =~ /^\w{128}$/
        res << find(filename)
      end
      res
    end

    def self.find(id)
      chunk = Chunk.new
      chunk.filename = id
      chunk.content = self.read id
      chunk
    end

    def self.default_size
      1048576
    end

    private

    def self.read(id)
      raise unless exists?(id)
      File.open(File.join(Tornado.root_path, id), 'rb').read
    end

    def self.save(id, content)
      raise if exists?(id)
      File.open(File.join(Tornado.root_path, id), 'wb') { |f|
        f.write(content)
      }
    end

    def self.size(id)
      File.size File.join(Tornado.root_path, id)
    end

    def self.exists?(id)
      File.exists? File.join(Tornado.root_path, id)
    end

  end

end