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
    entities = {}

    loop do
      entities = Ractor.receive
      move!(neighbors: entities.except(id))

      Ractor.yield([id, position])
      sleep(0.1)
    rescue => e
      puts "Exception raised: #{e.message}"
      puts e.backtrace
    end
  end

  private

  attr_reader :position, :id

  def move!(neighbors:)
    @position = generate_new_position(neighbors: neighbors, attempts: 10) || position
  end

  def generate_new_position(neighbors:, attempts:)
    while attempts.positive? do
      attempts -= 1
      possible_position = position + random_vector

      next if position_out_of_area?(possible_position)
      next if collision_with_others?(possible_position, neighbors: neighbors)

      return possible_position
    end
  end

  def random_vector
    VECTOR.new(
      x: rand(-1..1),
      y: rand(-1..1)
    )
  end

  def position_out_of_area?(position)
    position.x <= 0 || position.x >= BOARD_SIZE.x - 1 ||
      position.y <= 0 || position.y >= BOARD_SIZE.y - 1
  end

  def collision_with_others?(position, neighbors:)
    safe_zone = VECTOR.new(
      x: (position.x - 2)..(position.x + 2),
      y: (position.y - 1)..(position.y + 1)
    )

    neighbors.any? do |(_, neighbor)|
      safe_zone.x.include?(neighbor.x) &&
        safe_zone.y.include?(neighbor.y)
    end
  end
end
