# frozen_string_literal: true

class StoreProductService
  CATEGORIES = [
    { key: "todos",      label: "Todos"      },
    { key: "paletas",    label: "Paletas"    },
    { key: "bolas",      label: "Bolas"      },
    { key: "bolsas",     label: "Bolsas"     },
    { key: "vestuario",  label: "Vestuário"  },
    { key: "acessorios", label: "Acessórios" }
  ].freeze

  StoreProduct = Struct.new(
    :id, :name, :brand, :price, :original_price,
    :category, :badge, :color, :description,
    keyword_init: true
  )

  # TODO: replace with real Product.all query
  def self.all
    mock_products
  end

  def self.find(id)
    all.find { |p| p.id == id.to_i }
  end

  class << self
    private

    def mock_products
      [
        StoreProduct.new(id: 1,  name: "Vertex Pro Carbon",    brand: "Head",       price: 899.90,  original_price: nil,     category: "paletas",    badge: "Mais vendido", color: "#3628c5",
          description: "Paleta de alto desempenho com face em fibra de carbono 100%. Ideal para jogadores avançados que buscam potência e controle máximos em cada jogada."),
        StoreProduct.new(id: 2,  name: "Alpha Control 3K",     brand: "Bullpadel",  price: 699.90,  original_price: 849.90,  category: "paletas",    badge: "Oferta",       color: "#0f3460",
          description: "Paleta de controle com núcleo em EVA soft e frame em carbono 3K. Perfeita para jogadores de nível intermediário que priorizam precisão."),
        StoreProduct.new(id: 3,  name: "Speed Motion 2.0",     brand: "Adidas",     price: 749.00,  original_price: nil,     category: "paletas",    badge: "Novo",         color: "#134e5e",
          description: "Design aerodinâmico com face em carbono Diamond e núcleo Softcore. Equilíbrio perfeito entre velocidade e precisão para jogadores em evolução."),
        StoreProduct.new(id: 4,  name: "Thunder Titanium",     brand: "Nox",        price: 549.90,  original_price: nil,     category: "paletas",    badge: nil,            color: "#3a1c71",
          description: "Paleta com camada externa em fibra de vidro titanizada. Excelente relação custo-benefício para iniciantes e jogadores em progressão."),
        StoreProduct.new(id: 5,  name: "Storm Power Elite",    brand: "Babolat",    price: 1199.00, original_price: nil,     category: "paletas",    badge: "Premium",      color: "#c94b4b",
          description: "Topo de linha com fibra de carbono 18K e núcleo em EVA Ultra Power. Para jogadores profissionais que exigem o máximo de cada tacada."),

        StoreProduct.new(id: 6,  name: "Pro S Speed",          brand: "Dunlop",     price: 59.90,   original_price: nil,     category: "bolas",      badge: nil,            color: "#4ade80",
          description: "Bola oficial de padel certificada e pressurizada para alta performance. Indicada tanto para partidas quanto para treinos regulares."),
        StoreProduct.new(id: 7,  name: "X-One Endurance",      brand: "Tecnifibre", price: 69.90,   original_price: nil,     category: "bolas",      badge: "Mais vendido", color: "#38ef7d",
          description: "Bola de longa duração com tecnologia de pressurização avançada. Ideal para sessões intensivas de treino com manutenção de performance."),
        StoreProduct.new(id: 8,  name: "Competition Ball x3",  brand: "Head",       price: 54.90,   original_price: 64.90,   category: "bolas",      badge: "Oferta",       color: "#11998e",
          description: "Kit com 3 bolas de competição de alta visibilidade. Performance consistente e previsível em todas as condições de jogo."),

        StoreProduct.new(id: 9,  name: "Tour Carry Bag 2.0",   brand: "Bullpadel",  price: 279.90,  original_price: nil,     category: "bolsas",     badge: "Novo",         color: "#f7971e",
          description: "Bolsa esportiva com compartimento para 3 paletas, bolso térmico para bolas e espaço amplo para equipamentos e vestuário."),
        StoreProduct.new(id: 10, name: "Mochila Padel Pro",    brand: "Adidas",     price: 219.00,  original_price: nil,     category: "bolsas",     badge: nil,            color: "#fc4a1a",
          description: "Mochila ergonômica de 25L com suporte acolchoado para paleta e múltiplos compartimentos organizadores para seus acessórios."),
        StoreProduct.new(id: 11, name: "Paletero Individual",  brand: "Head",       price: 149.90,  original_price: 189.90,  category: "bolsas",     badge: "Oferta",       color: "#ee0979",
          description: "Paletero compacto com proteção rígida lateral e alça ajustável. Leve e prático para transportar sua paleta com segurança."),

        StoreProduct.new(id: 12, name: "Camiseta DriFit Padel", brand: "Nike",      price: 129.90,  original_price: nil,     category: "vestuario",  badge: nil,            color: "#8360c3",
          description: "Camiseta de performance com tecido Dri-FIT de secagem rápida, corte ergonômico e proteção UV 50+. Conforto máximo durante o jogo."),
        StoreProduct.new(id: 13, name: "Short Performance",    brand: "Adidas",     price: 119.00,  original_price: nil,     category: "vestuario",  badge: "Novo",         color: "#2ebf91",
          description: "Short de alta performance com tecido elástico 4 direções, bolsos funcionais e cintura ajustável. Total liberdade de movimento."),

        StoreProduct.new(id: 14, name: "Overgrip Premium x3",  brand: "Wilson",     price: 29.90,   original_price: nil,     category: "acessorios", badge: nil,            color: "#203a43",
          description: "Kit com 3 overgrips de alta absorção e tack superior. Proporciona aderência máxima e conforto durante toda a partida."),
        StoreProduct.new(id: 15, name: "Munhequeira Pro",      brand: "Babolat",    price: 49.90,   original_price: nil,     category: "acessorios", badge: nil,            color: "#0f2027",
          description: "Munhequeira de alta absorção em terry loop com compressão confortável. Mantém o suor longe da paleta durante treinos e jogos."),
        StoreProduct.new(id: 16, name: "Protetor de Paleta",   brand: "Nox",        price: 39.90,   original_price: nil,     category: "acessorios", badge: "Mais vendido", color: "#134e5e",
          description: "Protetor de borda em silicone resistente. Preserva o frame da sua paleta contra impactos com o chão e as paredes."),
      ]
    end
  end
end
