defmodule Ppc.Subscription.ShippingDetailName do
  defstruct [
    :full_name
  ]

  @type t :: %__MODULE__{
          full_name: String.t()
        }
end
