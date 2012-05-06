require 'bdb'

module Tornado

  class Persistent

    @@env = Bdb::Env.new 0
    env_flags =  Bdb::DB_CREATE | Bdb::DB_INIT_TXN | Bdb::DB_INIT_LOCK |
                 Bdb::DB_INIT_MPOOL
    @@env.open Tornado.root_path, env_flags, 0
    @@db = @@env.db
    @@db.open nil, 'tornado.db', nil, Bdb::Db::BTREE, Bdb::DB_CREATE | Bdb::DB_AUTO_COMMIT, 0

    def self.put(key, value)
      txn = @@env.txn_begin nil, 0
      @@db.put txn, key, value, 0
      txn.commit 0
    end

    def self.get(key)
      @@db.get nil, key, nil, 0
    end

    def self.close
      @@db.close 0
      @@env.close
    end

  end

end

at_exit do
  Tornado::Persistent.close
  Tornado.std_log 'closing database'
end