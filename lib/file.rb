class File

  attr_reader :chunks

  def chunk
    @chunks = Array.new
    self.rewind
    while (content = self.read(512))
      @chunks << Tornado::Chunk.new(content)
    end
    @chunks
  end

end