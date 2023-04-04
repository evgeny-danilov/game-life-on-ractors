# frozen_string_literal: true

class Entity

  def self.spawn(id)
    new(id).run
  end

  def initialize(id)
    @position = VECTOR.new(x: rand(BOARD_SIZE.x), y: rand(BOARD_SIZE.y))
    @id = id
  end

  def run
    loop do
      move!
      Ractor.yield([id, position])
      # sleep(0.1)
    rescue => e
      puts "Exception raised: #{e.message}"
      puts e.backtrace
    end
  end

  private

  attr_reader :position, :id

  def move!
    possible_position = position + random_vector
    return if invalid_position?(possible_position)

    @position = possible_position
  end

  def random_vector
    VECTOR.new(
      x: rand(-1..1),
      y: rand(-1..1)
    )
  end

  def invalid_position?(position)
    position.x <= 0 || position.x >= BOARD_SIZE.x - 1 ||
      position.y <= 0 || position.y >= BOARD_SIZE.y - 1
  end
end
