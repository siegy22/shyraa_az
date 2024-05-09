class Statistics
  def challenge_finished?
    current_champion.nil?
  end

  def total_games
    Match.count
  end

  def winrate
    return 0 if Match.count.zero?

    (Match.where(win: true).count / Match.count.to_f * 100).round
  end

  START_DATE = Date.parse("2024-05-09")
  def duration
    (Date.today - START_DATE).to_i.days
  end

  def finished_champions
    champions.having("COUNT(*) FILTER (WHERE win = TRUE) > 0")
  end

  def total_champions
    Champion
  end

  def current_champion
    Champion.where.not(id: finished_champions.map(&:champion_id)).order(name: :asc).first
  end

  def previous_champions
    return Champion.order(name: :asc) if challenge_finished?

    Champion.where("name < ?", current_champion.name).order(name: :desc)
  end

  def next_champions
    return Champion.none if challenge_finished?

    Champion.where("name > ?", current_champion.name).order(name: :asc)
  end

  def champions
    Match.select(
      <<-SQL
champion_id,
COUNT(*) AS matches_played,
COUNT(*) FILTER (WHERE win = TRUE) as matches_won,
SUM(kills) as kills,
SUM(deaths) as deaths,
SUM(assists) as assists,
AVG(cs_per_minute) AS cs_per_minute,
MIN(champions.name) as champion_name,
MIN(champions.riot_id) as champion_riot_id
SQL
    ).group(:champion_id).joins(:champion).order(matches_played: :desc, champion_name: :asc)
  end
end
