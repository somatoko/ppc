defmodule Ppc.Subscription.ShippingDetail do
  alias Ppc.Subscription.ShippingDetail.{Name, Address}

  defstruct [
    :name,
    :address
  ]

  @type t :: %__MODULE__{
          name: Name.t(),
          address: Address.t()
        }
end
