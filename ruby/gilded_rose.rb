class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      case item.name
      when "Aged Brie"
        handle_aged_brie(item)
      when "Backstage passes to a TAFKAL80ETC concert"
        handle_backstage_passes(item)
      when "Sulfuras, Hand of Ragnaros"
        # Sulfuras never alters
      when "Conjured Mana Cake"
        handle_conjured(item)
      else
        handle_normal_item(item)
      end
    end
  end

  private

  def handle_aged_brie(item)
    item.quality = [item.quality + 1, 50].min if item.quality < 50
    item.sell_in -= 1
  end

  def handle_backstage_passes(item)
    if item.sell_in > 0
      if item.sell_in <= 5
        item.quality = [item.quality + 3, 50].min
      elsif item.sell_in <= 10
        item.quality = [item.quality + 2, 50].min
      else
        item.quality = [item.quality + 1, 50].min
      end
    else
      item.quality = 0
    end
    item.sell_in -= 1
  end

  def handle_conjured(item)
    decrease_quality(item, 2)
    item.sell_in -= 1
  end

  def handle_normal_item(item)
    decrease_quality(item, item.sell_in > 0 ? 1 : 2)
    item.sell_in -= 1
  end

  def decrease_quality(item, value)
    item.quality -= value if item.quality > 0 && item.name != "Sulfuras, Hand of Ragnaros"
    item.quality = 0 if item.quality < 0
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

