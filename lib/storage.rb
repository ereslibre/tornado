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

  class Storage

    def self.check_integrity
      valid = 0
      total_size = 0
      total_real_size = 0
      invalid_size = 0
      invalid_real_size = 0
      invalid = Array.new
      all_chunks = Chunk.all
      i = 1
      all_chunks.each do |chunk|
        if chunk.healthy?
          valid += 1
        else
          invalid << chunk
          invalid_size += chunk.size
          invalid_real_size += chunk.real_size
        end
        total_size += chunk.size
        total_real_size += chunk.real_size
        Tornado.std_progress "checking integrity of chunk #{i} of #{all_chunks.count}"
        i += 1
      end
      Tornado.stop_std_progress
      if all_chunks.count != 0
        percent_valid = valid * 100 / all_chunks.count
        puts 'summary'
        puts "total chunks: #{all_chunks.count}"
        puts "total size: #{total_size} bytes"
        puts "total real size: #{total_real_size} bytes"
        puts "invalid chunks size: #{invalid_size} bytes"
        puts "invalid chunks real size: #{invalid_real_size} bytes"
        puts "valid chunks: #{percent_valid}%"
        puts "invalid chunks: #{invalid.count}"
      else
        puts 'your storage is empty yet !'
      end
    end

  end

end