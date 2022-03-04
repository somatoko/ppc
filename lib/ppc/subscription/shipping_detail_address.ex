defmodule Ppc.Subscription.ShippingDetailAddress do
  defstruct [
    :address_line_1,
    :address_line_2,
    :admin_area_1,
    :admin_area_2,
    :postal_code,
    :country_code
  ]

  @type t :: %__MODULE__{
          address_line_1: String.t(),
          address_line_2: String.t(),
          admin_area_1: String.t(),
          admin_area_2: String.t(),
          postal_code: String.t(),
          country_code: String.t()
        }
end
