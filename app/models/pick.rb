class Pick
  @@pascals = [[1]]
  1.upto(180) do |i|
    @@pascals << 1.upto(i-1).map {|j| @@pascals[i-1][j-1] + @@pascals[i-1][j] }.unshift(1).push(1)
  end
  def self.combination(n, r)
    (n < r) ? 0 : @@pascals[n][r]
  end

  def self.card_ids_to_pick_id(card_ids)
    raise ArgumentError.new('array size is not 10') unless card_ids.size == 10
    result = 0
    card_ids.map(&:to_i).sort.each_with_index {|id, index| result += combination(id, index + 1) }
    result
  end
  def self.pick_id_to_card_ids(pick_id)
    raise ArgumentError.new('number is too large') if pick_id >= self.combination(180, 10)
    card_ids = []
    10.downto(1) do |r|
      n = r-1
      n += 1 until combination(n, r) > pick_id
      card_ids << n-1
      pick_id -= combination(n-1, r)
    end
    card_ids.sort
  end
end