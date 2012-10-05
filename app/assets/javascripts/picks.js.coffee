$ ->
  $('#pick_sets_dark_ages').prop('disabled', true)
  $('#promo_details').hide() unless $('#pick_sets_promo').prop('checked')
  $('#pick_sets_promo').bind 'change', ->
    if $(@).prop('checked')
      $('#promo_details').slideDown().prop('disabled', false)
    else
      $('#promo_details').slideUp().prop('disabled', true)
  .trigger('change')
  $('#cost_details').hide() unless $('#pick_cost_condition_manual').prop('checked')
  $('input[name="pick[cost_condition]"]').bind 'change', ->
    if $('#pick_cost_condition_manual').prop('checked')
      $('#cost_details').slideDown().prop('disabled', false)
    else
      $('#cost_details').slideUp().prop('disabled', true)
  .trigger('change')
  null
