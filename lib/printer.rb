# frozen_string_literal: true

class Printer
  def self.call(area, frame: nil, entities_count: nil)
    clear_console
    move_cursor_to_the_top

    area.each do |row|
      puts row
    end

    puts "Frame: #{frame}" if frame
    puts "Entities count: #{entities_count}" if entities_count
  end

  private

  def self.clear_console
    print "\e[2J"
  end

  def self.move_cursor_to_the_top
    print "\e[H"
  end
end
