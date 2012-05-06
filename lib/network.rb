module Tornado

  class Network

    @@peers = Config.trusted_peers

    def self.chunks(id)
    end

    def self.chunk(id)
    end

    def self.upload(file_path)
      file = File.open file_path
      chunks = file.chunk
      peer = find_peer
    end

    def self.peers
      @@peers
    end

    private

    def self.find_peer
      peers.first
    end

  end

end