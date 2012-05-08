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

    attr_accessor :content

    def initialize(content)
      @content = content
    end

    def size
      @content.unpack('C*').size
    end

    def id
      Digest::SHA512.hexdigest @content
    end

    def to_s
      id
    end

    def self.read(id)
      raise unless exists?(id)
      File.open("#{Tornado.root_path}/#{id}", 'rb').read
    end

    def self.save(id, content)
      File.open("#{Tornado.root_path}/#{id}", 'wb') { |f|
        f.write(content)
      }
    end

    def self.exists?(id)
      File.exists? "#{Tornado.root_path}/#{id}"
    end

  end

end