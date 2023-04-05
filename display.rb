# frozen_string_literal: true

class Display
  # def self.draw
  #   entities = {}
  #   frame = 1
  #
  #   loop do
  #     id, position = Ractor.receive
  #     entities[id] = position
  #
  #     area = Display.generate_area(entities)
  #     Printer.call(area, frame: frame, entities_count: entities.keys.count)
  #     frame += 1
  #     # validate_entities(entities)
  #
  #     sleep 0.01
  #   rescue => e
  #     puts "Exception raised: #{e.message}"
  #     puts e.backtrace
  #   end
  # end

  def self.generate_area(entities)
    width, height = BOARD_SIZE.x, BOARD_SIZE.y
    result = height.times.map { "□" * width }

    entities.each_pair do |id, position|
      result[position.y][position.x] = get_symbol("✱", id) # "Ⓐ"

      result[position.y][position.x - 1] = "["
      result[position.y][position.x + 1] = "]"
    end

    result.map(&:freeze).freeze
  end

  def self.validate_entities(entities)
    all_positions = entities.map(&:position)

    raise if all_positions.uniq.count != all_positions.count
  end

  def self.get_symbol(s, iter)
    return s if iter == 0

    get_symbol(s.succ, iter - 1)
  end
end