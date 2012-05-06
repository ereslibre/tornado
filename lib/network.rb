module Tornado

  class Network

    def chunks(id)
    end

    def chunk(id)
    end

    def upload(file_path)
      file = File.open file_path
      chunks = file.chunk
      peer = peers.first
    end

    def peers
    end

  end

end