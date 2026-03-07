# frozen_string_literal: true

padel = Tenant.find_by!(slug: "padel")

content = <<~TEXT
  O padel é um dos esportes que mais cresce no mundo, e entender os detalhes que fazem a diferença
  entre um jogador mediano e um jogador de alto nível é fundamental para evoluir dentro de quadra.

  Nos últimos anos, o Brasil consolidou sua posição como um dos mercados mais promissores do esporte,
  com novos clubes abrindo em todo o país e uma geração de atletas profissionais emergindo das categorias
  amadoras. Esse crescimento traz consigo novas oportunidades e desafios para quem quer se destacar.

  A PADEX nasceu justamente para conectar todos os elos desse ecossistema: atletas buscando parceiros
  de jogo, clubes querendo gerir suas operações com mais eficiência e empresas procurando formas inovadoras
  de engajar colaboradores e clientes por meio do esporte.

  Com ferramentas de rankeamento, agendamento de quadras, busca por instrutores e muito mais, a plataforma
  foi pensada para ser o hub definitivo do padel no Brasil. E isso é apenas o começo.

  Nos próximos meses, novas funcionalidades serão lançadas, incluindo análise de desempenho baseada em dados,
  sistema de torneios integrado e uma comunidade vibrante onde padelistas de todos os níveis podem se conectar,
  aprender e crescer juntos.

  Fique atento às novidades e faça parte dessa revolução do padel brasileiro.
TEXT

posts = MockData.load("posts")

posts.each do |attrs|
  Post.find_or_create_by!(title: attrs[:title], tenant: padel) do |p|
    p.excerpt      = attrs[:excerpt]
    p.cover        = attrs[:cover]
    p.author       = attrs[:author]
    p.content      = content
    p.published_at = attrs[:days_ago].days.ago
  end
end

puts "Posts: #{Post.count}"
