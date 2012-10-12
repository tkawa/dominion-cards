# -*- encoding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

File.open('log/data.dat', 'r:CP932:UTF-8', invalid: :replace) do |f|
  f.each_line do |l|
    Card.create! do |c|
      splits = l.chomp.split(',')
      c.id = splits[0].to_i
      c.name_j = splits[1]
      c.description = splits[15]
      c.kana = splits[19]
      c.name = splits[20]
      c.set = splits[21]
      c.cost = splits[22].to_i unless splits[22] == '-'
      c.potion = splits[23].to_i unless splits[23] == '-'
      c.division = splits[24]
      c.kind = splits[25]
      c.treasure = splits[26].to_i unless splits[26] == '-'
      if splits[27].delete!('▲')
        c.victory = splits[27].to_i * (-1)
      elsif splits[27] != '-'
        c.victory = splits[27].to_i
      end
      c.cards = splits[28].to_i unless splits[28] == '-'
      c.actions = splits[29].to_i unless splits[29] == '-'
      c.buys = splits[30].to_i unless splits[30] == '-'
      c.coins = splits[31].to_i unless splits[31] == '-'
      c.vp_tokens = splits[32].to_i unless splits[32] == '-'
    end
  end
end

#File.open('log/recommended.dat') do |f|
#  f.each_line do |l|
#    p = PickName.build_from_names(l.chomp)
#    p.save!
#  end
#end
