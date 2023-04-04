# frozen_string_literal: true

class Entity
  attr_reader :position, :id

  def initialize(id)
    @position = VECTOR.new(x: rand(BOARD_SIZE.x), y: rand(BOARD_SIZE.y))
    @id = id
    DISPLAY.send([@id, @position])
  end

  def x = position.x
  def y = position.y

  def movement
    loop do
      move!
      DISPLAY.send([id, position])
      sleep(0.1)
    rescue => e
      puts "Exception raised: #{e.message}"
      puts e.backtrace
    end
  end

  def move!
    possible_position = position + random_vector
    return if invalid_position?(possible_position)

    @position = possible_position
  end

  private

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
