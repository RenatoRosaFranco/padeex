# frozen_string_literal: true

class FeedStoryService
  GRADIENTS = [
    "linear-gradient(160deg, #3628c5 0%, #4ade80 100%)",
    "linear-gradient(160deg, #3a1c71 0%, #d76d77 50%, #ffaf7b 100%)",
    "linear-gradient(160deg, #0575e6 0%, #021b79 100%)",
    "linear-gradient(160deg, #f7971e 0%, #ffd200 100%)",
    "linear-gradient(160deg, #11998e 0%, #38ef7d 100%)",
    "linear-gradient(160deg, #ee0979 0%, #ff6a00 100%)",
    "linear-gradient(160deg, #8360c3 0%, #2ebf91 100%)",
    "linear-gradient(160deg, #c94b4b 0%, #4b134f 100%)",
    "linear-gradient(160deg, #134e5e 0%, #71b280 100%)",
    "linear-gradient(160deg, #0f2027 0%, #203a43 50%, #2c5364 100%)",
    "linear-gradient(160deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%)",
    "linear-gradient(160deg, #fc4a1a 0%, #f7b733 100%)",
  ].freeze

  FeedStory = Struct.new(
    :id, :author_name, :author_username, :author_initials,
    :author_avatar_url, :image_url, :gradient, :time_label, :seen,
    keyword_init: true
  )

  # TODO: replace mock with real query:
  #   Story.from_followed_users(user)
  #     .where("expires_at > ?", Time.current)
  #     .order(seen_at: :asc, created_at: :desc)
  #     .includes(:author)
  def self.for_user(_user)
    mock_stories
  end

  class << self
    private

    def mock_stories
      [
        { id: 1,  name: "Padeex",           username: "padeex",       initials: "PX", seen: false, time: "agora"    },
        { id: 2,  name: "Carlos Silva",      username: "carlospadel",  initials: "CS", seen: false, time: "2h"       },
        { id: 3,  name: "Ana Rodrigues",     username: "anapadel",     initials: "AR", seen: true,  time: "4h"       },
        { id: 4,  name: "Pedro Alves",       username: "pedropadel",   initials: "PA", seen: false, time: "1h"       },
        { id: 5,  name: "Juliana Costa",     username: "jucosta",      initials: "JC", seen: true,  time: "6h"       },
        { id: 6,  name: "Ricardo Mendes",    username: "ricardopadel", initials: "RM", seen: false, time: "30min"    },
        { id: 7,  name: "Fernanda Lima",     username: "ferpadel",     initials: "FL", seen: false, time: "3h"       },
        { id: 8,  name: "Marcos Souza",      username: "marcospadel",  initials: "MS", seen: true,  time: "8h"       },
        { id: 9,  name: "Beatriz Nunes",     username: "bianunespadel",initials: "BN", seen: false, time: "5h"       },
        { id: 10, name: "Thiago Carvalho",   username: "thiagoc",      initials: "TC", seen: false, time: "1h"       },
        { id: 11, name: "Larissa Moura",     username: "larissamoura", initials: "LM", seen: true,  time: "10h"      },
        { id: 12, name: "Felipe Gomes",      username: "felipegpadel", initials: "FG", seen: false, time: "45min"    },
      ].each_with_index.map do |attrs, i|
        FeedStory.new(
          id:                attrs[:id],
          author_name:       attrs[:name],
          author_username:   attrs[:username],
          author_initials:   attrs[:initials],
          author_avatar_url: nil,
          image_url:         nil,
          gradient:          GRADIENTS[i % GRADIENTS.size],
          time_label:        attrs[:time],
          seen:              attrs[:seen]
        )
      end
    end
  end
end
