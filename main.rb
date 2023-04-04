# frozen_string_literal: true

require 'ostruct'
require 'byebug'

require_relative 'vector'
require_relative 'printer'
require_relative 'entity'
require_relative 'display'
require_relative 'gamer'

# TracePoint.trace(:call, :line, :return) do |tp|
#   p [tp.lineno, tp.defined_class, tp.method_id, tp.event]
# end

BOARD_SIZE = VECTOR.new(x: 30, y: 30).freeze

class Life
  def self.run
    entity_ractors = spawn_entities(count: 20)

    frame = 0

    loop do
      entities = entity_ractors.map(&:take)
      image = Display.generate_image(entities)
      Printer.call(image, frame: frame)
      frame += 1

      entity_ractors.each { _1.send(image, move: true) }
    end
  end

  def self.spawn_entities(count:)
    count.times.each_with_index.map do |id|
      Ractor.new(id) do |id|
        Entity.spawn(id)
      end
    end
  end
end

Life.run

