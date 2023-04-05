# frozen_string_literal: true

class Display
  MAX_DRAWING_AREA = VECTOR.new(x: 50, y: 20)
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
    width = [BOARD_SIZE.x, MAX_DRAWING_AREA.x].min
    height = [BOARD_SIZE.y, MAX_DRAWING_AREA.y].min

    result = height.times.map { "□" * width }

    entities.each_pair do |id, position|
      next if position_over_the_board?(position)

      byebug if result[position.y].nil?

      result[position.y][position.x] = get_symbol("✱", id) # "Ⓐ"
      result[position.y][position.x - 1] = "["
      result[position.y][position.x + 1] = "]"
    end

    result.map(&:freeze).freeze
  end

  def self.position_over_the_board?(position)
    position.x >= MAX_DRAWING_AREA.x ||
      position.y >= MAX_DRAWING_AREA.y
  end

  def self.validate_entities(entities)
    all_positions = entities.map(&:position)

    raise if all_positions.uniq.count != all_positions.count
  end

  def self.get_symbol(sym, iter)
    return sym if iter == 0

    get_symbol(sym.succ, iter - 1)
  end
end