class Url
  attr_reader :thor, :cosmos, :midgard, :reference

  def initialize(url:)
    @thor = url[:thor]
    @cosmos = url[:thor].gsub('thorchain', 'cosmos')
    @midgard = url[:midgard]
    @reference = {
      thor: url[:reference]
    }
  end
end
