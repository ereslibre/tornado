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

require 'bdb'

module Tornado

  class Persistent

    @env = Bdb::Env.new 0
    env_flags =  Bdb::DB_CREATE | Bdb::DB_INIT_TXN | Bdb::DB_INIT_LOCK |
                 Bdb::DB_INIT_MPOOL
    @env.open Tornado.root_path, env_flags, 0
    @db = @env.db
    @db.open nil, 'tornado.db', nil, Bdb::Db::BTREE, Bdb::DB_CREATE | Bdb::DB_AUTO_COMMIT, 0

    def self.put(key, value)
      txn = @env.txn_begin nil, 0
      @db.put txn, key, value, 0
      txn.commit 0
    end

    def self.get(key)
      @db.get nil, key, nil, 0
    end

    def self.close
      @db.close 0
      @env.close
    end

  end

end

at_exit do
  Tornado::Persistent.close
end