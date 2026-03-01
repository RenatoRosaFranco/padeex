# frozen_string_literal: true

class FeedPostService
  FeedPost = Struct.new(
    :id, :author_name, :author_username, :author_initials,
    :author_official, :author_avatar_url,
    :body, :image_url, :likes_count, :comments_count,
    :created_at, :liked,
    keyword_init: true
  )

  # TODO: replace mock with real query:
  #   Post.from_followed_users(user)
  #     .or(Post.from_official_accounts)
  #     .order(created_at: :desc)
  #     .includes(:author)
  #     .limit(20)
  def self.for_user(_user)
    mock_posts
  end

  class << self
    private

    def mock_posts
      [
        FeedPost.new(
          id: 1,
          author_name: "Padeex",
          author_username: "padeex",
          author_initials: "PX",
          author_official: true,
          author_avatar_url: nil,
          body: "Bem-vindo ao Padeex! Acompanhe torneios, reserve quadras e conecte-se com a comunidade do padel brasileiro. 🎾",
          image_url: "https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=560&q=80",
          likes_count: 128,
          comments_count: 14,
          created_at: 2.hours.ago,
          liked: false
        ),
        FeedPost.new(
          id: 2,
          author_name: "Carlos Silva",
          author_username: "carlospadel",
          author_initials: "CS",
          author_official: false,
          author_avatar_url: nil,
          body: "Treino incrível hoje no clube! Trabalhando o bandeja e o vibora. Quem quiser um racha, me chama! 💪",
          image_url: nil,
          likes_count: 34,
          comments_count: 6,
          created_at: 5.hours.ago,
          liked: true
        ),
        FeedPost.new(
          id: 3,
          author_name: "Padeex",
          author_username: "padeex",
          author_initials: "PX",
          author_official: true,
          author_avatar_url: nil,
          body: "🏆 Novo torneio disponível em São Paulo! Inscrições abertas até dia 10. Corra e garanta sua vaga.",
          image_url: "https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=560&q=80",
          likes_count: 87,
          comments_count: 22,
          created_at: 1.day.ago,
          liked: false
        ),
        FeedPost.new(
          id: 4,
          author_name: "Ana Rodrigues",
          author_username: "anapadel",
          author_initials: "AR",
          author_official: false,
          author_avatar_url: nil,
          body: "Primeira vitória no torneio feminino do Padeex! 🥇 Muito obrigada a todos que torceram. Essa conquista é nossa!",
          image_url: nil,
          likes_count: 61,
          comments_count: 18,
          created_at: 2.days.ago,
          liked: false
        )
      ]
    end
  end
end
