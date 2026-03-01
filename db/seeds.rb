# Ensure default tenant exists
Tenant.find_or_create_by!(slug: "padel") { |t| t.name = "Padel" }

Post.destroy_all

posts = [
  {
    title: "Como escolher sua primeira raquete de padel",
    excerpt: "Guia completo para iniciantes escolherem a raquete ideal para começar no esporte.",
    cover: "https://placehold.co/800x400/3628c5/ffffff?text=Raquetes+de+Padel",
    author: "Rafael Mendes",
    published_at: 45.days.ago
  },
  {
    title: "Os 10 fundamentos técnicos que todo padelista precisa dominar",
    excerpt: "Do saque ao smash, conheça os movimentos essenciais para evoluir no padel.",
    cover: "https://placehold.co/800x400/1a1042/4ade80?text=Fundamentos",
    author: "Carla Souza",
    published_at: 40.days.ago
  },
  {
    title: "Como a PADEX está revolucionando o ecossistema do padel no Brasil",
    excerpt: "Entenda como nossa plataforma conecta atletas, clubes e empresas num único lugar.",
    cover: "https://placehold.co/800x400/07080f/3628c5?text=PADEX",
    author: "Equipe PADEX",
    published_at: 35.days.ago
  },
  {
    title: "Padel para empresas: como usar o esporte para fortalecer equipes",
    excerpt: "O padel virou o novo golf corporativo. Saiba por que sua empresa deveria adotar o esporte.",
    cover: "https://placehold.co/800x400/0f1022/ffffff?text=Padel+Corporativo",
    author: "Lucas Ferreira",
    published_at: 30.days.ago
  },
  {
    title: "Guia de nutrição para padelistas: o que comer antes e depois dos jogos",
    excerpt: "Performance dentro de quadra começa na alimentação. Veja as melhores estratégias nutricionais.",
    cover: nil,
    author: "Ana Oliveira",
    published_at: 27.days.ago
  },
  {
    title: "Como montar um clube de padel rentável em 2026",
    excerpt: "Dicas práticas de gestão, infraestrutura e captação de alunos para clubes que querem crescer.",
    cover: "https://placehold.co/800x400/181a38/4ade80?text=Gestao+de+Clubes",
    author: "Lucas Ferreira",
    published_at: 24.days.ago
  },
  {
    title: "Rankeamento no padel: como funciona e como subir de nível",
    excerpt: "Entenda o sistema de ranking e as estratégias para escalar as categorias mais rápido.",
    cover: "https://placehold.co/800x400/3628c5/4ade80?text=Ranking",
    author: "Rafael Mendes",
    published_at: 21.days.ago
  },
  {
    title: "Lesões comuns no padel e como preveni-las",
    excerpt: "Cotovelo, ombro e joelho: aprenda a se proteger e alongar corretamente para jogar mais.",
    cover: "https://placehold.co/800x400/0f1022/f0f4ff?text=Saude+no+Padel",
    author: "Ana Oliveira",
    published_at: 18.days.ago
  },
  {
    title: "A evolução do padel: de esporte de nicho a fenômeno global",
    excerpt: "Em menos de 10 anos, o padel conquistou o mundo. Conheça a história por trás do crescimento.",
    cover: "https://placehold.co/800x400/07080f/4ade80?text=Historia+do+Padel",
    author: "Carla Souza",
    published_at: 15.days.ago
  },
  {
    title: "5 erros que iniciantes cometem no padel (e como corrigi-los)",
    excerpt: "Identificar os erros mais comuns é o primeiro passo para evoluir mais rápido no esporte.",
    cover: nil,
    author: "Rafael Mendes",
    published_at: 13.days.ago
  },
  {
    title: "Padel feminino: crescimento, desafios e oportunidades",
    excerpt: "O padel feminino está em franca expansão. Conheça as histórias de quem está moldando o esporte.",
    cover: "https://placehold.co/800x400/3628c5/ffffff?text=Padel+Feminino",
    author: "Carla Souza",
    published_at: 10.days.ago
  },
  {
    title: "Como a tecnologia está transformando o treino no padel",
    excerpt: "Análise de dados, vídeo e IA estão chegando ao padel. Veja como usar isso a seu favor.",
    cover: "https://placehold.co/800x400/181a38/4ade80?text=Tecnologia+e+Padel",
    author: "Equipe PADEX",
    published_at: 8.days.ago
  },
  {
    title: "Montagem de duplas: como escolher o parceiro ideal no padel",
    excerpt: "Compatibilidade técnica e psicológica fazem toda a diferença para formar uma boa dupla.",
    cover: "https://placehold.co/800x400/1a1042/ffffff?text=Duplas+no+Padel",
    author: "Lucas Ferreira",
    published_at: 6.days.ago
  },
  {
    title: "Investir em padel: por que o mercado está aquecido agora",
    excerpt: "Números, tendências e oportunidades para quem quer entrar no setor de padel como investidor.",
    cover: nil,
    author: "Equipe PADEX",
    published_at: 4.days.ago
  },
  {
    title: "Torneios amadores de padel: como se preparar e competir bem",
    excerpt: "Da inscrição à estratégia de jogo: tudo que você precisa saber para competir no amador.",
    cover: "https://placehold.co/800x400/3628c5/4ade80?text=Torneios+Amadores",
    author: "Rafael Mendes",
    published_at: 2.days.ago
  },
  {
    title: "PADEX: o que vem por aí nos próximos meses",
    excerpt: "Novas funcionalidades, parcerias e muito mais. Confira o roadmap da plataforma.",
    cover: "https://placehold.co/800x400/07080f/4ade80?text=Novidades+PADEX",
    author: "Equipe PADEX",
    published_at: 1.day.ago
  }
]

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

padel = Tenant.find_by!(slug: "padel")

posts.each do |attrs|
  Post.create!(
    title: attrs[:title],
    excerpt: attrs[:excerpt],
    cover: attrs[:cover],
    author: attrs[:author],
    content: content,
    published_at: attrs[:published_at],
    tenant: padel
  )
end

puts "Created #{Post.count} posts."
