# frozen_string_literal: true

class Dashboard::RankingController < Dashboard::BaseController
  def index
    @ranking = mock_ranking
    @current_position = @ranking.find_index { |p| p[:id] == current_user.id }&.+(1)
    @current_entry    = @ranking.find { |p| p[:id] == current_user.id }
  end

  private

  def mock_ranking
    [
      { id: nil, name: "Lucas Fernandez",   username: "lucasfernandez",  level: "A",   points: 3840, wins: 42, losses: 6,  avatar: nil, gender: "masculine" },
      { id: nil, name: "Mariana Costa",     username: "maricosta",       level: "A",   points: 3710, wins: 39, losses: 9,  avatar: nil, gender: "feminine"  },
      { id: nil, name: "Rafael Souza",      username: "rafaelsouza",     level: "A",   points: 3590, wins: 37, losses: 11, avatar: nil, gender: "masculine" },
      { id: nil, name: "Amanda Oliveira",   username: "amandaolive",     level: "B+",  points: 3420, wins: 34, losses: 12, avatar: nil, gender: "feminine"  },
      { id: nil, name: "Gabriel Alves",     username: "gabalves",        level: "B+",  points: 3310, wins: 32, losses: 14, avatar: nil, gender: "masculine" },
      { id: nil, name: "Fernanda Lima",     username: "fernandalima",    level: "B+",  points: 3150, wins: 30, losses: 15, avatar: nil, gender: "feminine"  },
      { id: nil, name: "Rodrigo Pereira",   username: "rodrigopereira",  level: "B",   points: 2980, wins: 27, losses: 17, avatar: nil, gender: "masculine" },
      { id: nil, name: "Juliana Martins",   username: "jumartins",       level: "B",   points: 2840, wins: 25, losses: 18, avatar: nil, gender: "feminine"  },
      { id: nil, name: "Thiago Barbosa",    username: "thiagob",         level: "B",   points: 2720, wins: 23, losses: 20, avatar: nil, gender: "masculine" },
      { id: nil, name: "Carolina Santos",   username: "carolsantos",     level: "B",   points: 2610, wins: 22, losses: 21, avatar: nil, gender: "feminine"  },
      { id: nil, name: "Diego Nunes",       username: "diegonunes",      level: "C",   points: 2490, wins: 20, losses: 22, avatar: nil, gender: "masculine" },
      { id: nil, name: "Patricia Rocha",    username: "patrocha",        level: "C",   points: 2380, wins: 19, losses: 23, avatar: nil, gender: "feminine"  },
      { id: nil, name: "Felipe Carvalho",   username: "felipecarv",      level: "C",   points: 2260, wins: 17, losses: 24, avatar: nil, gender: "masculine" },
      { id: nil, name: "Larissa Freitas",   username: "larisfreitas",    level: "C",   points: 2140, wins: 16, losses: 25, avatar: nil, gender: "feminine"  },
      { id: nil, name: "Henrique Dias",     username: "henriquedias",    level: "C",   points: 2020, wins: 14, losses: 27, avatar: nil, gender: "masculine" },
    ]
  end
end
