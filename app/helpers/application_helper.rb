# -*- encoding: utf-8 -*-
module ApplicationHelper
  def picked_tweet_text(cards)
    connector = I18n.t('picked_tweet.cards_connector', default: [:'support.array.words_connector', ', '])
    I18n.t('picked_tweet.format', cards: cards.map(&:name_t).join(connector).truncate(110, omission: '…'))
  end
end
