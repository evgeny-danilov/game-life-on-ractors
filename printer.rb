# frozen_string_literal: true

class Printer
  def self.call(image, frame: nil, entities_count: nil)
    clear_console
    move_cursor_to_the_top

    image.each do |row|
      p row
    end

    p "Frame: #{frame}" if frame
    p "Entities count: #{entities_count}" if entities_count
  end

  private

  def self.clear_console
    print "\e[2J"
  end

  def self.move_cursor_to_the_top
    print "\e[H"
  end
end
