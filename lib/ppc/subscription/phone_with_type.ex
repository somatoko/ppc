defmodule Ppc.Subscription.PhoneWithType do
  defstruct [
    :phone_type,
    :phone_number
  ]

  @type phone_type :: :fax | :home | :mobile | :other | :pager

  @type t :: %__MODULE__{
          phone_type: phone_type(),
          phone_number: String.t()
        }
end
