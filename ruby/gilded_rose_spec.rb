require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe "#update_quality" do
    context "with normal item 'foo'" do
      it "does not change the name" do
        items = [Item.new("foo", 0, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].name).to eq "foo"
      end

      it "updates quality and sell_in correctly" do
        items = [Item.new("foo", 5, 10)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 4
        expect(items[0].quality).to eq 9
      end

      it "handles quality degradation after sell_in date" do
        items = [Item.new("foo", 0, 10)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq(-1)
        expect(items[0].quality).to eq 8
      end

      it "ensures quality is never negative" do
        items = [Item.new("foo", 5, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 4
        expect(items[0].quality).to eq 0
      end
    end

    context "with Aged Brie" do
      it "increases in quality over time" do
        items = [Item.new("Aged Brie", 5, 10)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 4
        expect(items[0].quality).to eq 11
      end

      it "ensures quality never exceeds 50" do
        items = [Item.new("Aged Brie", 5, 50)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 4
        expect(items[0].quality).to eq 50
      end
    end

    context "with Backstage passes" do
      it "increases in quality as sell_in approaches" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 10)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 10
        expect(items[0].quality).to eq 11
      end

      it "doubles in quality within 10 days of sell_in" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 10)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 9
        expect(items[0].quality).to eq 12
      end

      it "triples in quality within 5 days of sell_in" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 10)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 4
        expect(items[0].quality).to eq 13
      end

      it "drops to 0 in quality after the concert" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 10)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq(-1)
        expect(items[0].quality).to eq 0
      end
    end

    context "with Conjured Mana Cake" do
      it "decreases in quality twice as fast" do
        items = [Item.new("Conjured Mana Cake", 5, 10)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 4
        expect(items[0].quality).to eq 8
      end
    end

    context "with Sulfuras" do
      it "never alters in quality or sell_in" do
        items = [Item.new("Sulfuras, Hand of Ragnaros", 5, 10)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 5
        expect(items[0].quality).to eq 10
      end
    end
  end
end
