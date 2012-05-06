class File

  attr_reader :chunks

  def chunk
    @chunks = Array.new
    self.rewind
    while (content = self.read(102400))
      @chunks << Tornado::Chunk.new(content)
    end
    @chunks
  end

  def id
    self.rewind
    Digest::SHA512.hexdigest self.read
  end

end