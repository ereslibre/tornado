module Tornado

  class Network

    @@peers = Config.trusted_peers
    @@files = Hash.new # FIXME: more consistent storage :)

    def self.chunks(id)
      @@files[id]
    end

    def self.chunk(id)
      Chunk.read id
    end

    def self.upload(file_path)
      file = File.open file_path
      chunks = file.chunk
      find_peer.upload file.id, chunks
    end

    def self.propagate_chunks(id, chunks)
      @@files[id] = chunks
    end

    def self.propagate_chunk(id, content)
      Chunk.save id, content
    end

    def self.peers
      @@peers
    end

    private

    def self.find_peer
      Peer.new peers.first
    end

  end

end