brand_profile = BrandProfile.find_by!(brand_name: "Wilson Padel Brasil")

categories = [
  { name: "Raquetes",   color: "#3628c5", icon: "shield-fill",  position: 1 },
  { name: "Calçados",   color: "#134e5e", icon: "stars",        position: 2 },
  { name: "Vestuário",  color: "#8360c3", icon: "person-fill",  position: 3 },
  { name: "Acessórios", color: "#203a43", icon: "box-fill",     position: 4 },
  { name: "Nutrição",   color: "#2ebf91", icon: "droplet-fill", position: 5 },
  { name: "Bolas",      color: "#4ade80", icon: "circle-fill",  position: 6 },
  { name: "Outros",     color: "#0f3460", icon: "grid-fill",    position: 7 }
]

cats = categories.each_with_object({}) do |attrs, map|
  cat = BrandProductCategory.find_or_create_by!(brand_profile: brand_profile, name: attrs[:name]) do |c|
    c.color    = attrs[:color]
    c.icon     = attrs[:icon]
    c.position = attrs[:position]
  end
  map[attrs[:name]] = cat
end

puts "  #{cats.size} categories"

products = [
  { name: "Raquete Wilson Pro Staff v2", category: "Raquetes",   price_cents: 89900, status: "active", position: 1, description: "Raquete profissional para alto rendimento." },
  { name: "Tênis Wilson Rush Pro 4.0",  category: "Calçados",   price_cents: 64900, status: "active", position: 2, description: "Tênis de alta performance para quadra indoor." },
  { name: "Camiseta Wilson Dry Fit",    category: "Vestuário",  price_cents: 18900, status: "active", position: 3, description: "Camiseta respirável para treinos intensos." },
  { name: "Overgrip Wilson Pro Pack",   category: "Acessórios", price_cents:  3900, status: "active", position: 4, description: "Pack com 12 overgrips antiderrapantes." },
  { name: "Bola Wilson Championship",   category: "Bolas",      price_cents:  5900, status: "draft",  position: 5, description: nil }
]

products.each do |attrs|
  BrandProduct.find_or_create_by!(brand_profile: brand_profile, name: attrs[:name]) do |p|
    p.brand_product_category = cats[attrs[:category]]
    p.price_cents             = attrs[:price_cents]
    p.status                  = attrs[:status]
    p.position                = attrs[:position]
    p.description             = attrs[:description]
  end
end

puts "  #{products.size} products"
