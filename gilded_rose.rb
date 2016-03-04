require './item.rb'

class BaseItemHandler
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update
    update_quality
    update_sell_in
  end

  private

  def update_quality
  end

  def update_sell_in
  end
end

class DefaultItemHandler < BaseItemHandler
  private

  def update_quality
    if item.sell_in > 0
      quality = item.quality - 1
    else
      quality = item.quality - 2
    end
    item.quality = quality if quality >= 0
  end

  def update_sell_in
    item.sell_in -= 1
  end
end

class BackstagePassesHandler < BaseItemHandler
  private

  def update_quality
    quality = if item.sell_in > 10
                item.quality + 1
              elsif item.sell_in > 5
                item.quality + 2
              elsif item.sell_in > 0
                item.quality + 3
              else
                0
              end

    item.quality = quality if quality <= 50
    item.quality = 50 if quality > 50
  end
end

class SulfurasHandler < BaseItemHandler
end

class AgedBrieHandler < BaseItemHandler
  private

  def update_quality
    if item.sell_in > 0
      quality = item.quality + 1
    else
      quality = item.quality + 2
    end

    item.quality = quality if quality <= 50
  end

  def update_sell_in
    item.sell_in -= 1
  end
end

class ConjuredManaCakeHandler < BaseItemHandler
  private

  def update_quality
    quality = item.quality - 2
    item.quality = quality if quality >= 0
  end

  def update_sell_in
    item.sell_in -= 1
  end
end


class ItemMapper
  attr_reader :item

  MAP = {
    'Aged Brie'                                 => AgedBrieHandler,
    'Sulfuras, Hand of Ragnaros'                => SulfurasHandler,
    'Backstage passes to a TAFKAL80ETC concert' => BackstagePassesHandler,
    'Conjured Mana Cake'                        => ConjuredManaCakeHandler,
  }

  def initialize(item)
    @item = item
  end

  def update
    handler.new(item).update
  end

  def self.update(item)
    new(item).update
  end

  private

  def handler
    @handler ||= MAP[item.name] || DefaultItemHandler
  end
end





class GildedRose

  def update_quality(items)
  items.each do |item|
    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if item.quality > 0
        if item.name != 'Sulfuras, Hand of Ragnaros'
          item.quality -= 1
        end
      end
    else
      if item.quality < 50
        item.quality += 1
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.sell_in < 11
            if item.quality < 50
              item.quality += 1
            end
          end
          if item.sell_in < 6
            if item.quality < 50
              item.quality += 1
            end
          end
        end
      end
    end
    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.sell_in -= 1
    end
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality > 0
            if item.name != 'Sulfuras, Hand of Ragnaros'
              item.quality -= 1
            end
          end
        else
          item.quality = item.quality - item.quality
        end
      else
        if item.quality < 50
          item.quality += 1
        end
      end
    end
  end
end

end
