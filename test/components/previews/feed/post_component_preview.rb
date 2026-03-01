# @label Post
# @logical_path feed/post
class Feed::PostComponentPreview < Lookbook::Preview
  layout "dashboard"

  # @label Com imagem
  # Post com foto, legenda e contadores de curtidas/comentários.
  def with_image
    render Feed::PostComponent.new(post: post_with_image, current_user: mock_user)
  end

  # @label Sem imagem
  # Post somente de texto, sem mídia.
  def text_only
    render Feed::PostComponent.new(post: post_text_only, current_user: mock_user)
  end

  # @label Curtido
  # Post já curtido pelo usuário atual.
  def liked
    render Feed::PostComponent.new(post: post_liked, current_user: mock_user)
  end

  # @label Conta oficial
  # Post de conta oficial com badge de verificado.
  def official
    render Feed::PostComponent.new(post: post_official, current_user: mock_user)
  end

  private

  def base_post(overrides = {})
    FeedPostService::FeedPost.new({
      id: 1,
      author_name: "Carlos Silva",
      author_username: "carlospadel",
      author_initials: "CS",
      author_official: false,
      author_avatar_url: nil,
      body: "Treino incrível hoje no clube! Trabalhando o bandeja e o vibora. 💪",
      image_url: nil,
      likes_count: 34,
      comments_count: 6,
      created_at: 2.hours.ago,
      liked: false
    }.merge(overrides))
  end

  def post_with_image
    base_post(image_url: "https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=560&q=80")
  end

  def post_text_only
    base_post
  end

  def post_liked
    base_post(liked: true, likes_count: 35)
  end

  def post_official
    base_post(
      author_name: "Padeex",
      author_username: "padeex",
      author_initials: "PX",
      author_official: true,
      body: "🎾 Bem-vindo ao Padeex! Acompanhe torneios, reserve quadras e conecte-se com a comunidade do padel brasileiro.",
      likes_count: 128,
      comments_count: 14
    )
  end

  def mock_user
    User.first || OpenStruct.new(id: 0, name: "Preview User")
  end
end
