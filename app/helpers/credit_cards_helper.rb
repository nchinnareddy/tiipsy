module CreditCardsHelper
  def cc_mask(number)
    last_digits = number.to_s.slice(-4..-1)
    mask = "XXXX-XXXX-XXXX-#{last_digits}"
  end
end
